// Smoke test: the app boots to its main navigation without throwing.
//
// This guards the start-up path in particular. The providers notify their
// listeners as soon as they begin loading, so kicking that off at the wrong
// moment throws "setState() called during build"; that used to happen on every
// launch, and takeException() below is what catches it.
//
// The Hive cache is pre-seeded with one minimal map-only district so start-up
// resolves entirely from cache. Letting it fall through to the bundled seed
// assets would deadlock: rootBundle needs real async, which testWidgets'
// fake-async zone does not run.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tsunamisense_app/data/services/getra_service.dart';
import 'package:tsunamisense_app/main.dart';

const _districtId = 'testville';

const _registry = {
  'version': 'test',
  'districts': [
    {
      'id': _districtId,
      'name': 'Testville',
      'capabilities': ['map'],
      'bbox': [80.0, 6.0, 80.1, 6.1],
      'center': [6.05, 80.05],
      'version': 'v1',
      'counts': <String, dynamic>{},
    }
  ],
};

const _emptyCollection = {'type': 'FeatureCollection', 'features': []};

void main() {
  late Directory tempDir;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tempDir = await Directory.systemTemp.createTemp('tsunamisense_test');
    Hive.init(tempDir.path);
    await GetraService.initCache();

    final box = Hive.box(GetraService.boxName);
    await box.put('registry', jsonEncode(_registry));
    for (final f in ['roads', 'inundation', 'shelters']) {
      await box.put('$_districtId/$f', jsonEncode(_emptyCollection));
    }
    // Matching version means the bundle is not stale, so no download is tried.
    await box.put('$_districtId/version', 'v1');
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  testWidgets('app boots to main navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const TsunamiSenseApp());

    // Fixed pumps rather than pumpAndSettle: the app polls on a periodic timer,
    // so it never reaches a "no frames scheduled" state.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(tester.takeException(), isNull);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);

    // Unmount so the polling timer is cancelled before the test ends.
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
