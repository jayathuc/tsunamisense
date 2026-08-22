import '../../core/constants/app_constants.dart';
import '../models/earthquake.dart';

/// Result of evaluating recent seismicity against the tsunami threat rules.
class ThreatAssessment {
  final AlertLevel level;
  final Earthquake? trigger;
  const ThreatAssessment(this.level, this.trigger);
}

/// Decides whether recent earthquakes represent a tsunami threat to Sri Lanka.
///
/// Kept free of Flutter and of any provider so the same rules run in the UI and
/// in the background isolate. Two callers evaluating threat differently would be
/// a genuine hazard, so there is deliberately only one implementation.
class ThreatEvaluator {
  /// Subduction zones whose great earthquakes can send a tele-tsunami to Sri
  /// Lanka. Sri Lanka sits on a stable plate with no near-field source, so only
  /// far-field events from these specific zones are a real threat.
  /// [minLat, maxLat, minLon, maxLon]
  static const List<List<double>> tsunamiSources = [
    [-8.0, 16.0, 90.0, 104.0], // Sumatra-Andaman (Sunda Trench), the 2004 source
    [22.0, 27.0, 56.0, 68.0], // Makran Subduction Zone (off Pakistan / Iran)
  ];

  /// Below this magnitude a quake cannot generate a damaging tele-tsunami.
  static const double minMagnitude = 7.5;

  /// Above this, treat it as a watch rather than an advisory.
  static const double watchMagnitude = 8.0;

  /// Tsunamis come from shallow ruptures; deeper events displace little water.
  static const double maxDepthKm = 70.0;

  /// Events older than this are no longer actionable.
  static const Duration maxAge = Duration(hours: 24);

  static bool inTsunamiSource(Earthquake eq) => tsunamiSources.any((z) =>
      eq.latitude >= z[0] &&
      eq.latitude <= z[1] &&
      eq.longitude >= z[2] &&
      eq.longitude <= z[3]);

  /// True when a single event meets every threat criterion.
  static bool isThreat(Earthquake eq, {DateTime? now}) {
    final ref = now ?? DateTime.now();
    if (ref.difference(eq.time) > maxAge) return false;
    if (eq.depth > maxDepthKm) return false;
    if (eq.magnitude < minMagnitude) return false;
    return inTsunamiSource(eq);
  }

  /// Highest threat level across [earthquakes], with the event that caused it.
  ///
  /// An emergency is never raised from seismicity alone; that requires a
  /// confirmed tsunami bulletin from [WarningService].
  static ThreatAssessment evaluate(
    List<Earthquake> earthquakes, {
    DateTime? now,
  }) {
    var level = AlertLevel.none;
    Earthquake? trigger;

    for (final eq in earthquakes) {
      if (!isThreat(eq, now: now)) continue;
      final l =
          eq.magnitude >= watchMagnitude ? AlertLevel.warning : AlertLevel.advisory;
      if (rank(l) > rank(level)) {
        level = l;
        trigger = eq;
      }
    }
    return ThreatAssessment(level, trigger);
  }

  static int rank(AlertLevel l) => AlertLevel.values.indexOf(l);
}
