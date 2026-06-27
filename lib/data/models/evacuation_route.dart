import 'package:latlong2/latlong.dart';
import 'route_strategy.dart';

/// Result of an evacuation routing request (online API or offline basin trace).
class EvacuationRoute {
  final bool found;
  final String? message; // failsafe guidance when [found] is false
  final RouteStrategy strategy;
  final List<LatLng> points;
  final String? shelterName;
  final LatLng? shelterLocation;
  final int distanceM;
  final int unsafeSegments;
  final double safety; // 0..1

  const EvacuationRoute({
    required this.found,
    required this.strategy,
    this.message,
    this.points = const [],
    this.shelterName,
    this.shelterLocation,
    this.distanceM = 0,
    this.unsafeSegments = 0,
    this.safety = 0,
  });

  /// Generic, always-available guidance when no route can be computed.
  factory EvacuationRoute.failsafe(RouteStrategy strategy, [String? message]) {
    return EvacuationRoute(
      found: false,
      strategy: strategy,
      message: message ??
          'No mapped route from here. Move inland and uphill, away from the coast.',
    );
  }

  /// Parse the GETRA backend `/route` JSON response.
  factory EvacuationRoute.fromApi(
    Map<String, dynamic> json,
    RouteStrategy strategy,
  ) {
    if (json['found'] != true) {
      return EvacuationRoute.failsafe(strategy, json['message'] as String?);
    }
    final coords = (json['geometry']['coordinates'] as List)
        .map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
        .toList();
    final shelter = json['shelter'] as Map<String, dynamic>?;
    LatLng? shelterLoc;
    final sc = shelter?['coords'];
    if (sc is List && sc.length >= 2) {
      shelterLoc = LatLng((sc[1] as num).toDouble(), (sc[0] as num).toDouble());
    }
    return EvacuationRoute(
      found: true,
      strategy: strategy,
      points: coords,
      shelterName: shelter?['name'] as String?,
      shelterLocation: shelterLoc,
      distanceM: (json['dist_m'] as num?)?.toInt() ?? 0,
      unsafeSegments: (json['n_unsafe'] as num?)?.toInt() ?? 0,
      safety: (json['safety'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Walking-time estimate at ~1.3 m/s (brisk evacuation pace).
  int get walkMinutes => (distanceM / 1.3 / 60).ceil();
}
