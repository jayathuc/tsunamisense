import 'package:latlong2/latlong.dart';

import '../../core/utils/geo_utils.dart';
import 'classified_road.dart';
import 'district.dart';
import 'evacuation_route.dart';
import 'route_strategy.dart';
import 'safe_zone.dart';

/// Squared planar distance between two points (for nearest-endpoint checks).
double _sqDist(LatLng a, LatLng b) {
  final dLat = a.latitude - b.latitude;
  final dLng = a.longitude - b.longitude;
  return dLat * dLat + dLng * dLng;
}

/// An inundation polygon (outer ring plus any holes).
class InundationArea {
  final List<LatLng> outer;
  final List<List<LatLng>> holes;
  const InundationArea({required this.outer, this.holes = const []});
}

/// One node's precomputed evacuation entry (from evac_basin.json).
class BasinEntry {
  final int? next;
  final String shelterId;
  final int distM;
  final int unsafe;
  final double safety;
  const BasinEntry({
    required this.next,
    required this.shelterId,
    required this.distM,
    required this.unsafe,
    required this.safety,
  });
}

/// All parsed, indexed data for one district: map layers plus the offline
/// routing tables. Built once from the cached/fetched JSON bundles.
class DistrictData {
  final District district;
  final List<ClassifiedRoad> roads;
  final List<InundationArea> inundation;
  final List<SafeZone> shelters;
  final Map<int, LatLng> nodes;

  final Map<String, SafeZone> _sheltersById;
  // set ('dmc' | 'all') -> strategyId -> node -> entry
  final Map<String, Map<String, Map<int, BasinEntry>>> _basin;
  final Map<String, List<LatLng>> _edgeGeom; // "u_v" -> ordered points

  DistrictData._({
    required this.district,
    required this.roads,
    required this.inundation,
    required this.shelters,
    required this.nodes,
    required Map<String, SafeZone> sheltersById,
    required Map<String, Map<String, Map<int, BasinEntry>>> basin,
    required Map<String, List<LatLng>> edgeGeom,
  })  : _sheltersById = sheltersById,
        _basin = basin,
        _edgeGeom = edgeGeom;

  bool get hasRouting => district.hasRouting && _basin.isNotEmpty;

  /// Shelter source categories present here ('dmc', 'literature', 'osm').
  Set<String> get availableSources => shelters
      .map((s) => (s.source ?? '').toLowerCase())
      .where((s) => s.isNotEmpty)
      .toSet();

  /// Canonical basin key for the enabled toggles (DMC is always on; the key is
  /// the sorted '+'-joined intersection of enabled and available sources).
  String _basinKey({required bool literature, required bool osm}) {
    final enabled = <String>{
      'dmc',
      if (literature) 'literature',
      if (osm) 'osm',
    };
    final sel = enabled.intersection(availableSources).toList()..sort();
    return sel.join('+');
  }

  /// Whether a route can be computed with the given toggle selection.
  bool canRoute({bool includeLiterature = false, bool includeOsm = false}) {
    final b = _basin[_basinKey(literature: includeLiterature, osm: includeOsm)];
    return b != null && b.isNotEmpty;
  }

  /// Hint shown when the current toggle selection has no usable shelters.
  String? _routeHint() {
    if (availableSources.contains('osm')) {
      return 'Turn on "OpenStreetMap shelters" in Settings to get routes in '
          '${district.name}.';
    }
    if (availableSources.contains('literature')) {
      return 'Turn on "Research-supported shelters" in Settings to get routes here.';
    }
    return null;
  }

  factory DistrictData.parse({
    required District district,
    required Map<String, dynamic> roadsGeojson,
    required Map<String, dynamic> inundationGeojson,
    required Map<String, dynamic> sheltersGeojson,
    Map<String, dynamic>? nodesJson,
    Map<String, dynamic>? basinJson,
  }) {
    // roads + edge geometry index
    final roads = <ClassifiedRoad>[];
    final edgeGeom = <String, List<LatLng>>{};
    for (final f in (roadsGeojson['features'] as List)) {
      final road = ClassifiedRoad.fromFeature(f as Map<String, dynamic>);
      roads.add(road);
      if (road.u != null && road.v != null) {
        edgeGeom['${road.u}_${road.v}'] = road.points;
        edgeGeom['${road.v}_${road.u}'] = road.points.reversed.toList();
      }
    }

    // shelters
    final shelters = <SafeZone>[];
    final sheltersById = <String, SafeZone>{};
    for (final f in (sheltersGeojson['features'] as List)) {
      final zone = SafeZone.fromGeoJson(f as Map<String, dynamic>);
      shelters.add(zone);
      sheltersById[zone.id] = zone;
    }

    // nodes
    final nodes = <int, LatLng>{};
    if (nodesJson != null) {
      nodesJson.forEach((k, v) {
        final c = v as List;
        nodes[int.parse(k)] =
            LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble());
      });
    }

    // evacuation basin: { set -> strategy -> node -> entry }. Falls back to the
    // legacy flat format { strategy -> node -> entry } by reusing it for both sets.
    Map<int, BasinEntry> parseStrategy(Map<String, dynamic> nodeMap) {
      final entries = <int, BasinEntry>{};
      nodeMap.forEach((nodeId, e) {
        final m = e as Map<String, dynamic>;
        entries[int.parse(nodeId)] = BasinEntry(
          next: (m['next'] as num?)?.toInt(),
          shelterId: m['shelter'] as String,
          distM: (m['dist_m'] as num?)?.toInt() ?? 0,
          unsafe: (m['n_unsafe'] as num?)?.toInt() ?? 0,
          safety: (m['safety'] as num?)?.toDouble() ?? 0,
        );
      });
      return entries;
    }

