import 'package:latlong2/latlong.dart';

/// A single road segment classified as safe or unsafe (ground-truth, GETRA).
class ClassifiedRoad {
  final int? u; // from node id
  final int? v; // to node id
  final List<LatLng> points;
  final bool isUnsafe;

  const ClassifiedRoad({
    this.u,
    this.v,
    required this.points,
    required this.isUnsafe,
  });

  /// Build from a GeoJSON LineString feature produced by `export_app_data.py`.
  factory ClassifiedRoad.fromFeature(Map<String, dynamic> feature) {
    final props = feature['properties'] as Map<String, dynamic>;
    final coords = (feature['geometry']['coordinates'] as List)
        .map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
        .toList();
    return ClassifiedRoad(
      u: (props['u'] as num?)?.toInt(),
      v: (props['v'] as num?)?.toInt(),
      points: coords,
      isUnsafe: props['safety'] == 'unsafe',
    );
  }
}
