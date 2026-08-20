/// Application-wide constants for TsunamiSense
class AppConstants {
  // App Information
  static const String appName = 'TsunamiSense';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Learn. Prepare. Stay Safe.';

  // Galle District Coordinates (MVP Coverage Area)
  static const double galleLatitude = 6.0535;
  static const double galleLongitude = 80.2210;
  static const double galleMinLat = 5.9;
  static const double galleMaxLat = 6.3;
  static const double galleMinLng = 80.0;
  static const double galleMaxLng = 80.5;

  // Sri Lanka Center
  static const double sriLankaLatitude = 7.8731;
  static const double sriLankaLongitude = 80.7718;

  // Indian Ocean Bounding Box for Earthquake Monitoring
  static const double indianOceanMinLat = -10.0;
  static const double indianOceanMaxLat = 30.0;
  static const double indianOceanMinLng = 50.0;
  static const double indianOceanMaxLng = 100.0;

  // Alert Thresholds
  static const double advisoryMagnitude = 6.0; // Yellow alert
  static const double emergencyMagnitude = 7.0; // Red alert
  static const double tsunamiMinMagnitude = 5.0; // Minimum to track

  // Safe Zone Criteria
  static const double safeElevationMeters = 10.0;
  static const double maxEvacuationDistanceKm = 5.0;

  // API Polling Intervals
  static const int earthquakePollingMinutes = 1;
  static const int alertCheckSeconds = 30;

  // Cache Durations
  static const int lessonCacheDays = 30;
  static const int mapTileCacheDays = 7;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
}

/// Alert levels for the application
enum AlertLevel {
  none,
  advisory, // Yellow - Earthquake detected, be prepared
  warning, // Orange - Tsunami possible
  emergency, // Red - Tsunami confirmed, evacuate
}

/// Extension to get alert level properties
extension AlertLevelExtension on AlertLevel {
  String get name {
    switch (this) {
      case AlertLevel.none:
        return 'No Threat';
      case AlertLevel.advisory:
        return 'Advisory';
      case AlertLevel.warning:
        return 'Warning';
      case AlertLevel.emergency:
        return 'Emergency';
    }
  }

  String get description {
    switch (this) {
      case AlertLevel.none:
        return 'No tsunami threat detected. Stay informed and prepared.';
      case AlertLevel.advisory:
        return 'Earthquake detected. Be prepared and monitor updates.';
      case AlertLevel.warning:
        return 'Tsunami possible. Prepare to evacuate if near coast.';
      case AlertLevel.emergency:
        return 'TSUNAMI CONFIRMED. Evacuate immediately to high ground!';
    }
  }

  String get emoji {
    switch (this) {
      case AlertLevel.none:
        return '✅';
      case AlertLevel.advisory:
        return '🟡';
      case AlertLevel.warning:
        return '🟠';
      case AlertLevel.emergency:
        return '🔴';
    }
  }
}
