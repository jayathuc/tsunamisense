// The threat rules decide whether the app wakes someone in the middle of the
// night, and they now run in the background isolate as well as the UI. Both a
// missed warning and a false alarm are serious, so the boundaries are pinned
// here explicitly.

import 'package:flutter_test/flutter_test.dart';

import 'package:tsunamisense_app/core/constants/app_constants.dart';
import 'package:tsunamisense_app/data/models/earthquake.dart';
import 'package:tsunamisense_app/data/services/threat_evaluator.dart';

final _now = DateTime.utc(2026, 8, 22, 12);

Earthquake quake({
  double magnitude = 8.0,
  double depth = 20,
  double lat = 3.0, // Sunda Trench
  double lon = 96.0,
  Duration age = const Duration(hours: 1),
}) {
  return Earthquake(
    id: 'test',
    magnitude: magnitude,
    place: 'test',
    time: _now.subtract(age),
    latitude: lat,
    longitude: lon,
    depth: depth,
    url: '',
  );
}

void main() {
  group('single event', () {
    test('great shallow quake in the Sunda Trench is a threat', () {
      expect(ThreatEvaluator.isThreat(quake(), now: _now), isTrue);
    });

    test('Makran subduction zone also counts as a source', () {
      expect(
        ThreatEvaluator.isThreat(quake(lat: 24.5, lon: 62.0), now: _now),
        isTrue,
      );
    });

    test('below M7.5 is not a tele-tsunami threat', () {
      expect(ThreatEvaluator.isThreat(quake(magnitude: 7.4), now: _now), isFalse);
      expect(ThreatEvaluator.isThreat(quake(magnitude: 7.5), now: _now), isTrue);
    });

    test('deep ruptures displace too little water', () {
      expect(ThreatEvaluator.isThreat(quake(depth: 70), now: _now), isTrue);
      expect(ThreatEvaluator.isThreat(quake(depth: 70.1), now: _now), isFalse);
    });

    test('events older than a day are no longer actionable', () {
      expect(
        ThreatEvaluator.isThreat(quake(age: const Duration(hours: 23)), now: _now),
        isTrue,
      );
      expect(
        ThreatEvaluator.isThreat(quake(age: const Duration(hours: 25)), now: _now),
        isFalse,
      );
    });

    test('a huge quake outside the known source zones is ignored', () {
      // M9 off Japan: devastating locally, no threat to Sri Lanka.
      expect(
        ThreatEvaluator.isThreat(quake(magnitude: 9.0, lat: 38.0, lon: 142.0),
            now: _now),
        isFalse,
      );
    });
  });

  group('overall assessment', () {
    test('no earthquakes means no alert', () {
      expect(ThreatEvaluator.evaluate([], now: _now).level, AlertLevel.none);
    });

    test('M7.5 to M8.0 raises an advisory', () {
      final a = ThreatEvaluator.evaluate([quake(magnitude: 7.7)], now: _now);
      expect(a.level, AlertLevel.advisory);
      expect(a.trigger, isNotNull);
    });

    test('M8.0 and above raises a watch', () {
      expect(
        ThreatEvaluator.evaluate([quake(magnitude: 8.0)], now: _now).level,
        AlertLevel.warning,
      );
    });

    test('the most severe qualifying event wins', () {
      final a = ThreatEvaluator.evaluate(
        [quake(magnitude: 7.6), quake(magnitude: 8.4), quake(magnitude: 5.0)],
        now: _now,
      );
      expect(a.level, AlertLevel.warning);
      expect(a.trigger!.magnitude, 8.4);
    });

    test('seismicity alone never declares an emergency', () {
      // Emergency requires a confirmed bulletin, not an earthquake.
      final a = ThreatEvaluator.evaluate([quake(magnitude: 9.5)], now: _now);
      expect(a.level, isNot(AlertLevel.emergency));
    });

    test('a quiet week of small quakes stays silent', () {
      final quiet = [
        quake(magnitude: 5.2),
        quake(magnitude: 6.1, depth: 30),
        quake(magnitude: 6.9, lat: 10.0, lon: 93.0),
      ];
      expect(ThreatEvaluator.evaluate(quiet, now: _now).level, AlertLevel.none);
    });
  });
}
