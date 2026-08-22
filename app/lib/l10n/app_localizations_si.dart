// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sinhala Sinhalese (`si`).
class AppLocalizationsSi extends AppLocalizations {
  AppLocalizationsSi([String locale = 'si']) : super(locale);

  @override
  String get poweredByGetra => 'GETRA මගින් බලගැන්වේ';

  @override
  String get navHome => 'මුල් පිටුව';

  @override
  String get navLearn => 'ඉගෙනුම';

  @override
  String get navMap => 'සිතියම';

  @override
  String get navPrepare => 'සූදානම';

  @override
  String get navSettings => 'සැකසුම්';

  @override
  String get commonClose => 'වසන්න';

  @override
  String get commonCancel => 'අවලංගු කරන්න';

  @override
  String get commonClear => 'හිස් කරන්න';

  @override
  String get commonOk => 'හරි';

  @override
  String get commonRetry => 'නැවත උත්සාහ කරන්න';

  @override
  String get homeCurrentStatus => 'වත්මන් තත්ත්වය';

  @override
  String homeLastUpdated(String time) {
    return 'අවසන් යාවත්කාලීනය: $time';
  }

  @override
  String get homeJustNow => 'මේ දැන්';

  @override
  String homeMinutesAgo(int m) {
    return 'මිනිත්තු $mකට පෙර';
  }

  @override
  String homeHoursAgo(int h) {
    return 'පැය $hකට පෙර';
  }

  @override
  String get homeQuickActions => 'ඉක්මන් ක්‍රියා';

  @override
  String get homeFindSafeZone => 'ආරක්ෂිත කලාපය සොයන්න';

  @override
  String get homeBePrepared => 'සූදානම් වන්න';

  @override
  String get homeRecentSeismic => 'මෑත භූ කම්පන ක්‍රියාකාරකම්';

  @override
  String get homeNoEarthquakes => 'සැලකිය යුතු භූමිකම්පා හඳුනා නොගැනිණි';

  @override
  String get homeYourProgress => 'ඔබේ ප්‍රගතිය';

  @override
  String get homeLessons => 'පාඩම්';

  @override
  String get homePrepared => 'සූදානම';

  @override
  String homeDepthKm(int km) {
    return 'ගැඹුර: කි.මී. $km';
  }

  @override
  String get alertNoThreat => 'තර්ජනයක් නැත';

  @override
  String get alertAdvisory => 'උපදේශනය';

  @override
  String get alertWarning => 'අනතුරු ඇඟවීම';

  @override
  String get alertEmergency => 'හදිසි අවස්ථාව';

  @override
  String get alertNoThreatDesc =>
      'සුනාමි තර්ජනයක් හඳුනා නොගැනිණි. දැනුවත්ව සහ සූදානමින් සිටින්න.';

  @override
  String get alertAdvisoryDesc =>
      'භූමිකම්පාවක් හඳුනාගැනිණි. සූදානම්ව යාවත්කාලීන නිරීක්ෂණය කරන්න.';

  @override
  String get alertWarningDesc =>
      'සුනාමියක් සිදුවිය හැක. වෙරළට ආසන්න නම් ඉවත් වීමට සූදානම් වන්න.';

  @override
  String get alertEmergencyDesc =>
      'සුනාමිය තහවුරුයි. වහාම උස් බිමකට ඉවත් වන්න!';

  @override
  String get settingsTitle => 'සැකසුම්';

  @override
  String get sectionNotifications => 'දැනුම්දීම්';

  @override
  String get enableNotifications => 'දැනුම්දීම් සක්‍රීය කරන්න';

  @override
  String get enableNotificationsSubtitle =>
      'භූමිකම්පා සහ සුනාමි අනතුරු ඇඟවීම් ලබා ගන්න';

  @override
  String get soundLabel => 'ශබ්දය';

  @override
  String get soundSubtitle => 'දැනුම්දීම් සඳහා අනතුරු ඇඟවීමේ ශබ්දය වාදනය කරන්න';

  @override
  String get vibrationLabel => 'කම්පනය';

  @override
  String get vibrationSubtitle => 'දැනුම්දීම් සඳහා කම්පනය කරන්න';

