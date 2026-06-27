import 'package:flutter/foundation.dart';
import '../data/models/earthquake.dart';
import '../data/services/earthquake_service.dart';
import '../core/constants/app_constants.dart';

/// Provider for earthquake data and alert status
class EarthquakeProvider extends ChangeNotifier {
  final EarthquakeService _service;

  List<Earthquake> _earthquakes = [];
  AlertLevel _currentAlertLevel = AlertLevel.none;
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

  /// Evaluate current alert level based on recent earthquakes
  void _evaluateAlertLevel() {
    AlertLevel newLevel = AlertLevel.none;
    Earthquake? significant;

    for (final eq in _earthquakes) {
      // Only consider earthquakes from the last 24 hours
      final age = DateTime.now().difference(eq.time);
      if (age.inHours > 24) continue;

      // Check if it affects Sri Lanka region
      final distance = eq.distanceFromSriLanka;
      if (distance > 3000) continue;

      // Determine alert level
      if (eq.magnitude >= AppConstants.emergencyMagnitude) {
        newLevel = AlertLevel.emergency;
        significant = eq;
        break; // Emergency is highest level
      } else if (eq.magnitude >= AppConstants.advisoryMagnitude) {
        if (newLevel != AlertLevel.emergency) {
          newLevel = AlertLevel.advisory;
          significant ??= eq;
        }
      }
    }

    _currentAlertLevel = newLevel;
    _latestSignificantEarthquake = significant;
  }

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
