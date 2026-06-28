import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/district_data.dart';
import '../../../data/models/evacuation_route.dart';
import '../../../data/models/route_strategy.dart';
import '../../../providers/emergency_provider.dart';
import '../../../providers/getra_provider.dart';

/// Evacuation map: GETRA-classified roads, the tsunami inundation zone,
/// shelters, and one-tap safe routing to the nearest shelter.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  LatLng? _origin; // evacuation start point (GPS or tapped)
  LatLng? _gpsLocation; // device GPS position (Google-style blue dot)
  bool _originIsGps = false;
  bool _loadingLocation = false;
  String? _centeredDistrict; // id of the district the map is centered on
  double _rotation = 0; // current map bearing in degrees
  StreamSubscription<MapEvent>? _mapEventSub;
  DateTime? _handledEmergency; // declaration we've already auto-evacuated for

  @override
  void dispose() {
    _mapEventSub?.cancel();
    super.dispose();
  }

  void _resetNorth() {
    _mapController.rotate(0);
    setState(() => _rotation = 0);
  }

  // memoised heavy layers, rebuilt only when the district data changes
  DistrictData? _layersFor;
  final List<Polyline> _roadLines = [];
  final List<Polygon> _floodPolys = [];

  void _ensureLayers(DistrictData d) {
    if (identical(d, _layersFor)) return;
    _layersFor = d;

    _floodPolys
      ..clear()
      ..addAll(d.inundation.map((a) => Polygon(
            points: a.outer,
            holePointsList: a.holes,
            color: AppTheme.alertRed.withOpacity(0.16),
            borderColor: AppTheme.alertRed.withOpacity(0.65),
            borderStrokeWidth: 1.5,
          )));

    // draw safe roads first, unsafe on top so hazards read clearly
    final safe = <Polyline>[];
    final unsafe = <Polyline>[];
    for (final r in d.roads) {
      (r.isUnsafe ? unsafe : safe).add(Polyline(
        points: r.points,
        strokeWidth: r.isUnsafe ? 3.0 : 1.5,
        color: (r.isUnsafe ? AppTheme.alertRed : AppTheme.alertGreen)
            .withOpacity(r.isUnsafe ? 0.9 : 0.55),
      ));
    }
    _roadLines
      ..clear()
      ..addAll(safe)
      ..addAll(unsafe);
  }

  void _maybeCenter(GetraProvider p) {
    final d = p.selected;
    if (d == null || d.id == _centeredDistrict) return;
    _centeredDistrict = d.id;
    final b = d.bbox; // [minLon, minLat, maxLon, maxLat]
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.fitCamera(CameraFit.bounds(
        bounds: LatLngBounds(LatLng(b[1], b[0]), LatLng(b[3], b[2])),
        padding: const EdgeInsets.all(36),
      ));
    });
  }

  void _selectDistrict(GetraProvider p, String id) {
    if (id == p.selected?.id) return;
    setState(() {
      _origin = null;
      _gpsLocation = null;
      _originIsGps = false;
    });
    p.selectDistrict(id);
  }

  Future<void> _useMyLocation(GetraProvider p) async {
    setState(() => _loadingLocation = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final ll = LatLng(pos.latitude, pos.longitude);
      setState(() => _gpsLocation = ll);
      _setOrigin(ll, p, fromGps: true);
      _mapController.move(ll, 15);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Could not get your location. Tap the map to set a start point.'),
        ));
      }
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  void _setOrigin(LatLng ll, GetraProvider p, {bool fromGps = false}) {
    setState(() {
      _origin = ll;
      _originIsGps = fromGps;
    });
    p.computeRoute(ll.latitude, ll.longitude);
  }

  /// Emergency flow: locate the user and route to the nearest DMC shelter via
  /// the safest path, automatically (triggered by a tsunami-confirmed alert).
  Future<void> _runEmergencyEvacuation(GetraProvider p) async {
    setState(() => _loadingLocation = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('no location permission');
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final ll = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _gpsLocation = ll;
        _origin = ll;
        _originIsGps = true;
      });
      p.computeRoute(ll.latitude, ll.longitude, emergencyDmcOnly: true);
      _mapController.move(ll, 15);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Enable location to get your evacuation route.'),
        ));
      }
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  void _clear(GetraProvider p) {
    setState(() => _origin = null);
    p.clearRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetraProvider>(
      builder: (context, p, _) {
        if (p.status == GetraStatus.loading && p.data == null) {
          return _StatusScaffold(
            child: const _Loading(message: 'Loading evacuation map...'),
          );
        }
        if (p.data == null) {
          return _StatusScaffold(
            child: _ErrorView(
              message: p.error ?? 'Map unavailable.',
              onRetry: () => p.init(),
            ),
          );
        }

        final data = p.data!;
        _ensureLayers(data);
        _maybeCenter(p);

        final emergency = context.watch<EmergencyProvider>();
        if (emergency.active && emergency.declaredAt != _handledEmergency) {
          _handledEmergency = emergency.declaredAt;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _runEmergencyEvacuation(p));
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: emergency.active ? AppTheme.alertRed : null,
            foregroundColor: emergency.active ? Colors.white : null,
            title: emergency.active
                ? const Text('TSUNAMI WARNING')
                : _DistrictTitle(
                    provider: p,
                    onSelect: (id) => _selectDistrict(p, id),
                  ),
            actions: emergency.active
                ? null
                : [
                    if (p.isOffline)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Tooltip(
                          message: 'Showing saved offline map',
                          child: Icon(Icons.cloud_off, size: 20),
                        ),
                      ),
                    _LayerMenu(provider: p),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh data',
                      onPressed: () => p.refresh(),
                    ),
                  ],
          ),
          body: Stack(
            children: [
              _buildMap(context, p, data),
              if (emergency.active)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _EmergencyBanner(
                    emergency: emergency,
                    location: _gpsLocation,
                    route: p.route,
                    onStandDown: () =>
                        context.read<EmergencyProvider>().standDown(),
                  ),
                ),
              if (p.isOffline && !emergency.active) const _OfflineBanner(),
              if (!emergency.active)
                Positioned(top: 12, left: 12, child: _Legend(provider: p)),
              // controls (compass + my location) sit above the route panel,
              // right-aligned, so they never cover the route details
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_rotation.abs() > 0.5) ...[
                            FloatingActionButton.small(
                              heroTag: 'getra_compass',
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                              foregroundColor: AppTheme.alertRed,
                              tooltip: 'Face north',
                              onPressed: _resetNorth,
                              child: Transform.rotate(
                                angle: -_rotation * math.pi / 180,
                                child: const Icon(Icons.navigation),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                          FloatingActionButton.small(
                            heroTag: 'getra_location',
                            tooltip: 'My location',
                            onPressed: _loadingLocation
                                ? null
                                : () => _useMyLocation(p),
                            child: _loadingLocation
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.my_location),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _BottomPanel(
                      provider: p,
                      origin: _origin,
                      onClear: () => _clear(p),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap(BuildContext context, GetraProvider p, DistrictData data) {
    final route = p.route;
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: p.selected?.centerLatLng ?? const LatLng(6.0535, 80.2210),
        initialZoom: 13.5,
        onTap: (_, latlng) => _setOrigin(latlng, p),
        onMapReady: () {
          _mapEventSub ??= _mapController.mapEventStream.listen((_) {
            final r = _mapController.camera.rotation;
            if ((r - _rotation).abs() > 0.1 && mounted) {
              setState(() => _rotation = r);
            }
          });
        },
      ),
      children: [
        TileLayer(
          urlTemplate: ApiConstants.osmTileUrl,
          userAgentPackageName: 'com.tsunamisense.app',
        ),
        if (p.showInundation) PolygonLayer(polygons: _floodPolys),
        if (p.showRoads) PolylineLayer(polylines: _roadLines),

        // computed evacuation route (drawn above roads)
        if (route != null && route.points.length > 1)
          PolylineLayer(polylines: [
            Polyline(
              points: route.points,
              strokeWidth: 7,
              color: Colors.white,
            ),
            Polyline(
              points: route.points,
              strokeWidth: 4.5,
              color: route.strategy.color,
            ),
          ]),

        if (p.showShelters) _shelterMarkers(data, p),

        // user location (blue dot), tapped start pin, destination flag
        MarkerLayer(markers: [
          if (_gpsLocation != null)
            Marker(
              point: _gpsLocation!,
              width: 24,
              height: 24,
              child: const _BlueDot(),
            ),
          if (_origin != null && !_originIsGps)
            Marker(
              point: _origin!,
              width: 40,
              height: 40,
              child: _PinIcon(
                icon: Icons.place,
                color: AppTheme.primaryBlue,
                inDanger: p.isInDanger(_origin!),
              ),
            ),
          if (route?.shelterLocation != null)
            Marker(
              point: route!.shelterLocation!,
              width: 44,
              height: 44,
              child: const _PinIcon(
                icon: Icons.flag_circle,
                color: AppTheme.alertGreen,
              ),
            ),
        ]),
      ],
    );
  }

  MarkerLayer _shelterMarkers(DistrictData data, GetraProvider p) {
    final visible = data.shelters.where((z) {
      final s = (z.source ?? '').toLowerCase();
      if (s == 'literature') return p.showLiteratureShelters;
      if (s == 'osm') return p.showOsmShelters;
      return true; // dmc / unknown always shown
    }).toList();
    return MarkerLayer(
      markers: visible.map((z) {
        final s = (z.source ?? '').toLowerCase();
        final (Color color, String label) = switch (s) {
          'literature' => (AppTheme.oceanLight, 'Research-supported'),
          'osm' => (AppTheme.alertOrange, 'OpenStreetMap — unverified'),
          _ => (AppTheme.alertGreen, 'DMC-verified'),
        };
        return Marker(
          point: LatLng(z.latitude, z.longitude),
          width: 30,
          height: 30,
          child: GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${z.name} • ${z.typeDisplayName} ($label)'),
              duration: const Duration(seconds: 2),
            )),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 3),
                ],
              ),
              child: const Icon(Icons.home, color: Colors.white, size: 16),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _StatusScaffold extends StatelessWidget {
  final Widget child;
  const _StatusScaffold({required this.child});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Evacuation Map')),
        body: Center(child: child),
      );
}

class _Loading extends StatelessWidget {
  final String message;
  const _Loading({required this.message});
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ],
      );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: AppTheme.textSecondary),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      );
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();
  @override
  Widget build(BuildContext context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          color: AppTheme.alertYellow.withOpacity(0.95),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off, size: 14, color: Colors.black87),
                SizedBox(width: 6),
                Text('Offline mode — showing saved map',
                    style: TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
        ),
      );
}