  @override
  String get sectionAlertSettings => 'අනතුරු ඇඟවීම් සැකසුම්';

  @override
  String get alertRadius => 'අනතුරු ඇඟවීමේ පරාසය';

  @override
  String alertRadiusValue(int km) {
    return 'ශ්‍රී ලංකා වෙරළ තීරයේ සිට කි.මී. $km';
  }

  @override
  String get showAllEarthquakes => 'සියලු භූමිකම්පා පෙන්වන්න';

  @override
  String get showAllEarthquakesSubtitle =>
      'M5.0 ට අඩු භූමිකම්පා ද ඇතුළත් කරන්න';

  @override
  String get testAlert => 'පරීක්ෂණ අනතුරු ඇඟවීම';

  @override
  String get testAlertSubtitle => 'පරීක්ෂණ දැනුම්දීමක් යවන්න';

  @override
  String get testNotificationSent => 'පරීක්ෂණ දැනුම්දීම යවන ලදී';

  @override
  String get sectionDisplay => 'සංදර්ශනය';

  @override
  String get language => 'භාෂාව';

  @override
  String get selectLanguage => 'භාෂාව තෝරන්න';

  @override
  String get darkMode => 'අඳුරු තේමාව';

  @override
  String get darkModeSubtitle => 'අඳුරු තේමාව භාවිතා කරන්න';

  @override
  String get sectionEvacuationMap => 'ඉවත් වීමේ සිතියම';

  @override
  String get showResearchShelters => 'පර්යේෂණ-සහාය නවාතැන් පෙන්වන්න';

  @override
  String get showResearchSheltersSubtitle =>
      'ප්‍රකාශිත පර්යේෂණවල හඳුනාගත් අවසන් විකල්ප නවාතැන් ද පෙන්වන්න. DMC-තහවුරු කළ නවාතැන් සැමවිටම පෙන්වයි.';

  @override
  String get showOsmShelters => 'OpenStreetMap නවාතැන් පෙන්වන්න';

  @override
  String get showOsmSheltersSubtitle =>
      'උස් බිමෙහි ස්වයංක්‍රීයව හඳුනාගත් පොදු ගොඩනැගිලි (පාසල්, විහාර, රෝහල්). තහවුරු නොකළ.';

  @override
  String get sectionDataStorage => 'දත්ත සහ ගබඩාව';

  @override
  String get offlineMode => 'නොබැඳි සිතියම්';

  @override
  String get offlineModeSubtitle =>
      'වත්මන් දිස්ත්‍රික්කය සඳහා සිතියම් ටයිල් බාගන්න';

  @override
  String get clearCache => 'හැඹිලිය හිස් කරන්න';

  @override
  String get clearCacheSubtitle => 'ගබඩා ඉඩ නිදහස් කරන්න';

  @override
  String get exportData => 'දත්ත නිර්යාත කරන්න';

  @override
  String get exportDataSubtitle =>
      'පිරික්සුම් ලැයිස්තුව සහ ප්‍රගතිය නිර්යාත කරන්න';

  @override
  String get cacheCleared => 'හැඹිලිය සාර්ථකව හිස් කරන ලදී';

  @override
  String get clearCacheTitle => 'හැඹිලිය හිස් කරන්නද?';

  @override
  String get clearCacheBody =>
      'මෙය හැඹිලිගත සිතියම් ටයිල් සහ දත්ත ඉවත් කරයි. නොබැඳිව භාවිතයට ඒවා නැවත බාගත කිරීමට අවශ්‍ය විය හැක.';

  @override
  String get sectionDeveloper => 'සංවර්ධක';

  @override
  String get developerMode => 'සංවර්ධක ප්‍රකාරය';

  @override
  String get developerModeSubtitle =>
      'ආදර්ශන සහ පරීක්ෂණ සඳහා භාවිතා කරන අනුකරණ/පරීක්ෂණ පාලන පෙන්වන්න.';

  @override
  String get sectionAbout => 'පිළිබඳව';

  @override
  String get aboutTsunamiSense => 'TsunamiSense පිළිබඳව';

  @override
  String get privacyPolicy => 'පෞද්ගලිකත්ව ප්‍රතිපත්තිය';

  @override
  String get termsOfService => 'සේවා කොන්දේසි';

