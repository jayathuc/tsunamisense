import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
    Locale('ta'),
  ];

  /// No description provided for @poweredByGetra.
  ///
  /// In en, this message translates to:
  /// **'Powered by GETRA'**
  String get poweredByGetra;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navPrepare.
  ///
  /// In en, this message translates to:
  /// **'Prepare'**
  String get navPrepare;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @homeCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get homeCurrentStatus;

  /// No description provided for @homeLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String homeLastUpdated(String time);

  /// No description provided for @homeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get homeJustNow;

  /// No description provided for @homeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{m}m ago'**
  String homeMinutesAgo(int m);

  /// No description provided for @homeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{h}h ago'**
  String homeHoursAgo(int h);

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActions;

  /// No description provided for @homeFindSafeZone.
  ///
  /// In en, this message translates to:
  /// **'Find Safe Zone'**
  String get homeFindSafeZone;

  /// No description provided for @homeBePrepared.
  ///
  /// In en, this message translates to:
  /// **'Be Prepared'**
  String get homeBePrepared;

  /// No description provided for @homeRecentSeismic.
  ///
  /// In en, this message translates to:
  /// **'Recent Seismic Activity'**
  String get homeRecentSeismic;

  /// No description provided for @homeNoEarthquakes.
  ///
  /// In en, this message translates to:
  /// **'No significant earthquakes detected'**
  String get homeNoEarthquakes;

  /// No description provided for @homeYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get homeYourProgress;

  /// No description provided for @homeLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get homeLessons;

  /// No description provided for @homePrepared.
  ///
  /// In en, this message translates to:
  /// **'Prepared'**
  String get homePrepared;

  /// No description provided for @homeDepthKm.
  ///
  /// In en, this message translates to:
  /// **'Depth: {km} km'**
  String homeDepthKm(int km);

  /// No description provided for @alertNoThreat.
  ///
  /// In en, this message translates to:
  /// **'No Threat'**
  String get alertNoThreat;

  /// No description provided for @alertAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Advisory'**
  String get alertAdvisory;

  /// No description provided for @alertWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get alertWarning;

  /// No description provided for @alertEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get alertEmergency;

  /// No description provided for @alertNoThreatDesc.
  ///
  /// In en, this message translates to:
  /// **'No tsunami threat detected. Stay informed and prepared.'**
  String get alertNoThreatDesc;

  /// No description provided for @alertAdvisoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Earthquake detected. Be prepared and monitor updates.'**
  String get alertAdvisoryDesc;

  /// No description provided for @alertWarningDesc.
  ///
  /// In en, this message translates to:
  /// **'Tsunami possible. Prepare to evacuate if near coast.'**
  String get alertWarningDesc;

  /// No description provided for @alertEmergencyDesc.
  ///
  /// In en, this message translates to:
  /// **'TSUNAMI CONFIRMED. Evacuate immediately to high ground!'**
  String get alertEmergencyDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get sectionNotifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @enableNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive earthquake and tsunami alerts'**
  String get enableNotificationsSubtitle;

  /// No description provided for @soundLabel.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get soundLabel;

  /// No description provided for @soundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play alert sound for notifications'**
  String get soundSubtitle;

  /// No description provided for @vibrationLabel.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibrationLabel;

  /// No description provided for @vibrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vibrate for notifications'**
  String get vibrationSubtitle;

  /// No description provided for @sectionAlertSettings.
  ///
  /// In en, this message translates to:
  /// **'Alert Settings'**
  String get sectionAlertSettings;

  /// No description provided for @alertRadius.
  ///
  /// In en, this message translates to:
  /// **'Alert Radius'**
  String get alertRadius;

  /// No description provided for @alertRadiusValue.
  ///
  /// In en, this message translates to:
  /// **'{km} km from Sri Lanka coast'**
  String alertRadiusValue(int km);

  /// No description provided for @showAllEarthquakes.
  ///
  /// In en, this message translates to:
  /// **'Show All Earthquakes'**
  String get showAllEarthquakes;

  /// No description provided for @showAllEarthquakesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Include earthquakes below M5.0'**
  String get showAllEarthquakesSubtitle;

  /// No description provided for @testAlert.
  ///
  /// In en, this message translates to:
  /// **'Test Alert'**
  String get testAlert;

  /// No description provided for @testAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification'**
  String get testAlertSubtitle;

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get testNotificationSent;

  /// No description provided for @sectionDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get sectionDisplay;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get darkModeSubtitle;

  /// No description provided for @sectionEvacuationMap.
  ///
  /// In en, this message translates to:
  /// **'Evacuation Map'**
  String get sectionEvacuationMap;

  /// No description provided for @showResearchShelters.
  ///
  /// In en, this message translates to:
  /// **'Show research-supported shelters'**
  String get showResearchShelters;

  /// No description provided for @showResearchSheltersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Also show last-resort shelters identified in published research. DMC-verified shelters are always shown.'**
  String get showResearchSheltersSubtitle;

  /// No description provided for @showOsmShelters.
  ///
  /// In en, this message translates to:
  /// **'Show OpenStreetMap shelters'**
  String get showOsmShelters;

  /// No description provided for @showOsmSheltersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-identified public buildings (schools, temples, hospitals) on high ground. Unverified.'**
  String get showOsmSheltersSubtitle;

  /// No description provided for @sectionDataStorage.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get sectionDataStorage;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Maps'**
  String get offlineMode;

  /// No description provided for @offlineModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download map tiles for the current district'**
  String get offlineModeSubtitle;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearCacheSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get clearCacheSubtitle;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export checklist and progress'**
  String get exportDataSubtitle;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// No description provided for @clearCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache?'**
  String get clearCacheTitle;

  /// No description provided for @clearCacheBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove cached map tiles and data. You may need to re-download them for offline use.'**
  String get clearCacheBody;

  /// No description provided for @sectionDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get sectionDeveloper;

  /// No description provided for @developerMode.
  ///
  /// In en, this message translates to:
  /// **'Developer mode'**
  String get developerMode;

  /// No description provided for @developerModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show simulate/test controls used for demos and testing.'**
  String get developerModeSubtitle;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @aboutTsunamiSense.
  ///
  /// In en, this message translates to:
  /// **'About TsunamiSense'**
  String get aboutTsunamiSense;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// No description provided for @sectionEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get sectionEmergencyContacts;

  /// No description provided for @contactNationalDisaster.
  ///
  /// In en, this message translates to:
  /// **'National Disaster Management'**
  String get contactNationalDisaster;

  /// No description provided for @contactPolice.
  ///
  /// In en, this message translates to:
  /// **'Police Emergency'**
  String get contactPolice;

  /// No description provided for @contactAmbulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance Service'**
  String get contactAmbulance;

  /// No description provided for @contactFire.
  ///
  /// In en, this message translates to:
  /// **'Fire & Rescue'**
  String get contactFire;

  /// No description provided for @offlineDownloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Download offline maps'**
  String get offlineDownloadTitle;

  /// No description provided for @offlineDownloadBody.
  ///
  /// In en, this message translates to:
  /// **'Map tiles for {district} will be downloaded so the map works with no internet. This may use several megabytes.'**
  String offlineDownloadBody(String district);

  /// No description provided for @offlineDownloadStart.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get offlineDownloadStart;

  /// No description provided for @offlineDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading map tiles…'**
  String get offlineDownloading;

  /// No description provided for @offlineDownloadProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} tiles'**
  String offlineDownloadProgress(int done, int total);

  /// No description provided for @offlineDownloadDone.
  ///
  /// In en, this message translates to:
  /// **'Offline maps ready for {district}'**
  String offlineDownloadDone(String district);

  /// No description provided for @offlineDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download did not finish. Please try again on a better connection.'**
  String get offlineDownloadFailed;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Evacuation Map'**
  String get mapTitle;

  /// No description provided for @mapTapToRoute.
  ///
  /// In en, this message translates to:
  /// **'Tap “My location”, or tap anywhere on the map, to find the safest route to a shelter.'**
  String get mapTapToRoute;

  /// No description provided for @mapToShelter.
  ///
  /// In en, this message translates to:
  /// **'To {shelter}'**
  String mapToShelter(String shelter);

  /// No description provided for @mapNearestShelter.
  ///
  /// In en, this message translates to:
  /// **'nearest shelter'**
  String get mapNearestShelter;

  /// No description provided for @mapOsmUnverified.
  ///
  /// In en, this message translates to:
  /// **'OpenStreetMap shelters are auto-identified and unverified.'**
  String get mapOsmUnverified;

  /// No description provided for @mapRouteStrategySafest.
  ///
  /// In en, this message translates to:
  /// **'Safest'**
  String get mapRouteStrategySafest;

  /// No description provided for @mapRouteStrategyBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get mapRouteStrategyBalanced;

  /// No description provided for @mapRouteStrategyShortest.
  ///
  /// In en, this message translates to:
  /// **'Fastest'**
  String get mapRouteStrategyShortest;

  /// No description provided for @mapLegendSafeRoad.
  ///
  /// In en, this message translates to:
  /// **'Safe road'**
  String get mapLegendSafeRoad;

  /// No description provided for @mapLegendFloodRoad.
  ///
  /// In en, this message translates to:
  /// **'Flood-prone road'**
  String get mapLegendFloodRoad;

  /// No description provided for @mapLegendInundation.
  ///
  /// In en, this message translates to:
  /// **'Inundation zone'**
  String get mapLegendInundation;

  /// No description provided for @mapLegendDmc.
  ///
  /// In en, this message translates to:
  /// **'DMC shelter'**
  String get mapLegendDmc;

  /// No description provided for @mapLegendResearch.
  ///
  /// In en, this message translates to:
  /// **'Research shelter'**
  String get mapLegendResearch;

  /// No description provided for @mapLegendOsm.
  ///
  /// In en, this message translates to:
  /// **'OSM shelter'**
  String get mapLegendOsm;

  /// No description provided for @mapLegendYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get mapLegendYou;

  /// No description provided for @mapLayers.
  ///
  /// In en, this message translates to:
  /// **'Map layers'**
  String get mapLayers;

  /// No description provided for @mapLayerRoads.
  ///
  /// In en, this message translates to:
  /// **'Road safety'**
  String get mapLayerRoads;

  /// No description provided for @mapLayerInundation.
  ///
  /// In en, this message translates to:
  /// **'Inundation zone'**
  String get mapLayerInundation;

  /// No description provided for @mapLayerShelters.
  ///
  /// In en, this message translates to:
  /// **'Shelters'**
  String get mapLayerShelters;

  /// No description provided for @mapSwitchDistrict.
  ///
  /// In en, this message translates to:
  /// **'Switch district'**
  String get mapSwitchDistrict;

  /// No description provided for @mapMapOnly.
  ///
  /// In en, this message translates to:
  /// **'Map only'**
  String get mapMapOnly;

  /// No description provided for @districtGalle.
  ///
  /// In en, this message translates to:
  /// **'Galle'**
  String get districtGalle;

  /// No description provided for @districtMatara.
  ///
  /// In en, this message translates to:
  /// **'Matara'**
  String get districtMatara;

  /// No description provided for @districtTangalle.
  ///
  /// In en, this message translates to:
  /// **'Tangalle'**
  String get districtTangalle;

  /// No description provided for @mapMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'~{minutes} min'**
  String mapMinutesShort(int minutes);

  /// No description provided for @mapPctSafe.
  ///
  /// In en, this message translates to:
  /// **'{pct}% safe'**
  String mapPctSafe(int pct);

  /// No description provided for @mapPctRisky.
  ///
  /// In en, this message translates to:
  /// **'{pct}% • {n} risky'**
  String mapPctRisky(int pct, int n);

  /// No description provided for @mapRouteHeading.
  ///
  /// In en, this message translates to:
  /// **'{strategy} route'**
  String mapRouteHeading(String strategy);

  /// No description provided for @mapDistrictTitle.
  ///
  /// In en, this message translates to:
  /// **'{district} Map'**
  String mapDistrictTitle(String district);

  /// No description provided for @mapLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading evacuation map…'**
  String get mapLoading;

  /// No description provided for @mapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Map unavailable.'**
  String get mapUnavailable;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is off. Enable it in Settings, or tap the map to set a start point.'**
  String get locationPermissionDenied;

  /// No description provided for @locationServicesOff.
  ///
  /// In en, this message translates to:
  /// **'Location services are off. Turn on GPS, or tap the map to set a start point.'**
  String get locationServicesOff;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not get a location fix. Tap the map to set a start point.'**
  String get locationUnavailable;

  /// No description provided for @locationPermissionDeniedEmergency.
  ///
  /// In en, this message translates to:
  /// **'Location permission is off. Enable it in Settings to get your evacuation route, or tap the map.'**
  String get locationPermissionDeniedEmergency;

  /// No description provided for @locationServicesOffEmergency.
  ///
  /// In en, this message translates to:
  /// **'Location services are off. Turn on GPS to get your evacuation route, or tap the map.'**
  String get locationServicesOffEmergency;

  /// No description provided for @emergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'TSUNAMI WARNING'**
  String get emergencyTitle;

  /// No description provided for @emergencyEvacuateNow.
  ///
  /// In en, this message translates to:
  /// **'Evacuate now'**
  String get emergencyEvacuateNow;

  /// No description provided for @emergencyLocating.
  ///
  /// In en, this message translates to:
  /// **'Locating you…'**
  String get emergencyLocating;

  /// No description provided for @emergencyWaveArrivesIn.
  ///
  /// In en, this message translates to:
  /// **'Wave arrives in'**
  String get emergencyWaveArrivesIn;

  /// No description provided for @emergencyMoveInland.
  ///
  /// In en, this message translates to:
  /// **'Move inland and uphill, away from the coast.'**
  String get emergencyMoveInland;

  /// No description provided for @emergencyArrivalEstimate.
  ///
  /// In en, this message translates to:
  /// **'Wave in ~{minutes} min'**
  String emergencyArrivalEstimate(int minutes);

  /// No description provided for @emergencyDemoModel.
  ///
  /// In en, this message translates to:
  /// **'Estimated • demonstration model'**
  String get emergencyDemoModel;

  /// No description provided for @emergencyEndDrill.
  ///
  /// In en, this message translates to:
  /// **'End drill'**
  String get emergencyEndDrill;

  /// No description provided for @emergencyFollowRoute.
  ///
  /// In en, this message translates to:
  /// **'Follow the route to {shelter}; move inland and uphill.'**
  String emergencyFollowRoute(String shelter);

  /// No description provided for @emergencyMayNotReach.
  ///
  /// In en, this message translates to:
  /// **'You may not reach {shelter} in time. Move inland and uphill to the nearest high ground now.'**
  String emergencyMayNotReach(String shelter);

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get commonReset;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @learnCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} completed'**
  String learnCompletedCount(int done, int total);

  /// No description provided for @learnNoLessons.
  ///
  /// In en, this message translates to:
  /// **'No lessons available'**
  String get learnNoLessons;

  /// No description provided for @learnLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get learnLessons;

  /// No description provided for @learnProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Learning Progress'**
  String get learnProgressTitle;

  /// No description provided for @learnPercentComplete.
  ///
  /// In en, this message translates to:
  /// **'{pct}% Complete'**
  String learnPercentComplete(int pct);

  /// No description provided for @learnStartPrompt.
  ///
  /// In en, this message translates to:
  /// **'Start your first lesson to learn how to stay safe!'**
  String get learnStartPrompt;

  /// No description provided for @learnKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going! You are doing great!'**
  String get learnKeepGoing;

  /// No description provided for @learnAllDone.
  ///
  /// In en, this message translates to:
  /// **'All lessons completed! You are well prepared.'**
  String get learnAllDone;

  /// No description provided for @learnMinutes.
  ///
  /// In en, this message translates to:
  /// **'{min} min'**
  String learnMinutes(int min);

  /// No description provided for @learnMinRead.
  ///
  /// In en, this message translates to:
  /// **'{min} min read'**
  String learnMinRead(int min);

  /// No description provided for @learnQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get learnQuiz;

  /// No description provided for @learnLessonNumber.
  ///
  /// In en, this message translates to:
  /// **'Lesson {n}'**
  String learnLessonNumber(int n);

  /// No description provided for @learnTakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Take Quiz'**
  String get learnTakeQuiz;

  /// No description provided for @learnCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed ✓'**
  String get learnCompleted;

  /// No description provided for @learnMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get learnMarkComplete;

  /// No description provided for @learnQuestionOf.
  ///
  /// In en, this message translates to:
  /// **'Question {n} of {total}'**
  String learnQuestionOf(int n, int total);

  /// No description provided for @learnSeeResults.
  ///
  /// In en, this message translates to:
  /// **'See Results'**
  String get learnSeeResults;

  /// No description provided for @learnGreatJob.
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get learnGreatJob;

  /// No description provided for @learnKeepLearning.
  ///
  /// In en, this message translates to:
  /// **'Keep Learning'**
  String get learnKeepLearning;

  /// No description provided for @learnScore.
  ///
  /// In en, this message translates to:
  /// **'You got {correct} out of {total} correct ({pct}%)'**
  String learnScore(int correct, int total, int pct);

  /// No description provided for @learnCompleteLesson.
  ///
  /// In en, this message translates to:
  /// **'Complete Lesson'**
  String get learnCompleteLesson;

  /// No description provided for @learnReviewLesson.
  ///
  /// In en, this message translates to:
  /// **'Review Lesson'**
  String get learnReviewLesson;

  /// No description provided for @learnLessonDoneToast.
  ///
  /// In en, this message translates to:
  /// **'Lesson completed!'**
  String get learnLessonDoneToast;

  /// No description provided for @prepareTitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare'**
  String get prepareTitle;

  /// No description provided for @prepareResetTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reset checklist'**
  String get prepareResetTooltip;

  /// No description provided for @prepareShareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share checklist'**
  String get prepareShareTooltip;

  /// No description provided for @prepareAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get prepareAddItem;

  /// No description provided for @prepareResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Checklist?'**
  String get prepareResetTitle;

  /// No description provided for @prepareResetBody.
  ///
  /// In en, this message translates to:
  /// **'This will uncheck all items. Your notes will be preserved.'**
  String get prepareResetBody;

  /// No description provided for @prepareResetDone.
  ///
  /// In en, this message translates to:
  /// **'Checklist reset'**
  String get prepareResetDone;

  /// No description provided for @prepareAddCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Item'**
  String get prepareAddCustomTitle;

  /// No description provided for @prepareCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get prepareCategory;

  /// No description provided for @prepareItemName.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get prepareItemName;

  /// No description provided for @prepareItemAdded.
  ///
  /// In en, this message translates to:
  /// **'Item added'**
  String get prepareItemAdded;

  /// No description provided for @prepareFullyPrepared.
  ///
  /// In en, this message translates to:
  /// **'🎉 Fully Prepared!'**
  String get prepareFullyPrepared;

  /// No description provided for @preparePreparednessLevel.
  ///
  /// In en, this message translates to:
  /// **'Preparedness Level'**
  String get preparePreparednessLevel;

  /// No description provided for @prepareCompleteMsg.
  ///
  /// In en, this message translates to:
  /// **'Great job! You have everything ready for an emergency.'**
  String get prepareCompleteMsg;

  /// No description provided for @prepareIncompleteMsg.
  ///
  /// In en, this message translates to:
  /// **'Complete the checklist to ensure you are ready for emergencies.'**
  String get prepareIncompleteMsg;

  /// No description provided for @prepareItemsComplete.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} complete'**
  String prepareItemsComplete(int done, int total);

  /// No description provided for @prepareRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get prepareRequired;

  /// No description provided for @prepareNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get prepareNoteTitle;

  /// No description provided for @prepareNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Add a note (e.g., location, expiry date)'**
  String get prepareNoteHint;

  /// No description provided for @prepareTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparation Tips'**
  String get prepareTipsTitle;

  /// No description provided for @prepareTip1Title.
  ///
  /// In en, this message translates to:
  /// **'Regular Updates'**
  String get prepareTip1Title;

  /// No description provided for @prepareTip1Body.
  ///
  /// In en, this message translates to:
  /// **'Review and update your emergency kit every 6 months.'**
  String get prepareTip1Body;

  /// No description provided for @prepareTip2Title.
  ///
  /// In en, this message translates to:
  /// **'Water Storage'**
  String get prepareTip2Title;

  /// No description provided for @prepareTip2Body.
  ///
  /// In en, this message translates to:
  /// **'Store 3 litres of water per person per day for at least 3 days.'**
  String get prepareTip2Body;

  /// No description provided for @prepareTip3Title.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get prepareTip3Title;

  /// No description provided for @prepareTip3Body.
  ///
  /// In en, this message translates to:
  /// **'Keep a written list of emergency contacts in your kit.'**
  String get prepareTip3Body;

  /// No description provided for @prepareTip4Title.
  ///
  /// In en, this message translates to:
  /// **'Family Plan'**
  String get prepareTip4Title;

  /// No description provided for @prepareTip4Body.
  ///
  /// In en, this message translates to:
  /// **'Discuss and practice evacuation routes with your family.'**
  String get prepareTip4Body;

  /// No description provided for @prepareTip5Title.
  ///
  /// In en, this message translates to:
  /// **'Meeting Point'**
  String get prepareTip5Title;

  /// No description provided for @prepareTip5Body.
  ///
  /// In en, this message translates to:
  /// **'Designate a meeting point in case family members are separated.'**
  String get prepareTip5Body;

  /// No description provided for @mapTsunamiWarning.
  ///
  /// In en, this message translates to:
  /// **'TSUNAMI WARNING'**
  String get mapTsunamiWarning;

  /// No description provided for @mapOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'Offline, saved map'**
  String get mapOfflineBanner;

  /// No description provided for @mapEvacuationMap.
  ///
  /// In en, this message translates to:
  /// **'Evacuation Map'**
  String get mapEvacuationMap;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @locationApproximate.
  ///
  /// In en, this message translates to:
  /// **'Using your last known location; it may be approximate.'**
  String get locationApproximate;

  /// No description provided for @earthquakeViewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get earthquakeViewOnMap;

  /// No description provided for @earthquakeUsgsDetails.
  ///
  /// In en, this message translates to:
  /// **'USGS Details'**
  String get earthquakeUsgsDetails;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfService;

  /// No description provided for @mapDataStale.
  ///
  /// In en, this message translates to:
  /// **'Hazard data may be out of date. Connect to refresh.'**
  String get mapDataStale;

  /// No description provided for @mapDataAgeDays.
  ///
  /// In en, this message translates to:
  /// **'Data updated {days} days ago'**
  String mapDataAgeDays(int days);

  /// No description provided for @mapDataNeverUpdated.
  ///
  /// In en, this message translates to:
  /// **'Using data bundled with the app'**
  String get mapDataNeverUpdated;

  /// No description provided for @a11yRouteSummary.
  ///
  /// In en, this message translates to:
  /// **'Evacuation route to {shelter}. {distance} metres, about {minutes} minutes walk. {unsafe} risky road segments.'**
  String a11yRouteSummary(
    String shelter,
    int distance,
    int minutes,
    int unsafe,
  );

  /// No description provided for @a11yMapLabel.
  ///
  /// In en, this message translates to:
  /// **'Evacuation map of {district}. Shows classified roads, the inundation zone and shelters.'**
  String a11yMapLabel(String district);

  /// No description provided for @a11yMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Find my location and route to the nearest shelter'**
  String get a11yMyLocation;

  /// No description provided for @a11yResetNorth.
  ///
  /// In en, this message translates to:
  /// **'Reset map orientation to north'**
  String get a11yResetNorth;

  /// No description provided for @a11yClearRoute.
  ///
  /// In en, this message translates to:
  /// **'Clear the current route'**
  String get a11yClearRoute;

  /// No description provided for @a11yLegend.
  ///
  /// In en, this message translates to:
  /// **'Map legend'**
  String get a11yLegend;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
