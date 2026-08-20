import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

/// A current tsunami event reported by an authoritative source (GDACS).
class TsunamiWarning {
  final String name;
  final double lat;
  final double lon;
  final String severity; // Green / Orange / Red
  const TsunamiWarning({
    required this.name,
    required this.lat,
    required this.lon,
    required this.severity,
  });
}

/// Polls GDACS for active tsunami (TS) events relevant to Sri Lanka.
///
/// GDACS aggregates official bulletins (incl. the Indian Ocean Tsunami Warning
/// System) and exposes them as GeoJSON. This is the authoritative "tsunami
/// confirmed" signal; an earthquake alone only raises an advisory.
class WarningService {
  static const String _url =
      'https://www.gdacs.org/gdacsapi/api/events/geteventlist/MAP';
  static const double _slLat = 7.8731;
  static const double _slLon = 80.7718;
  static const double _maxKm = 4000; // Indian Ocean basin relevance

  final http.Client _client;
  WarningService({http.Client? client}) : _client = client ?? http.Client();

  Future<TsunamiWarning?> fetchTsunamiWarning() async {
    try {
      final res = await _client
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final feats = data['features'] as List? ?? const [];
      for (final f in feats) {
        final p = (f as Map)['properties'] as Map? ?? const {};
        if ('${p['eventtype']}'.toUpperCase() != 'TS') continue;
        final current = p['iscurrent'];
        if (current != true && '$current'.toLowerCase() != 'true') continue;
        final coords = ((f['geometry'] as Map?)?['coordinates']) as List?;
        if (coords == null || coords.length < 2) continue;
        final lon = (coords[0] as num).toDouble();
        final lat = (coords[1] as num).toDouble();
        if (_km(lat, lon, _slLat, _slLon) > _maxKm) continue;
        return TsunamiWarning(
          name: '${p['name'] ?? p['eventname'] ?? 'Tsunami'}',
          lat: lat,
          lon: lon,
          severity: '${p['alertlevel'] ?? 'Orange'}',
        );
      }
      return null;
    } catch (_) {
      return null; // fail-safe: never raise a false alarm on error
    }
  }

  double _km(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  void dispose() => _client.close();
}