  @override
  String get openSourceLicenses => 'විවෘත මූලාශ්‍ර බලපත්‍ර';

  @override
  String get sectionEmergencyContacts => 'හදිසි ඇමතුම්';

  @override
  String get contactNationalDisaster => 'ජාතික ආපදා කළමනාකරණය';

  @override
  String get contactPolice => 'පොලිස් හදිසි අංශය';

  @override
  String get contactAmbulance => 'ගිලන්රථ සේවාව';

  @override
  String get contactFire => 'ගිනි නිවීම් හා ගලවා ගැනීම්';

  @override
  String get offlineDownloadTitle => 'නොබැඳි සිතියම් බාගන්න';

  @override
  String offlineDownloadBody(String district) {
    return 'අන්තර්ජාලය නොමැතිව සිතියම ක්‍රියා කිරීමට $district සඳහා සිතියම් ටයිල් බාගනු ලැබේ. මෙය මෙගාබයිට් කිහිපයක් භාවිතා කළ හැක.';
  }

  @override
  String get offlineDownloadStart => 'බාගන්න';

  @override
  String get offlineDownloading => 'සිතියම් ටයිල් බාගනිමින්…';

  @override
  String offlineDownloadProgress(int done, int total) {
    return 'ටයිල් $total කින් $done';
  }

  @override
  String offlineDownloadDone(String district) {
    return '$district සඳහා නොබැඳි සිතියම් සූදානම්';
  }

  @override
  String get offlineDownloadFailed =>
      'බාගැනීම සම්පූර්ණ නොවීය. වඩා හොඳ සම්බන්ධතාවයකින් නැවත උත්සාහ කරන්න.';

  @override
  String get mapTitle => 'ඉවත් වීමේ සිතියම';

  @override
  String get mapTapToRoute =>
      'නවාතැනකට ආරක්ෂිතම මාර්ගය සොයා ගැනීමට “මගේ ස්ථානය” තට්ටු කරන්න, නැතහොත් සිතියමේ ඕනෑම තැනක තට්ටු කරන්න.';

  @override
  String mapToShelter(String shelter) {
    return '$shelter වෙත';
  }

  @override
  String get mapNearestShelter => 'ආසන්නම නවාතැන';

  @override
  String get mapOsmUnverified =>
      'OpenStreetMap නවාතැන් ස්වයංක්‍රීයව හඳුනාගත් සහ තහවුරු නොකළ ඒවාය.';

  @override
  String get mapRouteStrategySafest => 'ආරක්ෂිතම';

  @override
  String get mapRouteStrategyBalanced => 'සමබර';

  @override
  String get mapRouteStrategyShortest => 'වේගවත්ම';

  @override
  String get mapLegendSafeRoad => 'ආරක්ෂිත මාර්ගය';

  @override
  String get mapLegendFloodRoad => 'ගංවතුරට ලක්විය හැකි මාර්ගය';

  @override
  String get mapLegendInundation => 'යටවීමේ කලාපය';

  @override
  String get mapLegendDmc => 'DMC නවාතැන';

  @override
  String get mapLegendResearch => 'පර්යේෂණ නවාතැන';

  @override
  String get mapLegendOsm => 'OSM නවාතැන';

  @override
  String get mapLegendYou => 'ඔබ';

  @override
  String get mapLayers => 'සිතියම් ස්තර';

  @override
  String get mapLayerRoads => 'මාර්ග ආරක්ෂාව';

  @override
  String get mapLayerInundation => 'යටවීමේ කලාපය';

  @override
  String get mapLayerShelters => 'නවාතැන්';

  @override
  String get mapSwitchDistrict => 'දිස්ත්‍රික්කය මාරු කරන්න';

  @override
  String get mapMapOnly => 'සිතියම පමණයි';

  @override
  String get districtGalle => 'ගාල්ල';

  @override
  String get districtMatara => 'මාතර';

  @override
  String get districtTangalle => 'තංගල්ල';

  @override
  String mapMinutesShort(int minutes) {
    return '~මිනිත්තු $minutes';
  }

  @override
  String mapPctSafe(int pct) {
    return '$pct% ආරක්ෂිතයි';
  }

