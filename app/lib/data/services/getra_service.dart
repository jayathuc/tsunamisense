import 'dart:convert';
import 'dart:io' show gzip;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/district.dart';
import '../models/district_data.dart';
import '../models/evacuation_route.dart';
import '../models/route_strategy.dart';

/// Thrown when GETRA data cannot be fetched and no cache is available.
class GetraException implements Exception {
  final String message;
  GetraException(this.message);
  @override
  String toString() => 'GetraException: $message';
}

/// Fetches GETRA district data from the backend and caches it in Hive so the
/// app can build map layers and route fully offline during an emergency.
class GetraService {
  static const String boxName = 'getra_cache';

  final http.Client _client;
  final Duration timeout;

  // Generous so a cold-starting free Hugging Face Space (or slow first TLS on an
  // emulator) does not fail the first load. The map then caches for offline use.
  GetraService({http.Client? client, this.timeout = const Duration(seconds: 30)})
      : _client = client ?? http.Client();

  /// Open the cache box. Call once during app start-up.
  static Future<void> initCache() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  Box get _box => Hive.box(boxName);
  String get _base => ApiConstants.getraBaseUrl;

  // -- Bundled seed data ---------------------------------------------------

  /// Root of the gzipped copies of the backend's data shipped inside the app.
  /// Written by tool/sync_app_data.sh; keys match the API's endpoint names so
  /// the offline seed and the network response are interchangeable.
  static const String _assetRoot = 'assets/getra';

  /// Read one gzipped asset, or null when it is not bundled.
  ///
  /// This is what makes a first launch work with no server and no signal: the
  /// map layers and routing tables are already on the device.
  Future<String?> _asset(String path) async {
    try {
      final data = await rootBundle.load('$_assetRoot/$path');
      return utf8.decode(gzip.decode(data.buffer.asUint8List()));
    } catch (e) {
      debugPrint('[GETRA] no bundled asset $path ($e)');
      return null;
    }
  }

  Future<String> _getBody(String url) async {
    try {
      debugPrint('[GETRA] GET $url');
      final res = await _client.get(Uri.parse(url)).timeout(timeout);
      if (res.statusCode == 200) return res.body;
      throw GetraException('HTTP ${res.statusCode} for $url');
    } catch (e) {
      debugPrint('[GETRA] request FAILED: $url -> $e');
      rethrow;
    }
  }

  // -- Registry ------------------------------------------------------------

  List<District> _parseRegistry(String body) {
    final json = jsonDecode(body) as Map<String, dynamic>;
    return (json['districts'] as List)
        .map((d) => District.fromJson(d as Map<String, dynamic>))
        .toList();
  }

  /// Fetch the district registry, falling back to cache when offline.
  Future<({List<District> districts, bool fromCache})> fetchDistricts() async {
    try {
      final body = await _getBody('$_base/districts');
      await _box.put('registry', body);
      return (districts: _parseRegistry(body), fromCache: false);
    } catch (e) {
      final cached = _box.get('registry') as String?;
      if (cached != null) {
        return (districts: _parseRegistry(cached), fromCache: true);
      }
      // Nothing cached yet: fall back to the registry bundled with the app so a
      // first launch offline still gets a map instead of an error screen.
      final seed = await _asset('districts.json.gz');
      if (seed != null) {
        await _box.put('registry', seed);
        return (districts: _parseRegistry(seed), fromCache: true);
      }
      throw GetraException('No district registry available (offline, no cache).');
    }
  }

  // -- District bundle -----------------------------------------------------

  // Backend endpoint segments (no file extension): GET /districts/{id}/<name>.
  // Also used as Hive cache keys.
  List<String> _filesFor(District d) => [
        'roads',
        'inundation',
        'shelters',
        if (d.hasRouting) ...['nodes', 'evac_basin'],
      ];

  String _cacheKey(String id, String file) => '$id/$file';

  bool _hasAllCached(District d) =>
      _filesFor(d).every((f) => _box.containsKey(_cacheKey(d.id, f)));

  Future<Map<String, String>> _download(District d) async {
    final out = <String, String>{};
    for (final f in _filesFor(d)) {
      out[f] = await _getBody('$_base/districts/${d.id}/$f');
    }
    return out;
  }

  Map<String, String> _readCache(District d) => {
        for (final f in _filesFor(d))
          f: _box.get(_cacheKey(d.id, f)) as String,
      };

  /// Read a district's whole bundle from the seed assets shipped in the app.
  /// Returns null unless every file the district needs is present.
  Future<Map<String, String>?> _readSeed(District d) async {
    final out = <String, String>{};
    for (final f in _filesFor(d)) {
      final s = await _asset('${d.id}/$f.gz');
      if (s == null) return null;
      out[f] = s;
    }
    return out;
  }

