// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get poweredByGetra => 'Powered by GETRA';

  @override
  String get navHome => 'Home';

  @override
  String get navLearn => 'Learn';

  @override
  String get navMap => 'Map';

  @override
  String get navPrepare => 'Prepare';

  @override
  String get navSettings => 'Settings';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Retry';

  @override
  String get homeCurrentStatus => 'Current Status';

  @override
  String homeLastUpdated(String time) {
    return 'Last updated: $time';
  }

  @override
  String get homeJustNow => 'Just now';

  @override
  String homeMinutesAgo(int m) {
    return '${m}m ago';
  }

  @override
  String homeHoursAgo(int h) {
    return '${h}h ago';
  }

  @override
  String get homeQuickActions => 'Quick Actions';

  @override
  String get homeFindSafeZone => 'Find Safe Zone';

  @override
  String get homeBePrepared => 'Be Prepared';

  @override
  String get homeRecentSeismic => 'Recent Seismic Activity';

  @override
  String get homeNoEarthquakes => 'No significant earthquakes detected';

  @override
  String get homeYourProgress => 'Your Progress';

  @override
  String get homeLessons => 'Lessons';

  @override
  String get homePrepared => 'Prepared';

  @override
  String homeDepthKm(int km) {
    return 'Depth: $km km';
  }

  @override
  String get alertNoThreat => 'No Threat';

  @override
  String get alertAdvisory => 'Advisory';

  @override
  String get alertWarning => 'Warning';

  @override
  String get alertEmergency => 'Emergency';

  @override
  String get alertNoThreatDesc =>
      'No tsunami threat detected. Stay informed and prepared.';

  @override
  String get alertAdvisoryDesc =>
      'Earthquake detected. Be prepared and monitor updates.';

  @override
  String get alertWarningDesc =>
      'Tsunami possible. Prepare to evacuate if near coast.';

  @override
  String get alertEmergencyDesc =>
      'TSUNAMI CONFIRMED. Evacuate immediately to high ground!';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get enableNotificationsSubtitle =>
      'Receive earthquake and tsunami alerts';

  @override
  String get soundLabel => 'Sound';

  @override
  String get soundSubtitle => 'Play alert sound for notifications';

  @override
  String get vibrationLabel => 'Vibration';

  @override
  String get vibrationSubtitle => 'Vibrate for notifications';

  @override
  String get sectionAlertSettings => 'Alert Settings';

  @override
  String get alertRadius => 'Alert Radius';

  @override
  String alertRadiusValue(int km) {
    return '$km km from Sri Lanka coast';
  }

  @override
  String get showAllEarthquakes => 'Show All Earthquakes';

  @override
  String get showAllEarthquakesSubtitle => 'Include earthquakes below M5.0';

  @override
  String get testAlert => 'Test Alert';

  @override
  String get testAlertSubtitle => 'Send a test notification';

  @override
  String get testNotificationSent => 'Test notification sent';

  @override
  String get sectionDisplay => 'Display';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeSubtitle => 'Use dark theme';

  @override
  String get sectionEvacuationMap => 'Evacuation Map';

  @override
  String get showResearchShelters => 'Show research-supported shelters';

  @override
  String get showResearchSheltersSubtitle =>
      'Also show last-resort shelters identified in published research. DMC-verified shelters are always shown.';

  @override
  String get showOsmShelters => 'Show OpenStreetMap shelters';

  @override
  String get showOsmSheltersSubtitle =>
      'Auto-identified public buildings (schools, temples, hospitals) on high ground. Unverified.';

  @override
  String get sectionDataStorage => 'Data & Storage';

  @override
  String get offlineMode => 'Offline Maps';

  @override
  String get offlineModeSubtitle =>
      'Download map tiles for the current district';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearCacheSubtitle => 'Free up storage space';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataSubtitle => 'Export checklist and progress';

  @override
  String get cacheCleared => 'Cache cleared successfully';

  @override
  String get clearCacheTitle => 'Clear Cache?';

  @override
  String get clearCacheBody =>
      'This will remove cached map tiles and data. You may need to re-download them for offline use.';

  @override
  String get sectionDeveloper => 'Developer';

  @override
  String get developerMode => 'Developer mode';

  @override
  String get developerModeSubtitle =>
      'Show simulate/test controls used for demos and testing.';

  @override
  String get sectionAbout => 'About';

  @override
  String get aboutTsunamiSense => 'About TsunamiSense';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get openSourceLicenses => 'Open Source Licenses';

  @override
  String get sectionEmergencyContacts => 'Emergency Contacts';

  @override
  String get contactNationalDisaster => 'National Disaster Management';

  @override
  String get contactPolice => 'Police Emergency';

  @override
  String get contactAmbulance => 'Ambulance Service';

  @override
  String get contactFire => 'Fire & Rescue';

  @override
  String get offlineDownloadTitle => 'Download offline maps';

  @override
  String offlineDownloadBody(String district) {
    return 'Map tiles for $district will be downloaded so the map works with no internet. This may use several megabytes.';
  }

  @override
  String get offlineDownloadStart => 'Download';

  @override
  String get offlineDownloading => 'Downloading map tiles…';

  @override
  String offlineDownloadProgress(int done, int total) {
    return '$done of $total tiles';
  }

  @override
  String offlineDownloadDone(String district) {
    return 'Offline maps ready for $district';
  }

  @override
  String get offlineDownloadFailed =>
      'Download did not finish. Please try again on a better connection.';

  @override
  String get mapTitle => 'Evacuation Map';

  @override
  String get mapTapToRoute =>
      'Tap “My location”, or tap anywhere on the map, to find the safest route to a shelter.';

  @override
  String mapToShelter(String shelter) {
    return 'To $shelter';
  }

  @override
  String get mapNearestShelter => 'nearest shelter';

  @override
  String get mapOsmUnverified =>
      'OpenStreetMap shelters are auto-identified and unverified.';

  @override
  String get mapRouteStrategySafest => 'Safest';

  @override
  String get mapRouteStrategyBalanced => 'Balanced';

  @override
  String get mapRouteStrategyShortest => 'Fastest';

  @override
  String get mapLegendSafeRoad => 'Safe road';

  @override
  String get mapLegendFloodRoad => 'Flood-prone road';

  @override
  String get mapLegendInundation => 'Inundation zone';

  @override
  String get mapLegendDmc => 'DMC shelter';

  @override
  String get mapLegendResearch => 'Research shelter';

  @override
  String get mapLegendOsm => 'OSM shelter';

  @override
  String get mapLegendYou => 'You';

  @override
  String get mapLayers => 'Map layers';

  @override
  String get mapLayerRoads => 'Road safety';

  @override
  String get mapLayerInundation => 'Inundation zone';

  @override
  String get mapLayerShelters => 'Shelters';

  @override
  String get mapSwitchDistrict => 'Switch district';

  @override
  String get mapMapOnly => 'Map only';

  @override
  String get districtGalle => 'Galle';

  @override
  String get districtMatara => 'Matara';

  @override
  String get districtTangalle => 'Tangalle';

  @override
  String mapMinutesShort(int minutes) {
    return '~$minutes min';
  }

  @override
  String mapPctSafe(int pct) {
    return '$pct% safe';
  }

  @override
  String mapPctRisky(int pct, int n) {
    return '$pct% • $n risky';
  }

  @override
  String mapRouteHeading(String strategy) {
    return '$strategy route';
  }

  @override
  String mapDistrictTitle(String district) {
    return '$district Map';
  }

  @override
  String get mapLoading => 'Loading evacuation map…';

  @override
  String get mapUnavailable => 'Map unavailable.';

  @override
  String get locationPermissionDenied =>
      'Location permission is off. Enable it in Settings, or tap the map to set a start point.';

  @override
  String get locationServicesOff =>
      'Location services are off. Turn on GPS, or tap the map to set a start point.';

  @override
  String get locationUnavailable =>
      'Could not get a location fix. Tap the map to set a start point.';

  @override
  String get locationPermissionDeniedEmergency =>
      'Location permission is off. Enable it in Settings to get your evacuation route, or tap the map.';

  @override
  String get locationServicesOffEmergency =>
      'Location services are off. Turn on GPS to get your evacuation route, or tap the map.';

  @override
  String get emergencyTitle => 'TSUNAMI WARNING';

  @override
  String get emergencyEvacuateNow => 'Evacuate now';

  @override
  String get emergencyLocating => 'Locating you…';

  @override
  String get emergencyWaveArrivesIn => 'Wave arrives in';

  @override
  String get emergencyMoveInland =>
      'Move inland and uphill, away from the coast.';

  @override
  String emergencyArrivalEstimate(int minutes) {
    return 'Wave in ~$minutes min';
  }

  @override
  String get emergencyDemoModel => 'Estimated • demonstration model';

  @override
  String get emergencyEndDrill => 'End drill';

  @override
  String emergencyFollowRoute(String shelter) {
    return 'Follow the route to $shelter; move inland and uphill.';
  }

  @override
  String emergencyMayNotReach(String shelter) {
    return 'You may not reach $shelter in time. Move inland and uphill to the nearest high ground now.';
  }

  @override
  String get commonNext => 'Next';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonReset => 'Reset';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonSave => 'Save';

  @override
  String learnCompletedCount(int done, int total) {
    return '$done/$total completed';
  }

  @override
  String get learnNoLessons => 'No lessons available';

  @override
  String get learnLessons => 'Lessons';

  @override
  String get learnProgressTitle => 'Your Learning Progress';

  @override
  String learnPercentComplete(int pct) {
    return '$pct% Complete';
  }

  @override
  String get learnStartPrompt =>
      'Start your first lesson to learn how to stay safe!';

  @override
  String get learnKeepGoing => 'Keep going! You are doing great!';

  @override
  String get learnAllDone => 'All lessons completed! You are well prepared.';

  @override
  String learnMinutes(int min) {
    return '$min min';
  }

  @override
  String learnMinRead(int min) {
    return '$min min read';
  }

  @override
  String get learnQuiz => 'Quiz';

  @override
  String learnLessonNumber(int n) {
    return 'Lesson $n';
  }

  @override
  String get learnTakeQuiz => 'Take Quiz';

  @override
  String get learnCompleted => 'Completed ✓';

  @override
  String get learnMarkComplete => 'Mark as Complete';

  @override
  String learnQuestionOf(int n, int total) {
    return 'Question $n of $total';
  }

  @override
  String get learnSeeResults => 'See Results';

  @override
  String get learnGreatJob => 'Great Job!';

  @override
  String get learnKeepLearning => 'Keep Learning';

  @override
  String learnScore(int correct, int total, int pct) {
    return 'You got $correct out of $total correct ($pct%)';
  }

  @override
  String get learnCompleteLesson => 'Complete Lesson';

  @override
  String get learnReviewLesson => 'Review Lesson';

  @override
  String get learnLessonDoneToast => 'Lesson completed!';

  @override
  String get prepareTitle => 'Prepare';

  @override
  String get prepareResetTooltip => 'Reset checklist';

  @override
  String get prepareShareTooltip => 'Share checklist';

  @override
  String get prepareAddItem => 'Add Item';

  @override
  String get prepareResetTitle => 'Reset Checklist?';

  @override
  String get prepareResetBody =>
      'This will uncheck all items. Your notes will be preserved.';

  @override
  String get prepareResetDone => 'Checklist reset';

  @override
  String get prepareAddCustomTitle => 'Add Custom Item';

  @override
  String get prepareCategory => 'Category';

  @override
  String get prepareItemName => 'Item name';

  @override
  String get prepareItemAdded => 'Item added';

  @override
  String get prepareFullyPrepared => '🎉 Fully Prepared!';

  @override
  String get preparePreparednessLevel => 'Preparedness Level';

  @override
  String get prepareCompleteMsg =>
      'Great job! You have everything ready for an emergency.';

  @override
  String get prepareIncompleteMsg =>
      'Complete the checklist to ensure you are ready for emergencies.';

  @override
  String prepareItemsComplete(int done, int total) {
    return '$done of $total complete';
  }

  @override
  String get prepareRequired => 'Required';

  @override
  String get prepareNoteTitle => 'Add a note';

  @override
  String get prepareNoteHint => 'Add a note (e.g., location, expiry date)';

  @override
  String get prepareTipsTitle => 'Preparation Tips';

  @override
  String get prepareTip1Title => 'Regular Updates';

  @override
  String get prepareTip1Body =>
      'Review and update your emergency kit every 6 months.';

  @override
  String get prepareTip2Title => 'Water Storage';

  @override
  String get prepareTip2Body =>
      'Store 3 litres of water per person per day for at least 3 days.';

  @override
  String get prepareTip3Title => 'Emergency Contacts';

  @override
  String get prepareTip3Body =>
      'Keep a written list of emergency contacts in your kit.';

  @override
  String get prepareTip4Title => 'Family Plan';

  @override
  String get prepareTip4Body =>
      'Discuss and practice evacuation routes with your family.';

  @override
  String get prepareTip5Title => 'Meeting Point';

  @override
  String get prepareTip5Body =>
      'Designate a meeting point in case family members are separated.';

  @override
  String get mapTsunamiWarning => 'TSUNAMI WARNING';

  @override
  String get mapOfflineBanner => 'Offline, saved map';

  @override
  String get mapEvacuationMap => 'Evacuation Map';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get openSettings => 'Open settings';

  @override
  String get locationApproximate =>
      'Using your last known location; it may be approximate.';

  @override
  String get earthquakeViewOnMap => 'View on Map';

  @override
  String get earthquakeUsgsDetails => 'USGS Details';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get mapDataStale =>
      'Hazard data may be out of date. Connect to refresh.';

  @override
  String mapDataAgeDays(int days) {
    return 'Data updated $days days ago';
  }

  @override
  String get mapDataNeverUpdated => 'Using data bundled with the app';

  @override
  String a11yRouteSummary(
    String shelter,
    int distance,
    int minutes,
    int unsafe,
  ) {
    return 'Evacuation route to $shelter. $distance metres, about $minutes minutes walk. $unsafe risky road segments.';
  }

  @override
  String a11yMapLabel(String district) {
    return 'Evacuation map of $district. Shows classified roads, the inundation zone and shelters.';
  }

  @override
  String get a11yMyLocation =>
      'Find my location and route to the nearest shelter';

  @override
  String get a11yResetNorth => 'Reset map orientation to north';

  @override
  String get a11yClearRoute => 'Clear the current route';

  @override
  String get a11yLegend => 'Map legend';
}
