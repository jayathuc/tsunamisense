import 'package:flutter/foundation.dart';
import '../data/models/earthquake.dart';
import '../data/services/earthquake_service.dart';
import '../data/services/notification_service.dart';
import '../core/constants/app_constants.dart';
import '../data/services/threat_evaluator.dart';

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

  /// Evaluate the advisory/watch level from recent earthquakes.
  ///
  /// The rules themselves live in [ThreatEvaluator] so the background monitor
  /// applies exactly the same criteria as the UI.
  void _evaluateAlertLevel() {
    if (_manualOverride != null) {
      _applyLevel(_manualOverride!, _latestSignificantEarthquake);
      return;
    }
    final a = ThreatEvaluator.evaluate(_earthquakes);
    _applyLevel(a.level, a.trigger);
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

  int _rank(AlertLevel l) => ThreatEvaluator.rank(l);

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