/// Red emergency banner with a live wave-arrival countdown and route guidance.
class _EmergencyBanner extends StatefulWidget {
  final EmergencyProvider emergency;
  final LatLng? location;
  final EvacuationRoute? route;
  final VoidCallback onStandDown;
  const _EmergencyBanner({
    required this.emergency,
    required this.location,
    required this.route,
    required this.onStandDown,
  });

  @override
  State<_EmergencyBanner> createState() => _EmergencyBannerState();
}

class _EmergencyBannerState extends State<_EmergencyBanner> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int s) {
    final r = s.clamp(0, 99 * 60 + 59);
    return '${(r ~/ 60).toString().padLeft(2, '0')}:'
        '${(r % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final loc = widget.location;
    final route = widget.route;
    final remaining =
        loc != null ? widget.emergency.secondsRemaining(loc) : null;
    final walkSec =
        (route?.found ?? false) ? widget.route!.walkMinutes * 60 : null;
    final tooLate = remaining != null && walkSec != null && remaining < walkSec;

    return Material(
      color: AppTheme.alertRed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: loc == null
                      ? const Text('Locating you…',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold))
                      : Text('Wave arrives in  ${_fmt(remaining ?? 0)}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: widget.onStandDown,
                  child: const Text('End drill',
                      style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
            if (loc != null) ...[
              const SizedBox(height: 2),
              Text(
                route != null && route.found
                    ? (tooLate
                        ? 'You may not reach ${route.shelterName ?? 'the shelter'} in time. '
                            'Move to the nearest high ground immediately.'
                        : 'Follow the route to ${route.shelterName ?? 'the nearest shelter'} — '
                            '${route.distanceM} m, about ${route.walkMinutes} min on foot.')
                    : 'Move inland and uphill, away from the coast.',
                style: TextStyle(
                    color: tooLate ? Colors.yellowAccent : Colors.white,
                    fontWeight: tooLate ? FontWeight.bold : FontWeight.normal),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// App-bar district picker (Galle / Matara / Tangalle).
class _DistrictTitle extends StatelessWidget {
  final GetraProvider provider;
  final ValueChanged<String> onSelect;
  const _DistrictTitle({required this.provider, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final districts = provider.districts;
    final name = provider.selected?.name ?? 'Evacuation';
    if (districts.length <= 1) return Text('$name Map');

    return PopupMenuButton<String>(
      tooltip: 'Switch district',
      onSelected: onSelect,
      itemBuilder: (_) => districts.map((d) {
        final selected = d.id == provider.selected?.id;
        return PopupMenuItem<String>(
          value: d.id,
          child: Row(
            children: [
              Icon(d.hasRouting ? Icons.alt_route : Icons.map_outlined,
                  size: 18, color: selected ? AppTheme.primaryBlue : null),
              const SizedBox(width: 10),
              Text(d.name),
              if (!d.hasRouting) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppTheme.alertOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Map only',
                      style: TextStyle(
                          fontSize: 10, color: AppTheme.alertOrange)),
                ),
              ],
              if (selected) ...[
                const Spacer(),
                const Icon(Icons.check, size: 18, color: AppTheme.primaryBlue),
              ],
            ],
          ),
        );
      }).toList(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text('$name Map', overflow: TextOverflow.ellipsis)),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

class _LayerMenu extends StatelessWidget {
  final GetraProvider provider;
  const _LayerMenu({required this.provider});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.layers),
      tooltip: 'Map layers',
      onSelected: (v) {
        switch (v) {
          case 'roads':
            provider.toggleRoads();
          case 'flood':
            provider.toggleInundation();
          case 'shelters':
            provider.toggleShelters();
        }
      },
      itemBuilder: (_) => [
        _check('roads', 'Road safety', provider.showRoads),
        _check('flood', 'Inundation zone', provider.showInundation),
        _check('shelters', 'Shelters', provider.showShelters),
      ],
    );
  }

  PopupMenuItem<String> _check(String value, String label, bool on) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(on ? Icons.check_box : Icons.check_box_outline_blank, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final GetraProvider provider;
  const _Legend({required this.provider});
  @override
  Widget build(BuildContext context) {
    final sources = provider.data?.availableSources ?? const <String>{};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _line(AppTheme.alertGreen, 'Safe road'),
            _line(AppTheme.alertRed, 'Flood-prone road'),
            _dot(AppTheme.alertRed.withOpacity(0.35), 'Inundation zone'),
            if (sources.contains('dmc'))
              _dot(AppTheme.alertGreen, 'DMC shelter'),
            if (sources.contains('literature') && provider.showLiteratureShelters)
              _dot(AppTheme.oceanLight, 'Research shelter'),
            if (sources.contains('osm') && provider.showOsmShelters)
              _dot(AppTheme.alertOrange, 'OSM shelter'),
            _dot(const Color(0xFF1A73E8), 'You'),
          ],
        ),
      ),
    );
  }

