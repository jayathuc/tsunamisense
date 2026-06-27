import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/district.dart';
import '../models/district_data.dart';

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
        fromCache = false;
      } catch (e) {
        if (!hasCache) {
          throw GetraException('Cannot load ${d.name} (offline, no cache).');
        }
      }
    }

    raw ??= _readCache(d);
    return (data: _build(d, raw), fromCache: fromCache);
  }

  void dispose() => _client.close();
}
