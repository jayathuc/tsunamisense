// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get poweredByGetra => 'GETRA ஆல் இயக்கப்படுகிறது';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navLearn => 'கற்க';

  @override
  String get navMap => 'வரைபடம்';

  @override
  String get navPrepare => 'தயாரி';

  @override
  String get navSettings => 'அமைப்புகள்';

  @override
  String get commonClose => 'மூடு';

  @override
  String get commonCancel => 'ரத்துசெய்';

  @override
  String get commonClear => 'அழி';

  @override
  String get commonOk => 'சரி';

  @override
  String get commonRetry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get homeCurrentStatus => 'தற்போதைய நிலை';

  @override
  String homeLastUpdated(String time) {
    return 'கடைசியாக புதுப்பிக்கப்பட்டது: $time';
  }

  @override
  String get homeJustNow => 'இப்போது';

  @override
  String homeMinutesAgo(int m) {
    return '$m நிமிடங்களுக்கு முன்';
  }

  @override
  String homeHoursAgo(int h) {
    return '$h மணிநேரத்திற்கு முன்';
  }

  @override
  String get homeQuickActions => 'விரைவு செயல்கள்';

  @override
  String get homeFindSafeZone => 'பாதுகாப்பான மண்டலத்தைக் கண்டறி';

  @override
  String get homeBePrepared => 'தயாராகுங்கள்';

  @override
  String get homeRecentSeismic => 'சமீபத்திய நில அதிர்வு செயல்பாடு';

  @override
  String get homeNoEarthquakes =>
      'குறிப்பிடத்தக்க நிலநடுக்கங்கள் எதுவும் கண்டறியப்படவில்லை';

  @override
  String get homeYourProgress => 'உங்கள் முன்னேற்றம்';

  @override
  String get homeLessons => 'பாடங்கள்';

  @override
  String get homePrepared => 'தயார்நிலை';

  @override
  String homeDepthKm(int km) {
    return 'ஆழம்: $km கி.மீ.';
  }

  @override
  String get alertNoThreat => 'அச்சுறுத்தல் இல்லை';

  @override
  String get alertAdvisory => 'ஆலோசனை';

  @override
  String get alertWarning => 'எச்சரிக்கை';

  @override
  String get alertEmergency => 'அவசரநிலை';

  @override
  String get alertNoThreatDesc =>
      'சுனாமி அச்சுறுத்தல் எதுவும் கண்டறியப்படவில்லை. தகவலறிந்து தயாராக இருங்கள்.';

  @override
  String get alertAdvisoryDesc =>
      'நிலநடுக்கம் கண்டறியப்பட்டது. தயாராக இருந்து புதுப்பிப்புகளைக் கண்காணியுங்கள்.';

  @override
  String get alertWarningDesc =>
      'சுனாமி ஏற்படலாம். கடற்கரைக்கு அருகில் இருந்தால் வெளியேற தயாராகுங்கள்.';

  @override
  String get alertEmergencyDesc =>
      'சுனாமி உறுதிப்படுத்தப்பட்டது. உடனடியாக உயரமான இடத்திற்கு வெளியேறுங்கள்!';

  @override
  String get settingsTitle => 'அமைப்புகள்';

  @override
  String get sectionNotifications => 'அறிவிப்புகள்';

  @override
  String get enableNotifications => 'அறிவிப்புகளை இயக்கு';

  @override
  String get enableNotificationsSubtitle =>
      'நிலநடுக்கம் மற்றும் சுனாமி எச்சரிக்கைகளைப் பெறுங்கள்';

  @override
  String get soundLabel => 'ஒலி';

  @override
  String get soundSubtitle => 'அறிவிப்புகளுக்கு எச்சரிக்கை ஒலியை இயக்கு';

  @override
  String get vibrationLabel => 'அதிர்வு';

  @override
  String get vibrationSubtitle => 'அறிவிப்புகளுக்கு அதிர்வு';

  @override
  String get sectionAlertSettings => 'எச்சரிக்கை அமைப்புகள்';

  @override
  String get alertRadius => 'எச்சரிக்கை வரம்பு';

  @override
  String alertRadiusValue(int km) {
    return 'இலங்கை கடற்கரையிலிருந்து $km கி.மீ.';
  }

  @override
  String get showAllEarthquakes => 'அனைத்து நிலநடுக்கங்களையும் காட்டு';

  @override
  String get showAllEarthquakesSubtitle =>
      'M5.0 க்கு கீழ் உள்ள நிலநடுக்கங்களையும் சேர்க்கவும்';

  @override
  String get testAlert => 'சோதனை எச்சரிக்கை';

  @override
  String get testAlertSubtitle => 'சோதனை அறிவிப்பை அனுப்பு';

  @override
  String get testNotificationSent => 'சோதனை அறிவிப்பு அனுப்பப்பட்டது';

  @override
  String get sectionDisplay => 'காட்சி';

  @override
  String get language => 'மொழி';

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get darkMode => 'இருண்ட தீம்';

  @override
  String get darkModeSubtitle => 'இருண்ட தீமை பயன்படுத்து';

  @override
  String get sectionEvacuationMap => 'வெளியேற்ற வரைபடம்';

  @override
  String get showResearchShelters => 'ஆராய்ச்சி ஆதரவு தங்குமிடங்களைக் காட்டு';

  @override
  String get showResearchSheltersSubtitle =>
      'வெளியிடப்பட்ட ஆராய்ச்சியில் அடையாளம் காணப்பட்ட இறுதி தங்குமிடங்களையும் காட்டு. DMC சரிபார்க்கப்பட்ட தங்குமிடங்கள் எப்போதும் காட்டப்படும்.';

  @override
  String get showOsmShelters => 'OpenStreetMap தங்குமிடங்களைக் காட்டு';

  @override
  String get showOsmSheltersSubtitle =>
      'உயரமான இடத்தில் தானாக அடையாளம் காணப்பட்ட பொது கட்டிடங்கள் (பள்ளிகள், கோவில்கள், மருத்துவமனைகள்). சரிபார்க்கப்படவில்லை.';

  @override
  String get sectionDataStorage => 'தரவு மற்றும் சேமிப்பு';

  @override
  String get offlineMode => 'ஆஃப்லைன் வரைபடங்கள்';

  @override
  String get offlineModeSubtitle =>
      'தற்போதைய மாவட்டத்திற்கான வரைபடத் தட்டுகளைப் பதிவிறக்கு';

  @override
  String get clearCache => 'தற்காலிக சேமிப்பை அழி';

  @override
  String get clearCacheSubtitle => 'சேமிப்பு இடத்தை விடுவி';

  @override
  String get exportData => 'தரவை ஏற்றுமதி செய்';

  @override
  String get exportDataSubtitle =>
      'சரிபார்ப்பு பட்டியல் மற்றும் முன்னேற்றத்தை ஏற்றுமதி செய்';

  @override
  String get cacheCleared => 'தற்காலிக சேமிப்பு வெற்றிகரமாக அழிக்கப்பட்டது';

  @override
  String get clearCacheTitle => 'தற்காலிக சேமிப்பை அழிக்கவா?';

  @override
  String get clearCacheBody =>
      'இது தற்காலிகமாக சேமிக்கப்பட்ட வரைபடத் தட்டுகள் மற்றும் தரவை அகற்றும். ஆஃப்லைன் பயன்பாட்டிற்கு அவற்றை மீண்டும் பதிவிறக்க வேண்டியிருக்கலாம்.';

  @override
  String get sectionDeveloper => 'டெவலப்பர்';

  @override
  String get developerMode => 'டெவலப்பர் பயன்முறை';

  @override
  String get developerModeSubtitle =>
      'டெமோ மற்றும் சோதனைக்குப் பயன்படுத்தப்படும் உருவகப்படுத்தல்/சோதனைக் கட்டுப்பாடுகளைக் காட்டு.';

  @override
  String get sectionAbout => 'பற்றி';

  @override
  String get aboutTsunamiSense => 'TsunamiSense பற்றி';

  @override
  String get privacyPolicy => 'தனியுரிமைக் கொள்கை';

  @override
  String get termsOfService => 'சேவை விதிமுறைகள்';

  @override
  String get openSourceLicenses => 'திறந்த மூல உரிமங்கள்';

  @override
  String get sectionEmergencyContacts => 'அவசர தொடர்புகள்';

  @override
  String get contactNationalDisaster => 'தேசிய பேரிடர் மேலாண்மை';

  @override
  String get contactPolice => 'காவல்துறை அவசரம்';

  @override
  String get contactAmbulance => 'ஆம்புலன்ஸ் சேவை';

  @override
  String get contactFire => 'தீயணைப்பு மற்றும் மீட்பு';

  @override
  String get offlineDownloadTitle => 'ஆஃப்லைன் வரைபடங்களைப் பதிவிறக்கு';

  @override
  String offlineDownloadBody(String district) {
    return 'இணையம் இல்லாமல் வரைபடம் செயல்பட $district க்கான வரைபடத் தட்டுகள் பதிவிறக்கம் செய்யப்படும். இது சில மெகாபைட்டுகளைப் பயன்படுத்தலாம்.';
  }

  @override
  String get offlineDownloadStart => 'பதிவிறக்கு';

  @override
  String get offlineDownloading => 'வரைபடத் தட்டுகள் பதிவிறக்கப்படுகிறது…';

  @override
  String offlineDownloadProgress(int done, int total) {
    return '$total தட்டுகளில் $done';
  }

  @override
  String offlineDownloadDone(String district) {
    return '$district க்கான ஆஃப்லைன் வரைபடங்கள் தயார்';
  }

  @override
  String get offlineDownloadFailed =>
      'பதிவிறக்கம் முடியவில்லை. சிறந்த இணைப்பில் மீண்டும் முயற்சிக்கவும்.';

  @override
  String get mapTitle => 'வெளியேற்ற வரைபடம்';

  @override
  String get mapTapToRoute =>
      'தங்குமிடத்திற்கான பாதுகாப்பான பாதையைக் கண்டறிய “எனது இருப்பிடம்” என்பதைத் தட்டவும், அல்லது வரைபடத்தில் எங்கு வேண்டுமானாலும் தட்டவும்.';

  @override
  String mapToShelter(String shelter) {
    return '$shelter நோக்கி';
  }

  @override
  String get mapNearestShelter => 'அருகிலுள்ள தங்குமிடம்';

  @override
  String get mapOsmUnverified =>
      'OpenStreetMap தங்குமிடங்கள் தானாக அடையாளம் காணப்பட்டவை, சரிபார்க்கப்படாதவை.';

  @override
  String get mapRouteStrategySafest => 'பாதுகாப்பு';

  @override
  String get mapRouteStrategyBalanced => 'சமநிலை';

  @override
  String get mapRouteStrategyShortest => 'வேகமான';

  @override
  String get mapLegendSafeRoad => 'பாதுகாப்பான சாலை';

  @override
  String get mapLegendFloodRoad => 'வெள்ளம் ஏற்படக்கூடிய சாலை';

  @override
  String get mapLegendInundation => 'வெள்ளப் பகுதி';

  @override
  String get mapLegendDmc => 'DMC தங்குமிடம்';

  @override
  String get mapLegendResearch => 'ஆராய்ச்சி தங்குமிடம்';

  @override
  String get mapLegendOsm => 'OSM தங்குமிடம்';

  @override
  String get mapLegendYou => 'நீங்கள்';

  @override
  String get mapLayers => 'வரைபட அடுக்குகள்';

  @override
  String get mapLayerRoads => 'சாலை பாதுகாப்பு';

  @override
  String get mapLayerInundation => 'வெள்ளப் பகுதி';

  @override
  String get mapLayerShelters => 'தங்குமிடங்கள்';

  @override
  String get mapSwitchDistrict => 'மாவட்டத்தை மாற்று';

  @override
  String get mapMapOnly => 'வரைபடம் மட்டும்';

  @override
  String get districtGalle => 'காலி';

  @override
  String get districtMatara => 'மாத்தறை';

  @override
  String get districtTangalle => 'தங்காலை';

  @override
  String mapMinutesShort(int minutes) {
    return '~$minutes நிமி.';
  }

  @override
  String mapPctSafe(int pct) {
    return '$pct% பாதுகாப்பு';
  }

  @override
  String mapPctRisky(int pct, int n) {
    return '$pct% • ஆபத்து $n';
  }

  @override
  String mapRouteHeading(String strategy) {
    return '$strategy பாதை';
  }

  @override
  String mapDistrictTitle(String district) {
    return '$district வரைபடம்';
  }

  @override
  String get mapLoading => 'வெளியேற்ற வரைபடம் ஏற்றப்படுகிறது…';

  @override
  String get mapUnavailable => 'வரைபடம் கிடைக்கவில்லை.';

  @override
  String get locationPermissionDenied =>
      'இருப்பிட அனுமதி அணைக்கப்பட்டுள்ளது. அமைப்புகளில் அதை இயக்கவும், அல்லது தொடக்கப் புள்ளியை அமைக்க வரைபடத்தைத் தட்டவும்.';

  @override
  String get locationServicesOff =>
      'இருப்பிட சேவைகள் அணைக்கப்பட்டுள்ளன. GPS ஐ இயக்கவும், அல்லது தொடக்கப் புள்ளியை அமைக்க வரைபடத்தைத் தட்டவும்.';

  @override
  String get locationUnavailable =>
      'இருப்பிடத்தைப் பெற முடியவில்லை. தொடக்கப் புள்ளியை அமைக்க வரைபடத்தைத் தட்டவும்.';

  @override
  String get locationPermissionDeniedEmergency =>
      'இருப்பிட அனுமதி அணைக்கப்பட்டுள்ளது. உங்கள் வெளியேற்றப் பாதையைப் பெற அமைப்புகளில் அதை இயக்கவும், அல்லது வரைபடத்தைத் தட்டவும்.';

  @override
  String get locationServicesOffEmergency =>
      'இருப்பிட சேவைகள் அணைக்கப்பட்டுள்ளன. உங்கள் வெளியேற்றப் பாதையைப் பெற GPS ஐ இயக்கவும், அல்லது வரைபடத்தைத் தட்டவும்.';

  @override
  String get emergencyTitle => 'சுனாமி எச்சரிக்கை';

  @override
  String get emergencyEvacuateNow => 'இப்போதே வெளியேறுங்கள்';

  @override
  String get emergencyLocating => 'உங்களைக் கண்டறிகிறது…';

  @override
  String get emergencyWaveArrivesIn => 'அலை வரும் நேரம்';

  @override
  String get emergencyMoveInland =>
      'கடற்கரையிலிருந்து விலகி, உள்நாட்டிற்கும் உயரமான இடத்திற்கும் செல்லுங்கள்.';

  @override
  String emergencyArrivalEstimate(int minutes) {
    return 'அலை ~$minutes நிமிடத்தில்';
  }

  @override
  String get emergencyDemoModel => 'மதிப்பீடு • செயல்விளக்க மாதிரி';

  @override
  String get emergencyEndDrill => 'பயிற்சியை முடி';

  @override
  String emergencyFollowRoute(String shelter) {
    return '$shelter நோக்கி பாதையைப் பின்தொடரவும்; உள்நாட்டிற்கும் உயரமான இடத்திற்கும் செல்லவும்.';
  }

  @override
  String emergencyMayNotReach(String shelter) {
    return 'நீங்கள் சரியான நேரத்தில் $shelter ஐ அடைய முடியாமல் போகலாம். இப்போதே அருகிலுள்ள உயரமான இடத்திற்கு, உள்நாட்டிற்குச் செல்லவும்.';
  }

  @override
  String get commonNext => 'அடுத்து';

  @override
  String get commonAdd => 'சேர்';

  @override
  String get commonReset => 'மீட்டமை';

  @override
  String get commonRemove => 'அகற்று';

  @override
  String get commonSave => 'சேமி';

  @override
  String learnCompletedCount(int done, int total) {
    return '$total இல் $done முடிந்தது';
  }

  @override
  String get learnNoLessons => 'பாடங்கள் எதுவும் இல்லை';

  @override
  String get learnLessons => 'பாடங்கள்';

  @override
  String get learnProgressTitle => 'உங்கள் கற்றல் முன்னேற்றம்';

  @override
  String learnPercentComplete(int pct) {
    return '$pct% முடிந்தது';
  }

  @override
  String get learnStartPrompt =>
      'பாதுகாப்பாக இருப்பது எப்படி என்பதை அறிய உங்கள் முதல் பாடத்தைத் தொடங்குங்கள்!';

  @override
  String get learnKeepGoing => 'தொடருங்கள்! நீங்கள் சிறப்பாக செய்கிறீர்கள்!';

  @override
  String get learnAllDone =>
      'அனைத்து பாடங்களும் முடிந்தன! நீங்கள் நன்கு தயாராக உள்ளீர்கள்.';

  @override
  String learnMinutes(int min) {
    return '$min நிமி.';
  }

  @override
  String learnMinRead(int min) {
    return '$min நிமி. வாசிப்பு';
  }

  @override
  String get learnQuiz => 'வினாடிவினா';

  @override
  String learnLessonNumber(int n) {
    return 'பாடம் $n';
  }

  @override
  String get learnTakeQuiz => 'வினாடிவினாவில் பங்கேற்கவும்';

  @override
  String get learnCompleted => 'முடிந்தது ✓';

  @override
  String get learnMarkComplete => 'முடிந்ததாகக் குறி';

  @override
  String learnQuestionOf(int n, int total) {
    return '$total இல் $n ஆம் கேள்வி';
  }

  @override
  String get learnSeeResults => 'முடிவுகளைக் காண்க';

  @override
  String get learnGreatJob => 'சிறப்பு!';

  @override
  String get learnKeepLearning => 'தொடர்ந்து கற்றுக்கொள்ளுங்கள்';

  @override
  String learnScore(int correct, int total, int pct) {
    return '$total இல் $correct சரியாக பெற்றீர்கள் ($pct%)';
  }

  @override
  String get learnCompleteLesson => 'பாடத்தை முடிக்கவும்';

  @override
  String get learnReviewLesson => 'பாடத்தை மீள்பார்வையிடு';

  @override
  String get learnLessonDoneToast => 'பாடம் முடிந்தது!';

  @override
  String get prepareTitle => 'தயாராகுங்கள்';

  @override
  String get prepareResetTooltip => 'சரிபார்ப்பு பட்டியலை மீட்டமை';

  @override
  String get prepareShareTooltip => 'சரிபார்ப்பு பட்டியலைப் பகிர்';

  @override
  String get prepareAddItem => 'உருப்படியைச் சேர்';

  @override
  String get prepareResetTitle => 'சரிபார்ப்பு பட்டியலை மீட்டமைக்கவா?';

  @override
  String get prepareResetBody =>
      'இது அனைத்து உருப்படிகளையும் தேர்வுநீக்கும். உங்கள் குறிப்புகள் பாதுகாக்கப்படும்.';

  @override
  String get prepareResetDone => 'சரிபார்ப்பு பட்டியல் மீட்டமைக்கப்பட்டது';

  @override
  String get prepareAddCustomTitle => 'தனிப்பயன் உருப்படியைச் சேர்';

  @override
  String get prepareCategory => 'வகை';

  @override
  String get prepareItemName => 'உருப்படியின் பெயர்';

  @override
  String get prepareItemAdded => 'உருப்படி சேர்க்கப்பட்டது';

  @override
  String get prepareFullyPrepared => '🎉 முழுமையாக தயார்!';

  @override
  String get preparePreparednessLevel => 'தயார்நிலை அளவு';

  @override
  String get prepareCompleteMsg =>
      'சிறப்பு! அவசரநிலைக்கு உங்களிடம் அனைத்தும் தயாராக உள்ளது.';

  @override
  String get prepareIncompleteMsg =>
      'அவசரநிலைகளுக்குத் தயாராக இருக்க சரிபார்ப்பு பட்டியலை முடிக்கவும்.';

  @override
  String prepareItemsComplete(int done, int total) {
    return '$total இல் $done முடிந்தது';
  }

  @override
  String get prepareRequired => 'தேவை';

  @override
  String get prepareNoteTitle => 'குறிப்பு சேர்';

  @override
  String get prepareNoteHint =>
      'ஒரு குறிப்பைச் சேர்க்கவும் (எ.கா. இடம், முடிவுத் தேதி)';

  @override
  String get prepareTipsTitle => 'தயார்நிலை குறிப்புகள்';

  @override
  String get prepareTip1Title => 'வழக்கமான புதுப்பிப்புகள்';

  @override
  String get prepareTip1Body =>
      'ஒவ்வொரு 6 மாதங்களுக்கும் உங்கள் அவசரப் பெட்டியை மீள்பார்வையிட்டு புதுப்பிக்கவும்.';

  @override
  String get prepareTip2Title => 'நீர் சேமிப்பு';

  @override
  String get prepareTip2Body =>
      'குறைந்தது 3 நாட்களுக்கு ஒருவருக்கு ஒரு நாளைக்கு 3 லிட்டர் நீரை சேமிக்கவும்.';

  @override
  String get prepareTip3Title => 'அவசர தொடர்புகள்';

  @override
  String get prepareTip3Body =>
      'உங்கள் பெட்டியில் அவசர தொடர்புகளின் எழுத்துப்பூர்வ பட்டியலை வைத்திருங்கள்.';

  @override
  String get prepareTip4Title => 'குடும்பத் திட்டம்';

  @override
  String get prepareTip4Body =>
      'உங்கள் குடும்பத்துடன் வெளியேற்றப் பாதைகளை விவாதித்து பயிற்சி செய்யுங்கள்.';

  @override
  String get prepareTip5Title => 'சந்திக்கும் இடம்';

  @override
  String get prepareTip5Body =>
      'குடும்ப உறுப்பினர்கள் பிரிந்தால் சந்திக்க ஒரு இடத்தைக் குறிக்கவும்.';

  @override
  String get mapTsunamiWarning => 'சுனாமி எச்சரிக்கை';

  @override
  String get mapOfflineBanner => 'ஆஃப்லைன், சேமித்த வரைபடம்';

  @override
  String get mapEvacuationMap => 'வெளியேற்ற வரைபடம்';

  @override
  String get commonTryAgain => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get openSettings => 'அமைப்புகளைத் திற';

  @override
  String get locationApproximate =>
      'உங்கள் கடைசியாக அறியப்பட்ட இடம் பயன்படுத்தப்படுகிறது; இது தோராயமாக இருக்கலாம்.';

  @override
  String get earthquakeViewOnMap => 'வரைபடத்தில் காண்க';

  @override
  String get earthquakeUsgsDetails => 'USGS விவரங்கள்';

  @override
  String get settingsPrivacyPolicy => 'தனியுரிமைக் கொள்கை';

  @override
  String get settingsTermsOfService => 'சேவை விதிமுறைகள்';
}
