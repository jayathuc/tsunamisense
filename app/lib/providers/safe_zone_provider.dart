import 'package:flutter/foundation.dart';
import '../data/models/safe_zone.dart';
import '../data/services/safe_zone_service.dart';

/// Provider for safe zone data fetched from the TsunamiSense backend
class SafeZoneProvider extends ChangeNotifier {
  final SafeZoneService _service;

  List<SafeZone> _safeZones = [];
  bool _isLoading = false;
  String? _error;

  SafeZoneProvider({SafeZoneService? service})
      : _service = service ?? SafeZoneService();

  List<SafeZone> get safeZones => _safeZones;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch all safe zones from the backend
  Future<void> loadSafeZones() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _safeZones = await _service.fetchAllSafeZones();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch safe zones near a given coordinate (used after location is obtained)
  Future<void> loadNearbySafeZones(double lat, double lng) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _safeZones = await _service.fetchNearbySafeZones(lat, lng);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
