import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../core/constants/app_constants.dart';
import 'earthquake_service.dart';
import 'notification_service.dart';
import 'threat_evaluator.dart';
import 'warning_service.dart';

/// Periodic tsunami check that runs even when the app is closed.
///
/// Without this the app can only warn someone who already has it open, which is
/// the opposite of what an early-warning app is for. The in-app timer stops the
/// moment Android suspends the process.
///
/// Fifteen minutes is the shortest period Android's WorkManager honours, and it
/// is sufficient here: Sri Lanka has no near-field tsunami source, so the threat
/// is always tele-tsunami from the Sunda Trench or Makran, which takes on the
/// order of two hours to arrive.
class BackgroundMonitor {
  static const String taskName = 'tsunamisense.threatCheck';
  static const String _uniqueName = 'tsunamisense-threat-check';
  static const Duration interval = Duration(minutes: 15);

  /// Last level we notified about, so a persisting threat is announced once
  /// rather than every quarter of an hour.
  static const String _lastNotifiedKey = 'bg_last_notified_level';

  static Future<void> register() async {
    // iOS background execution is opportunistic and cannot be relied on for
    // life safety; Android is where this actually delivers.
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      _uniqueName,
      taskName,
      frequency: interval,
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(networkType: NetworkType.connected),
      backoffPolicy: BackoffPolicy.linear,
    );
  }

  static Future<void> cancel() =>
      Workmanager().cancelByUniqueName(_uniqueName);

  /// One threat check. Returns true if it completed without throwing.
  ///
  /// Runs in a background isolate with no access to app state, so everything it
  /// needs is fetched fresh and compared against SharedPreferences.
  static Future<bool> runCheck() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final previous = prefs.getInt(_lastNotifiedKey) ?? 0;

      // A confirmed bulletin outranks anything inferred from seismicity.
      final warning = await WarningService().fetchTsunamiWarning();
      if (warning != null) {
        if (previous < ThreatEvaluator.rank(AlertLevel.emergency)) {
          await NotificationService.show(
            'Tsunami warning',
            'An official tsunami warning is active for the region. Open '
                'TsunamiSense and evacuate to your nearest shelter now.',
            urgent: true,
          );
          await prefs.setInt(
              _lastNotifiedKey, ThreatEvaluator.rank(AlertLevel.emergency));
        }
        return true;
      }

      final quakes = await EarthquakeService().fetchRecentEarthquakes(
        minMagnitude: ThreatEvaluator.minMagnitude,
        limit: 20,
      );
      final assessment = ThreatEvaluator.evaluate(quakes);
      final rank = ThreatEvaluator.rank(assessment.level);

      // Only speak up when things get worse than what we last reported.
      if (rank > previous) {
        if (assessment.level == AlertLevel.warning) {
          await NotificationService.show(
            'Tsunami watch',
            'A strong offshore earthquake occurred near a known tsunami source. '
                'Be ready to evacuate.',
            urgent: true,
          );
        } else if (assessment.level == AlertLevel.advisory) {
          await NotificationService.show(
            'Tsunami advisory',
            'A possible tsunami-generating earthquake was detected. Review your '
                'safe route.',
          );
        }
      }
      await prefs.setInt(_lastNotifiedKey, rank);
      return true;
    } catch (e) {
      debugPrint('[bg] threat check failed: $e');
      // Returning true avoids WorkManager backing the schedule off because the
      // network happened to be unavailable for one run.
      return true;
    }
  }
}

/// Entry point for the background isolate. Must be a top-level function.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, _) async {
    if (task != BackgroundMonitor.taskName) return true;
    await NotificationService.init();
    return BackgroundMonitor.runCheck();
  });
}