  DistrictData _build(District d, Map<String, String> raw) {
    Map<String, dynamic> decode(String f) =>
        jsonDecode(raw[f]!) as Map<String, dynamic>;
    return DistrictData.parse(
      district: d,
      roadsGeojson: decode('roads'),
      inundationGeojson: decode('inundation'),
      sheltersGeojson: decode('shelters'),
      nodesJson: d.hasRouting ? decode('nodes') : null,
      basinJson: d.hasRouting ? decode('evac_basin') : null,
    );
  }

  /// Parse the cached district registry without any network call.
  List<District>? cachedDistricts() {
    final cached = _box.get('registry') as String?;
    if (cached == null) return null;
    try {
      return _parseRegistry(cached);
    } catch (_) {
      return null;
    }
  }

  /// Build a district's data purely from cache, or null if not fully cached.
  DistrictData? cachedDistrictData(District d) {
    if (!_hasAllCached(d)) return null;
    try {
      return _build(d, _readCache(d));
    } catch (_) {
      return null;
    }
  }

  /// Load one district's data. Downloads + caches when online or stale,
  /// otherwise serves the cached copy. Returns whether the cache was used.
  Future<({DistrictData data, bool fromCache})> loadDistrict(
    District d, {
    bool forceRefresh = false,
  }) async {
    final cachedVersion = _box.get(_cacheKey(d.id, 'version')) as String?;
    final hasCache = _hasAllCached(d);
    final stale = cachedVersion != d.version;

    Map<String, String>? raw;
    var fromCache = true;

    if (forceRefresh || !hasCache || stale) {
      try {
        raw = await _download(d);
        for (final entry in raw.entries) {
          await _box.put(_cacheKey(d.id, entry.key), entry.value);
        }
        await _box.put(_cacheKey(d.id, 'version'), d.version);
        await _box.put(_cacheKey(d.id, 'fetchedAt'),
            DateTime.now().toUtc().toIso8601String());
        fromCache = false;
      } catch (e) {
        if (!hasCache) {
          // No network and nothing cached: seed from the bundled copy so the
          // district still opens and routes. The version key is deliberately
          // left unset, so the next launch with a connection still refreshes.
          final seed = await _readSeed(d);
          if (seed == null) {
            throw GetraException('Cannot load ${d.name} (offline, no cache).');
          }
          for (final entry in seed.entries) {
            await _box.put(_cacheKey(d.id, entry.key), entry.value);
          }
          raw = seed;
        }
      }
    }

    raw ??= _readCache(d);
    return (data: _build(d, raw), fromCache: fromCache);
  }

  // -- Online helpers ------------------------------------------------------

  /// True when a district's bundle is already usable without the network.
  bool hasLocalBundle(District d) => _hasAllCached(d);

  /// When this district's data was last refreshed from the backend, or null if
  /// it has only ever been served from the copy bundled with the app.
  ///
  /// Hazard data can go stale: inundation extents get revised and shelter lists
  /// change. Someone routing on months-old data deserves to know.
  DateTime? lastFetched(District d) {
    final raw = _box.get(_cacheKey(d.id, 'fetchedAt')) as String?;
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  /// Per-district data versions, used to decide whether a cached bundle is
  /// stale. Much cheaper than pulling the whole registry just to compare.
  Future<Map<String, String>> fetchVersions() async {
    final body = await _getBody('$_base/version');
    final json = jsonDecode(body) as Map<String, dynamic>;
    return (json['districts'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, v as String));
  }

  /// Ask the backend to trace a route directly.
  ///
  /// Only worth calling before a district's bundle has been downloaded: it
  /// returns a route in one small request instead of waiting on several hundred
  /// kilobytes of basin data. Once the bundle is local, tracing offline is both
  /// faster and works without a signal.
  Future<EvacuationRoute> fetchRoute(
    District d,
    double lat,
    double lng,
    RouteStrategy strategy, {
    String? shelterSet,
  }) async {
    // POST rather than GET: the caller's precise coordinates travel in the body
    // instead of the URL, so they do not land in server access logs or proxy
    // caches. The backend keeps a GET form for compatibility.
    final uri = Uri.parse('$_base/districts/${d.id}/route');
    final body = jsonEncode({
      'lat': lat,
      'lng': lng,
      'strategy': strategy.id,
      if (shelterSet != null) 'set': shelterSet,
    });
    debugPrint('[GETRA] POST $uri');
    final res = await _client
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(timeout);
    if (res.statusCode != 200) {
      throw GetraException('HTTP ${res.statusCode} for $uri');
    }
    return EvacuationRoute.fromApi(
      jsonDecode(res.body) as Map<String, dynamic>,
      strategy,
    );
  }

  void dispose() => _client.close();
}
