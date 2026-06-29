import 'package:flutter/foundation.dart';
import '../data/models/earthquake.dart';
import '../data/services/earthquake_service.dart';
import '../data/services/notification_service.dart';
import '../core/constants/app_constants.dart';

/// Provider for earthquake data and alert status
class EarthquakeProvider extends ChangeNotifier {
  final EarthquakeService _service;

  List<Earthquake> _earthquakes = [];
  AlertLevel _currentAlertLevel = AlertLevel.none;
  AlertLevel? _manualOverride; // developer override
  Earthquake? _latestSignificantEarthquake;
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdated;

  EarthquakeProvider({EarthquakeService? service})
      : _service = service ?? EarthquakeService();

  // Getters
  List<Earthquake> get earthquakes => _earthquakes;
  AlertLevel get currentAlertLevel => _currentAlertLevel;
  Earthquake? get latestSignificantEarthquake => _latestSignificantEarthquake;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get errorMessage => _error;
  DateTime? get lastUpdated => _lastUpdated;

  /// Fetch latest earthquakes from USGS
  Future<void> fetchEarthquakes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final earthquakes = await _service.fetchRecentEarthquakes(
        minMagnitude: AppConstants.tsunamiMinMagnitude,
        limit: 50,
      );

      _earthquakes = earthquakes;
      _lastUpdated = DateTime.now();

      // Determine alert level
      _evaluateAlertLevel();

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Subduction zones whose great earthquakes can send a tele-tsunami to Sri
  // Lanka. Sri Lanka sits on a stable plate with no near-field source, so only
  // far-field events from these specific zones are a real threat.
  // [minLat, maxLat, minLon, maxLon]
  static const List<List<double>> _tsunamiSources = [
    [-8.0, 16.0, 90.0, 104.0], // Sumatra–Andaman (Sunda Trench) — the 2004 source
    [22.0, 27.0, 56.0, 68.0], // Makran Subduction Zone (off Pakistan / Iran)
  ];

  bool _inTsunamiSource(Earthquake eq) => _tsunamiSources.any((z) =>
      eq.latitude >= z[0] &&
      eq.latitude <= z[1] &&
      eq.longitude >= z[2] &&
      eq.longitude <= z[3]);

  /// Evaluate the advisory/watch level from recent earthquakes.
  ///
  /// A tsunami threat to Sri Lanka requires a large (M>=7.5), shallow (<=70 km),
  /// undersea earthquake inside a known source zone. Smaller, deeper, inland or
  /// out-of-zone quakes are ignored so we never raise a false alarm. An
  /// emergency is never raised from an earthquake alone — that needs a confirmed
  /// tsunami warning.
  void _evaluateAlertLevel() {
    if (_manualOverride != null) {
      _applyLevel(_manualOverride!, _latestSignificantEarthquake);
      return;
    }

    AlertLevel newLevel = AlertLevel.none;
    Earthquake? significant;

    for (final eq in _earthquakes) {
      if (DateTime.now().difference(eq.time).inHours > 24) continue;
      if (eq.depth > 70) continue; // tsunamis come from shallow ruptures
      if (eq.magnitude < 7.5) continue; // below the tele-tsunami threshold
      if (!_inTsunamiSource(eq)) continue; // only SL-relevant subduction zones

      final level =
          eq.magnitude >= 8.0 ? AlertLevel.warning : AlertLevel.advisory;
      if (_rank(level) > _rank(newLevel)) {
        newLevel = level;
        significant = eq;
      }
    }

    _applyLevel(newLevel, significant);
  }

  void _applyLevel(AlertLevel level, Earthquake? significant) {
    final escalated = _rank(level) > _rank(_currentAlertLevel);
    _currentAlertLevel = level;
    _latestSignificantEarthquake = significant;
    if (escalated) {
      if (level == AlertLevel.advisory) {
        NotificationService.show(
          'Tsunami advisory',
          'A possible tsunami-generating earthquake was detected near Sri Lanka. '
              'Review your safe route.',
        );
      } else if (level == AlertLevel.warning) {
        NotificationService.show(
          'Tsunami watch',
          'A strong offshore earthquake occurred. Be ready to evacuate if a '
              'warning is issued.',
          urgent: true,
        );
      }
    }
  }

  int _rank(AlertLevel l) => AlertLevel.values.indexOf(l);

  /// Get earthquakes sorted by time (most recent first)
  List<Earthquake> get recentEarthquakes {
    final sorted = List<Earthquake>.from(_earthquakes);
    sorted.sort((a, b) => b.time.compareTo(a.time));
    return sorted;
  }

  /// Get only tsunamigenic earthquakes
  List<Earthquake> get tsunamigenicEarthquakes {
    return _earthquakes.where((eq) => eq.isTsunamigenic).toList();
  }

  /// Manually set alert level (for testing/demo)
  void setAlertLevel(AlertLevel level) {
    _currentAlertLevel = level;
    notifyListeners();
  }

  /// Developer override of the advisory level (null clears it).
  void setManualOverride(AlertLevel? level) {
    _manualOverride = level;
    _evaluateAlertLevel();
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
