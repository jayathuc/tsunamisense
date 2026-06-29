import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../core/utils/geo_utils.dart';
import '../data/services/notification_service.dart';

/// Drives the app's emergency evacuation mode.
///
/// When a "tsunami confirmed" alert is declared, the app switches to the map,
/// locates the user and routes them to the nearest (DMC) shelter via the safest
/// path, with an estimated wave-arrival countdown.
///
/// NOTE: the arrival-time model here is a deliberate proof of concept. It
/// assumes a near-field, earthquake-generated wave from a fixed offshore source
/// and a single effective wave speed. A real deployment would derive the source
/// location, magnitude and arrival time from live seismic and inundation data.
class EmergencyProvider extends ChangeNotifier {
  // PoC near-field tsunami source: Indian Ocean, south of Sri Lanka's coast.
  static const LatLng pocSource = LatLng(5.6, 80.45);
  // Simplified effective wave speed (deep-ocean speed is far higher; this is a
  // conservative shoaling-adjusted average for the demonstration).
  static const double waveSpeedKmh = 200;

  bool _active = false;
  DateTime? _declaredAt;
  LatLng _source = pocSource;

  bool get active => _active;
  DateTime? get declaredAt => _declaredAt;
  LatLng get source => _source;

  /// Declare a tsunami-confirmed emergency (e.g. from a test alert).
  void declareEmergency({LatLng? source}) {
    _active = true;
    _declaredAt = DateTime.now();
    _source = source ?? pocSource;
    NotificationService.show(
      'TSUNAMI WARNING',
      'Evacuate now. Open the app for your safest route to a shelter.',
      urgent: true,
    );
    notifyListeners();
  }

  /// End the drill / stand down.
  void standDown() {
    _active = false;
    _declaredAt = null;
    notifyListeners();
  }

  /// Estimated minutes for the wave to reach [at] (PoC model).
  int estimatedArrivalMinutes(LatLng at) {
    final km = haversineMeters(_source, at) / 1000.0;
    return (km / waveSpeedKmh * 60).clamp(1, 180).round();
  }

  /// Seconds left until estimated arrival at [at], or null when inactive.
  int? secondsRemaining(LatLng at) {
    if (!_active || _declaredAt == null) return null;
    final total = estimatedArrivalMinutes(at) * 60;
    return total - DateTime.now().difference(_declaredAt!).inSeconds;
  }
}