  @override
  String mapPctRisky(int pct, int n) {
    return '$pct% • අවදානම් $n';
  }

  @override
  String mapRouteHeading(String strategy) {
    return '$strategy මාර්ගය';
  }

  @override
  String mapDistrictTitle(String district) {
    return '$district සිතියම';
  }

  @override
  String get mapLoading => 'ඉවත් වීමේ සිතියම පූරණය වෙමින්…';

  @override
  String get mapUnavailable => 'සිතියම නොමැත.';

  @override
  String get locationPermissionDenied =>
      'ස්ථාන අවසරය ක්‍රියා විරහිතයි. සැකසුම් තුළ එය සක්‍රීය කරන්න, නැතහොත් ආරම්භක ස්ථානයක් සැකසීමට සිතියම තට්ටු කරන්න.';

  @override
  String get locationServicesOff =>
      'ස්ථාන සේවා ක්‍රියා විරහිතයි. GPS සක්‍රීය කරන්න, නැතහොත් ආරම්භක ස්ථානයක් සැකසීමට සිතියම තට්ටු කරන්න.';

  @override
  String get locationUnavailable =>
      'ස්ථානය ලබා ගත නොහැකි විය. ආරම්භක ස්ථානයක් සැකසීමට සිතියම තට්ටු කරන්න.';

  @override
  String get locationPermissionDeniedEmergency =>
      'ස්ථාන අවසරය ක්‍රියා විරහිතයි. ඔබේ ඉවත් වීමේ මාර්ගය ලබා ගැනීමට සැකසුම් තුළ එය සක්‍රීය කරන්න, නැතහොත් සිතියම තට්ටු කරන්න.';

  @override
  String get locationServicesOffEmergency =>
      'ස්ථාන සේවා ක්‍රියා විරහිතයි. ඔබේ ඉවත් වීමේ මාර්ගය ලබා ගැනීමට GPS සක්‍රීය කරන්න, නැතහොත් සිතියම තට්ටු කරන්න.';

  @override
  String get emergencyTitle => 'සුනාමි අනතුරු ඇඟවීම';

  @override
  String get emergencyEvacuateNow => 'දැන්ම ඉවත් වන්න';

  @override
  String get emergencyLocating => 'ඔබව සොයමින්…';

  @override
  String get emergencyWaveArrivesIn => 'තරංගය පැමිණෙන්නේ';

  @override
  String get emergencyMoveInland =>
      'වෙරළෙන් ඈතට, අභ්‍යන්තරයට හා උස් බිමට යන්න.';

  @override
  String emergencyArrivalEstimate(int minutes) {
    return 'තරංගය ~මිනිත්තු $minutes කින්';
  }

  @override
  String get emergencyDemoModel => 'ඇස්තමේන්තුගත • ආදර්ශන ආකෘතිය';

  @override
  String get emergencyEndDrill => 'පුහුණුව අවසන් කරන්න';

  @override
  String emergencyFollowRoute(String shelter) {
    return '$shelter වෙත මාර්ගය අනුගමනය කරන්න; අභ්‍යන්තරයට හා උස් බිමට යන්න.';
  }

  @override
  String emergencyMayNotReach(String shelter) {
    return 'ඔබට $shelter වෙත කාලයට ළඟා විය නොහැකි විය හැක. දැන්ම ආසන්නම උස් බිමට, අභ්‍යන්තරයට යන්න.';
  }

  @override
  String get commonNext => 'ඊළඟ';

  @override
  String get commonAdd => 'එක් කරන්න';

  @override
  String get commonReset => 'යළි සකසන්න';

  @override
  String get commonRemove => 'ඉවත් කරන්න';

  @override
  String get commonSave => 'සුරකින්න';

  @override
  String learnCompletedCount(int done, int total) {
    return '$totalකින් $done සම්පූර්ණයි';
  }

  @override
  String get learnNoLessons => 'පාඩම් නොමැත';

  @override
  String get learnLessons => 'පාඩම්';

  @override
  String get learnProgressTitle => 'ඔබේ ඉගෙනුම් ප්‍රගතිය';

  @override
  String learnPercentComplete(int pct) {
    return '$pct% සම්පූර්ණයි';
  }

