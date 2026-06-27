import 'package:latlong2/latlong.dart';

/// A coverage district from the GETRA registry (`/districts`).
class District {
  final String id;
  final String name;
  final List<String> capabilities; // e.g. ['map', 'routing']
  final List<double> bbox; // [minLon, minLat, maxLon, maxLat]
  final List<double> center; // [lat, lon]
  final String version;
  final Map<String, dynamic> counts;

  const District({
    required this.id,
    required this.name,
    required this.capabilities,
    required this.bbox,
    required this.center,
    required this.version,
    required this.counts,
  });

  /// Whether shelter routing is available (false = map-only district).
  bool get hasRouting => capabilities.contains('routing');

  LatLng get centerLatLng => LatLng(center[0], center[1]);

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'] as String,
      name: json['name'] as String,
      capabilities:
          (json['capabilities'] as List).map((e) => e.toString()).toList(),
      bbox: (json['bbox'] as List).map((e) => (e as num).toDouble()).toList(),
      center:
          (json['center'] as List).map((e) => (e as num).toDouble()).toList(),
      version: json['version']?.toString() ?? '',
      counts: (json['counts'] as Map?)?.cast<String, dynamic>() ?? const {},
    );
  }
}