  Widget _dot(Color c, String label) => _row(
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        ),
        label,
      );

  Widget _line(Color c, String label) => _row(
        Container(
          width: 14,
          height: 4,
          decoration:
              BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
        ),
        label,
      );

  Widget _row(Widget swatch, String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(width: 14, child: Center(child: swatch)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11)),
        ]),
      );
}

class _PinIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool inDanger;
  const _PinIcon({required this.icon, required this.color, this.inDanger = false});
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 40,
      color: inDanger ? AppTheme.alertRed : color,
      shadows: const [Shadow(color: Colors.white, blurRadius: 4)],
    );
  }
}

/// Google-Maps-style blue location dot for the device's GPS position.
class _BlueDot extends StatelessWidget {
  const _BlueDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A73E8),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
      ),
    );
  }
}

/// Bottom control panel: danger status, strategy selector, route result.
class _BottomPanel extends StatelessWidget {
  final GetraProvider provider;
  final LatLng? origin;
  final VoidCallback onClear;
  const _BottomPanel({
    required this.provider,
    required this.origin,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final route = provider.route;
    final showOsmNote = provider.showOsmShelters &&
        (provider.data?.availableSources.contains('osm') ?? false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (origin == null)
          _hintCard(context)
        else ...[
          if (provider.routableNow) ...[
            _StrategySelector(provider: provider),
            const SizedBox(height: 8),
          ],
          if (route != null) _RouteCard(route: route, onClear: onClear),
        ],
        if (showOsmNote) ...[
          const SizedBox(height: 6),
          const Text(
            'OpenStreetMap shelters are auto-identified and unverified.',
            style: TextStyle(fontSize: 10, color: AppTheme.alertOrange),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 6),
        const Center(
          child: Text('Powered by GETRA',
              style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
        ),
      ],
    );
  }

  Widget _hintCard(BuildContext context) {
    final hint = provider.routingHint;
    final isGuide = hint != null;
    return Card(
      color: isGuide ? AppTheme.alertOrange.withOpacity(0.12) : null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(isGuide ? Icons.info_outline : Icons.touch_app,
                color: isGuide ? AppTheme.alertOrange : AppTheme.primaryBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hint ??
                    'Tap “My location”, or tap anywhere on the map, to find the safest route to a shelter.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrategySelector extends StatelessWidget {
  final GetraProvider provider;
  const _StrategySelector({required this.provider});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Centered so the control hugs its buttons (no wide background frame), with
    // solid per-segment fills so it stays legible over the map in dark mode.
    return Align(
      alignment: Alignment.center,
      child: SegmentedButton<RouteStrategy>(
        segments: RouteStrategy.values
            .map((s) => ButtonSegment<RouteStrategy>(
                  value: s,
                  label: Text(s.label, style: const TextStyle(fontSize: 12)),
                  icon: Icon(s.icon, size: 16),
                ))
            .toList(),
        selected: {provider.strategy},
        showSelectedIcon: false,
        onSelectionChanged: (sel) => provider.setStrategy(sel.first),
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppTheme.primaryBlue
                : scheme.surface,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.white
                : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final EvacuationRoute route;
  final VoidCallback onClear;
  const _RouteCard({required this.route, required this.onClear});

  @override
  Widget build(BuildContext context) {
    if (!route.found) {
      return Card(
        color: AppTheme.alertYellow.withOpacity(0.18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.warning_amber, color: AppTheme.alertOrange),
              const SizedBox(width: 12),
              Expanded(
                child: Text(route.message ?? 'No route available.',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              IconButton(icon: const Icon(Icons.close), onPressed: onClear),
            ],
          ),
        ),
      );
    }

    final safetyPct = (route.safety * 100).round();
    final safe = route.unsafeSegments == 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(route.strategy.icon, color: route.strategy.color, size: 18),
                const SizedBox(width: 6),
                Text('${route.strategy.label} route',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.flag, size: 16, color: AppTheme.alertGreen),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'To ${route.shelterName ?? 'nearest shelter'}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _metric(Icons.straighten, '${route.distanceM} m'),
                _metric(Icons.directions_walk, '~${route.walkMinutes} min'),
                _metric(
                  safe ? Icons.verified_user : Icons.report_problem,
                  safe ? '$safetyPct% safe' : '$safetyPct% • ${route.unsafeSegments} risky',
                  color: safe ? AppTheme.alertGreen : AppTheme.alertOrange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(IconData icon, String label, {Color color = AppTheme.textSecondary}) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(label,
                style: TextStyle(fontSize: 12, color: color),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