  @override
  String get learnStartPrompt =>
      'ආරක්ෂිතව සිටින ආකාරය ඉගෙන ගැනීමට ඔබේ පළමු පාඩම ආරම්භ කරන්න!';

  @override
  String get learnKeepGoing => 'දිගටම කරගෙන යන්න! ඔබ හොඳින් කරනවා!';

  @override
  String get learnAllDone => 'සියලු පාඩම් සම්පූර්ණයි! ඔබ හොඳින් සූදානම්.';

  @override
  String learnMinutes(int min) {
    return 'මිනිත්තු $min';
  }

  @override
  String learnMinRead(int min) {
    return 'කියවීමට මිනිත්තු $min';
  }

  @override
  String get learnQuiz => 'ප්‍රශ්නාවලිය';

  @override
  String learnLessonNumber(int n) {
    return 'පාඩම $n';
  }

  @override
  String get learnTakeQuiz => 'ප්‍රශ්නාවලියට පිළිතුරු දෙන්න';

  @override
  String get learnCompleted => 'සම්පූර්ණයි ✓';

  @override
  String get learnMarkComplete => 'සම්පූර්ණ ලෙස සලකුණු කරන්න';

  @override
  String learnQuestionOf(int n, int total) {
    return 'ප්‍රශ්න $totalකින් $n';
  }

  @override
  String get learnSeeResults => 'ප්‍රතිඵල බලන්න';

  @override
  String get learnGreatJob => 'හොඳ වැඩක්!';

  @override
  String get learnKeepLearning => 'දිගටම ඉගෙන ගන්න';

  @override
  String learnScore(int correct, int total, int pct) {
    return 'ඔබ $totalකින් $correctක් නිවැරදිව ලබා ගත්තා ($pct%)';
  }

  @override
  String get learnCompleteLesson => 'පාඩම සම්පූර්ණ කරන්න';

  @override
  String get learnReviewLesson => 'පාඩම නැවත බලන්න';

  @override
  String get learnLessonDoneToast => 'පාඩම සම්පූර්ණයි!';

  @override
  String get prepareTitle => 'සූදානම් වන්න';

  @override
  String get prepareResetTooltip => 'පිරික්සුම් ලැයිස්තුව යළි සකසන්න';

  @override
  String get prepareShareTooltip => 'පිරික්සුම් ලැයිස්තුව බෙදා ගන්න';

  @override
  String get prepareAddItem => 'අයිතමයක් එක් කරන්න';

  @override
  String get prepareResetTitle => 'පිරික්සුම් ලැයිස්තුව යළි සකසන්නද?';

  @override
  String get prepareResetBody =>
      'මෙය සියලු අයිතම ඉවත් කරයි. ඔබේ සටහන් රැකෙනු ඇත.';

  @override
  String get prepareResetDone => 'පිරික්සුම් ලැයිස්තුව යළි සකසන ලදී';

  @override
  String get prepareAddCustomTitle => 'අභිරුචි අයිතමයක් එක් කරන්න';

  @override
  String get prepareCategory => 'කාණ්ඩය';

  @override
  String get prepareItemName => 'අයිතමයේ නම';

  @override
  String get prepareItemAdded => 'අයිතමය එක් කරන ලදී';

  @override
  String get prepareFullyPrepared => '🎉 සම්පූර්ණයෙන් සූදානම්!';

  @override
  String get preparePreparednessLevel => 'සූදානම් මට්ටම';

  @override
  String get prepareCompleteMsg =>
      'හොඳ වැඩක්! හදිසි අවස්ථාවකට ඔබට අවශ්‍ය සියල්ල සූදානම්.';

  @override
  String get prepareIncompleteMsg =>
      'හදිසි අවස්ථා සඳහා සූදානම් වීමට පිරික්සුම් ලැයිස්තුව සම්පූර්ණ කරන්න.';

  @override
  String prepareItemsComplete(int done, int total) {
    return '$totalකින් $done සම්පූර්ණයි';
  }

  @override
  String get prepareRequired => 'අවශ්‍යයි';

  @override
  String get prepareNoteTitle => 'සටහනක් එක් කරන්න';

  @override
  String get prepareNoteHint =>
      'සටහනක් එක් කරන්න (උදා: ස්ථානය, කල් ඉකුත් වන දිනය)';

