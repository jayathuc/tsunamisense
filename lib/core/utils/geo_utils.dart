import 'dart:math';
import 'package:latlong2/latlong.dart';

/// Great-circle distance in metres between two WGS84 points.
double haversineMeters(LatLng a, LatLng b) {
  const r = 6371000.0;
  final p1 = a.latitude * pi / 180;
  final p2 = b.latitude * pi / 180;
  final dp = (b.latitude - a.latitude) * pi / 180;
  final dl = (b.longitude - a.longitude) * pi / 180;
  final h = sin(dp / 2) * sin(dp / 2) +
      cos(p1) * cos(p2) * sin(dl / 2) * sin(dl / 2);
  return 2 * r * asin(min(1.0, sqrt(h)));
}

/// Ray-casting point-in-polygon test against a single ring (lon/lat).
bool pointInRing(LatLng p, List<LatLng> ring) {
  if (ring.length < 3) return false;
  var inside = false;
  final n = ring.length;
  for (var i = 0, j = n - 1; i < n; j = i++) {
    final xi = ring[i].longitude, yi = ring[i].latitude;
    final xj = ring[j].longitude, yj = ring[j].latitude;
    final denom = (yj - yi) == 0 ? 1e-12 : (yj - yi);
    final intersect = ((yi > p.latitude) != (yj > p.latitude)) &&
        (p.longitude < (xj - xi) * (p.latitude - yi) / denom + xi);
    if (intersect) inside = !inside;
  }
  return inside;
}
