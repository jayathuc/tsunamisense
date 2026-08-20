import 'dart:convert';
import 'dart:io' show gzip;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

/// Guards the offline-first promise: every district in the bundled registry must
/// ship a complete, decodable set of seed assets, so a first launch with no
/// network still gets a map and routing tables.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<Map<String, dynamic>> loadGz(String path) async {
    final data = await rootBundle.load('assets/getra/$path');
    return jsonDecode(utf8.decode(gzip.decode(data.buffer.asUint8List())))
        as Map<String, dynamic>;
  }

  test('bundled registry lists districts', () async {
    final reg = await loadGz('districts.json.gz');
    final ids = (reg['districts'] as List).map((d) => d['id']).toList();
    expect(ids, containsAll(<String>['galle', 'matara', 'tangalle']));
  });

  test('every district ships a complete, routable bundle', () async {
    final reg = await loadGz('districts.json.gz');
    for (final d in reg['districts'] as List) {
      final id = d['id'] as String;
      final hasRouting =
          (d['capabilities'] as List).contains('routing');

      final roads = await loadGz('$id/roads.gz');
      expect((roads['features'] as List), isNotEmpty, reason: '$id roads');

      final shelters = await loadGz('$id/shelters.gz');
      expect((shelters['features'] as List), isNotEmpty,
          reason: '$id shelters');

      await loadGz('$id/inundation.gz');

      if (hasRouting) {
        final nodes = await loadGz('$id/nodes.gz');
        expect(nodes.keys, isNotEmpty, reason: '$id nodes');

        final basin = await loadGz('$id/evac_basin.gz');
        expect(basin.keys, isNotEmpty, reason: '$id basin sets');
        // set -> strategy -> node
        for (final set in basin.keys) {
          final strategies = basin[set] as Map<String, dynamic>;
          expect(strategies.keys,
              containsAll(<String>['shortest', 'balanced', 'safest']),
              reason: '$id/$set strategies');
        }
      }
    }
  });
}