    Map<String, Map<int, BasinEntry>> parseSet(Map<String, dynamic> setMap) {
      final out = <String, Map<int, BasinEntry>>{};
      setMap.forEach((strat, nodeMap) {
        out[strat] = parseStrategy(nodeMap as Map<String, dynamic>);
      });
      return out;
    }

    final basin = <String, Map<String, Map<int, BasinEntry>>>{};
    if (basinJson != null && basinJson.isNotEmpty) {
      // nested = { sourceCombo -> strategy -> ... }; legacy flat keys are strategies
      const strategyKeys = {'shortest', 'balanced', 'safest'};
      final isFlat = basinJson.keys.every(strategyKeys.contains);
      if (isFlat) {
        basin['dmc'] = parseSet(basinJson);
      } else {
        basinJson.forEach((setKey, setMap) {
          basin[setKey] = parseSet(setMap as Map<String, dynamic>);
        });
      }
    }

    return DistrictData._(
      district: district,
      roads: roads,
      inundation: _parseInundation(inundationGeojson),
      shelters: shelters,
      nodes: nodes,
      sheltersById: sheltersById,
      basin: basin,
      edgeGeom: edgeGeom,
    );
  }

  static List<InundationArea> _parseInundation(Map<String, dynamic> geojson) {
    final areas = <InundationArea>[];
    List<LatLng> ring(List raw) => raw
        .map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
        .toList();
    InundationArea poly(List rings) => InundationArea(
          outer: ring(rings.first as List),
          holes: rings.skip(1).map((r) => ring(r as List)).toList(),
        );
    for (final f in (geojson['features'] as List? ?? const [])) {
      final geom = (f as Map<String, dynamic>)['geometry'];
      if (geom == null) continue;
      final coords = geom['coordinates'] as List;
      if (geom['type'] == 'Polygon') {
        areas.add(poly(coords));
      } else if (geom['type'] == 'MultiPolygon') {
        for (final p in coords) {
          areas.add(poly(p as List));
        }
      }
    }
    return areas;
  }

  /// True if [p] falls inside any inundation polygon (outside its holes).
  bool isInInundation(LatLng p) {
    for (final a in inundation) {
      if (pointInRing(p, a.outer) && !a.holes.any((h) => pointInRing(p, h))) {
        return true;
      }
    }
    return false;
  }

  int? nearestNode(double lat, double lng) {
    final p = LatLng(lat, lng);
    int? best;
    var bestD = double.infinity;
    nodes.forEach((id, ll) {
      final d = haversineMeters(p, ll);
      if (d < bestD) {
        bestD = d;
        best = id;
      }
    });
    return best;
  }

  /// Trace the precomputed evacuation route to the nearest shelter, fully
  /// offline, using the basin matching the enabled shelter sources (DMC always
  /// on; research/OSM are optional toggles).
  EvacuationRoute traceOffline(
    double lat,
    double lng,
    RouteStrategy strategy, {
    bool includeLiterature = false,
    bool includeOsm = false,
  }) {
    final key = _basinKey(literature: includeLiterature, osm: includeOsm);
    final strat = _basin[key]?[strategy.id];
    if (strat == null) return EvacuationRoute.failsafe(strategy, _routeHint());

    final src = nearestNode(lat, lng);
    if (src == null || !strat.containsKey(src)) {
      return EvacuationRoute.failsafe(strategy);
    }

    final path = <int>[src];
    var cur = src;
    var guard = 0;
    while (strat[cur]?.next != null && guard < 5000) {
      final next = strat[cur]!.next!;
      if (!strat.containsKey(next)) break;
      path.add(next);
      cur = next;
      guard++;
    }

    final points = <LatLng>[];
    for (var i = 0; i < path.length - 1; i++) {
      final a = path[i], b = path[i + 1];
      final na = nodes[a];
      List<LatLng>? seg = _edgeGeom['${a}_${b}'];
      if (seg == null || seg.isEmpty) {
        // no stored geometry: straight line between the two intersections
        final nb = nodes[b];
        seg = [if (na != null) na, if (nb != null) nb];
      } else if (na != null &&
          seg.length >= 2 &&
          _sqDist(seg.last, na) < _sqDist(seg.first, na)) {
        // geometry is stored in the opposite direction; flip it so it runs a -> b
        seg = seg.reversed.toList();
      }
      // append the segment, skipping the vertex shared with the previous one
      points.addAll(points.isEmpty ? seg : seg.skip(1));
    }
    if (points.isEmpty && nodes[src] != null) points.add(nodes[src]!);

    final start = strat[src]!;
    final shelter = _sheltersById[start.shelterId];
    LatLng? shelterLoc;
    if (shelter != null) {
      shelterLoc = LatLng(shelter.latitude, shelter.longitude);
      if (points.isEmpty || points.last != shelterLoc) points.add(shelterLoc);
    }

    return EvacuationRoute(
      found: true,
      strategy: strategy,
      points: points,
      shelterName: shelter?.name,
      shelterLocation: shelterLoc,
      distanceM: start.distM,
      unsafeSegments: start.unsafe,
      safety: start.safety,
    );
  }
}