  @override
  String get prepareTipsTitle => 'සූදානම් වීමේ ඉඟි';

  @override
  String get prepareTip1Title => 'නිතිපතා යාවත්කාලීන';

  @override
  String get prepareTip1Body =>
      'සෑම මාස 6කට වරක් ඔබේ හදිසි කට්ටලය සමාලෝචනය කර යාවත්කාලීන කරන්න.';

  @override
  String get prepareTip2Title => 'ජල ගබඩාව';

  @override
  String get prepareTip2Body =>
      'අවම වශයෙන් දින 3කට පුද්ගලයෙකුට දිනකට ජලය ලීටර් 3ක් ගබඩා කරන්න.';

  @override
  String get prepareTip3Title => 'හදිසි ඇමතුම්';

  @override
  String get prepareTip3Body =>
      'ඔබේ කට්ටලයේ හදිසි ඇමතුම්වල ලිඛිත ලැයිස්තුවක් තබා ගන්න.';

  @override
  String get prepareTip4Title => 'පවුල් සැලැස්ම';

  @override
  String get prepareTip4Body =>
      'ඔබේ පවුල සමඟ ඉවත් වීමේ මාර්ග සාකච්ඡා කර පුහුණු වන්න.';

  @override
  String get prepareTip5Title => 'හමුවන ස්ථානය';

  @override
  String get prepareTip5Body =>
      'පවුලේ අය වෙන් වුවහොත් හමුවන ස්ථානයක් නියම කරන්න.';

  @override
  String get mapTsunamiWarning => 'සුනාමි අනතුරු ඇඟවීම';

  @override
  String get mapOfflineBanner => 'නොබැඳි, සුරකින ලද සිතියම';

  @override
  String get mapEvacuationMap => 'ඉවත් වීමේ සිතියම';

  @override
  String get commonTryAgain => 'නැවත උත්සාහ කරන්න';

  @override
  String get openSettings => 'සැකසුම් විවෘත කරන්න';

  @override
  String get locationApproximate =>
      'ඔබේ අවසන් දන්නා ස්ථානය භාවිතා කරයි; එය ආසන්න විය හැක.';

  @override
  String get earthquakeViewOnMap => 'සිතියමේ බලන්න';

  @override
  String get earthquakeUsgsDetails => 'USGS විස්තර';

  @override
  String get settingsPrivacyPolicy => 'රහස්‍යතා ප්‍රතිපත්තිය';

  @override
  String get settingsTermsOfService => 'සේවා කොන්දේසි';

  @override
  String get mapDataStale =>
      'උපද්‍රව දත්ත යල් පැන ගොස් තිබිය හැක. යාවත්කාලීන කිරීමට සම්බන්ධ වන්න.';

  @override
  String mapDataAgeDays(int days) {
    return 'දත්ත දින $daysකට පෙර යාවත්කාලීන කරන ලදී';
  }

  @override
  String get mapDataNeverUpdated => 'යෙදුම සමඟ ලැබුණු දත්ත භාවිතා කරයි';

  @override
  String a11yRouteSummary(
    String shelter,
    int distance,
    int minutes,
    int unsafe,
  ) {
    return '$shelter වෙත ඉවත් වීමේ මාර්ගය. මීටර් $distanceක්, ගමන් කිරීමට ආසන්න වශයෙන් මිනිත්තු $minutesක්. අවදානම් මාර්ග කොටස් $unsafeක්.';
  }

  @override
  String a11yMapLabel(String district) {
    return '$district හි ඉවත් වීමේ සිතියම. වර්ගීකෘත මාර්ග, ගංවතුර කලාපය සහ නවාතැන් පෙන්වයි.';
  }

  @override
  String get a11yMyLocation => 'මගේ ස්ථානය සොයා ආසන්නතම නවාතැනට මාර්ගය ලබාගන්න';

  @override
  String get a11yResetNorth => 'සිතියමේ දිශානතිය උතුරට යළි සකසන්න';

  @override
  String get a11yClearRoute => 'වත්මන් මාර්ගය ඉවත් කරන්න';

  @override
  String get a11yLegend => 'සිතියම් යතුර';
}
