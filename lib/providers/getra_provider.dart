import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/district.dart';
import '../data/models/district_data.dart';
import '../data/models/evacuation_route.dart';
import '../data/models/route_strategy.dart';
import '../data/services/getra_service.dart';

enum GetraStatus { idle, loading, ready, error }

/// State for the GETRA evacuation map: districts, the active district's layers,
/// the selected routing strategy, and the current computed route.
class GetraProvider extends ChangeNotifier {
  final GetraService _service;

  GetraProvider({GetraService? service}) : _service = service ?? GetraService();

  GetraStatus _status = GetraStatus.idle;
  String? _error;
  bool _offline = false;

  List<District> _districts = [];
  District? _selected;
  DistrictData? _data;

  RouteStrategy _strategy = RouteStrategy.safest;
  EvacuationRoute? _route;
  double? _lastLat;
  double? _lastLng;

  bool _showRoads = true;
  bool _showInundation = true;
  bool _showShelters = true;
  bool _showLiteratureShelters = false; // research-supported shelters, off by default

  // -- getters -------------------------------------------------------------
  GetraStatus get status => _status;
  String? get error => _error;
  bool get isOffline => _offline;
  List<District> get districts => _districts;
  District? get selected => _selected;
  DistrictData? get data => _data;
  RouteStrategy get strategy => _strategy;
  EvacuationRoute? get route => _route;
  bool get showRoads => _showRoads;
  bool get showInundation => _showInundation;
  bool get showShelters => _showShelters;
  bool get showLiteratureShelters => _showLiteratureShelters;
  bool get hasRouting => _data?.hasRouting ?? false;

  // -- lifecycle -----------------------------------------------------------

  /// Load the registry and the default district (Galle), cache-first.
  Future<void> init() async {
    if (_status == GetraStatus.loading) return;
    await _loadPrefs();

    // 1. Render instantly from cache if a complete copy exists (works offline).
    final cachedRegs = _service.cachedDistricts();
    if (cachedRegs != null && cachedRegs.isNotEmpty) {
      _districts = cachedRegs;
      final initial = _pickDefault(cachedRegs);
      final cachedData = _service.cachedDistrictData(initial);
      if (cachedData != null) {
        _selected = initial;
        _data = cachedData;
        _offline = true;
        _status = GetraStatus.ready;
        notifyListeners();
      }
    }

    // 2. Best-effort network refresh; never break an already-working cached map.
    if (_data == null) {
      _status = GetraStatus.loading;
      notifyListeners();
    }
    try {
      final reg = await _service.fetchDistricts();
      _districts = reg.districts;
      if (_districts.isEmpty) {
        if (_data == null) _fail('No districts are available from the server.');
        return;
      }
      final initial = _pickDefault(_districts);
      final res = await _service.loadDistrict(initial);
      _selected = initial;
      _data = res.data;
      _offline = res.fromCache;
      _status = GetraStatus.ready;
      _error = null;
      notifyListeners();
    } catch (e) {
      debugPrint('[GETRA] init refresh failed: $e');
      if (_data == null) _fail(_friendly(e));
      // else: keep showing the cached map silently.
    }
  }

  District _pickDefault(List<District> ds) =>
      ds.firstWhere((d) => d.id == 'galle', orElse: () => ds.first);

  Future<void> selectDistrict(String id) async {
    if (_selected?.id == id) return;
    final d = _districts.firstWhere((x) => x.id == id, orElse: () => _selected!);
    _route = null;
    _lastLat = null;
    _lastLng = null;
    await _loadDistrict(d);
  }

  Future<void> refresh() async {
    final d = _selected;
    if (d == null) return;
    _status = GetraStatus.loading;
    notifyListeners();
    try {
      final res = await _service.loadDistrict(d, forceRefresh: true);
      _data = res.data;
      _offline = res.fromCache;
      _status = GetraStatus.ready;
      _error = null;
      if (_lastLat != null && _lastLng != null) {
        _route = _data!.traceOffline(_lastLat!, _lastLng!, _strategy,
            includeLiterature: _showLiteratureShelters);
      }
    } catch (e) {
      _error = _friendly(e);
      _status = _data != null ? GetraStatus.ready : GetraStatus.error;
    }
    notifyListeners();
  }

  Future<void> _loadDistrict(District d) async {
    _status = GetraStatus.loading;
    _selected = d;
    notifyListeners();
    try {
      final res = await _service.loadDistrict(d);
      _data = res.data;
      _offline = res.fromCache;
      _status = GetraStatus.ready;
      _error = null;
    } catch (e) {
      _data = null;
      _fail(_friendly(e));
      return;
    }
    notifyListeners();
  }

  // -- routing -------------------------------------------------------------

  void setStrategy(RouteStrategy s) {
    if (_strategy == s) return;
    _strategy = s;
    if (_route != null && _lastLat != null && _lastLng != null) {
      _route = _data?.traceOffline(_lastLat!, _lastLng!, _strategy,
          includeLiterature: _showLiteratureShelters);
    }
    notifyListeners();
  }

  /// Compute the evacuation route from an origin using the active strategy.
  void computeRoute(double lat, double lng) {
    _lastLat = lat;
    _lastLng = lng;
    final d = _data;
    if (d == null) return;
    _route = d.hasRouting
        ? d.traceOffline(lat, lng, _strategy,
            includeLiterature: _showLiteratureShelters)
        : EvacuationRoute.failsafe(
            _strategy,
            'Routing for ${d.district.name} is coming soon. For now, move '
            'inland and uphill, away from the coast.',
          );
    notifyListeners();
  }

  void clearRoute() {
    _route = null;
    _lastLat = null;
    _lastLng = null;
    notifyListeners();
  }

  bool isInDanger(LatLng p) => _data?.isInInundation(p) ?? false;

  // -- layer toggles -------------------------------------------------------
  void toggleRoads() {
    _showRoads = !_showRoads;
    notifyListeners();
  }

  void toggleInundation() {
    _showInundation = !_showInundation;
    notifyListeners();
  }

  void toggleShelters() {
    _showShelters = !_showShelters;
    notifyListeners();
  }

  Future<void> _loadPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _showLiteratureShelters =
          prefs.getBool('show_literature_shelters') ?? false;
    } catch (_) {}
  }

  /// Persisted toggle for research-supported (literature) shelters. Also
  /// re-routes the active route so it only uses the enabled shelter set.
  Future<void> setShowLiteratureShelters(bool value) async {
    _showLiteratureShelters = value;
    if (_route != null && _lastLat != null && _lastLng != null) {
      _route = _data?.traceOffline(_lastLat!, _lastLng!, _strategy,
          includeLiterature: _showLiteratureShelters);
    }
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('show_literature_shelters', value);
    } catch (_) {}
  }

  // -- helpers -------------------------------------------------------------
  void _fail(String message) {
    _status = GetraStatus.error;
    _error = message;
    notifyListeners();
  }

  String _friendly(Object e) {
    final s = e.toString();
    if (s.contains('offline') || s.contains('SocketException') ||
        s.contains('Failed host') || s.contains('timed out')) {
      return 'Could not reach the server and no offline data is saved yet. '
          'Connect to the internet once to download the map for offline use.';
    }
    return 'Something went wrong while loading the map. Please try again.';
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
