// Proves the app's central claim: with no network at all and an empty cache, a
// first launch can still load a district and trace a full evacuation route from
// the data bundled inside the app.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:tsunamisense_app/data/models/route_strategy.dart';
import 'package:tsunamisense_app/data/services/getra_service.dart';

/// Stands in for a device with no connectivity.
class _OfflineClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      Future.error(const SocketException('offline'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late GetraService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('tsunamisense_offline');
    Hive.init(tempDir.path);
    await GetraService.initCache();
    service = GetraService(client: _OfflineClient());
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('loads the registry offline from bundled data', () async {
    final reg = await service.fetchDistricts();
    expect(reg.fromCache, isTrue);
    expect(reg.districts.map((d) => d.id), contains('galle'));
  });

  test('traces a real evacuation route offline on a cold cache', () async {
    final reg = await service.fetchDistricts();
    final galle = reg.districts.firstWhere((d) => d.id == 'galle');

    final loaded = await service.loadDistrict(galle);
    expect(loaded.fromCache, isTrue);

    final data = loaded.data;
    expect(data.roads, isNotEmpty);
    expect(data.shelters, isNotEmpty);
    expect(data.hasRouting, isTrue);

    // A point inside Galle's coastal area, routed with DMC shelters only.
    final route = data.traceOffline(6.0335, 80.2170, RouteStrategy.safest);

    expect(route.found, isTrue);
    expect(route.points.length, greaterThan(1));
    expect(route.shelterName, isNotNull);
    expect(route.distanceM, greaterThan(0));
    expect(route.walkMinutes, greaterThan(0));
  });

  test('safest strategy is no more dangerous than shortest', () async {
    final reg = await service.fetchDistricts();
    final galle = reg.districts.firstWhere((d) => d.id == 'galle');
    final data = (await service.loadDistrict(galle)).data;

    final shortest =
        data.traceOffline(6.0335, 80.2170, RouteStrategy.shortest);
    final safest = data.traceOffline(6.0335, 80.2170, RouteStrategy.safest);

    expect(shortest.found, isTrue);
    expect(safest.found, isTrue);
    expect(safest.unsafeSegments, lessThanOrEqualTo(shortest.unsafeSegments));
  });
}
