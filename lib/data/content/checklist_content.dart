import '../models/checklist.dart';

/// Preparedness checklist content in English, Sinhala and Tamil. Category and
/// item ids (and the icon keys) are identical across languages so that a user's
/// checked/note state, keyed by those ids, survives a language switch.
/// Translations are for demonstration and should be reviewed by a native speaker
/// before any real-world deployment.
List<ChecklistCategory> categoriesFor(String langCode) {
  switch (langCode) {
    case 'si':
      return _si();
    case 'ta':
      return _ta();
    default:
      return _en();
  }
}

ChecklistItem _i(String id, String title, String desc, [int? reminder]) =>
    ChecklistItem(id: id, title: title, description: desc, reminderDays: reminder);

// ---------------------------------------------------------------------------
// English
// ---------------------------------------------------------------------------
List<ChecklistCategory> _en() => [
      ChecklistCategory(
        id: 'emergency_kit',
        name: 'Emergency Kit',
        icon: 'backpack',
        items: [
          _i('water', 'Drinking Water', 'At least 3 liters per person for 3 days', 180),
          _i('food', 'Non-perishable Food', 'Canned goods, dry foods, energy bars for 3 days', 180),
          _i('first_aid', 'First Aid Kit', 'Bandages, antiseptic, pain relievers, any personal medications', 365),
          _i('flashlight', 'Flashlight & Batteries', 'LED flashlight with extra batteries', 180),
          _i('radio', 'Battery/Crank Radio', 'To receive emergency broadcasts', 365),
          _i('phone_charger', 'Phone Charger / Power Bank', 'Fully charged power bank', 30),
          _i('cash', 'Cash (Small Bills)', 'ATMs may not work after disaster'),
          _i('documents', 'Important Documents', 'Copies of ID, insurance, bank details in waterproof bag'),
          _i('medications', 'Personal Medications', 'At least 7-day supply of essential medications', 90),
          _i('whistle', 'Whistle', 'To signal for help if trapped'),
        ],
      ),
      ChecklistCategory(
        id: 'family_plan',
        name: 'Family Plan',
        icon: 'family_restroom',
        items: [
          _i('meeting_point', 'Meeting Point Identified', 'A safe location where family members will reunite'),
          _i('contacts', 'Emergency Contacts Saved', 'Family contacts saved and memorized'),
          _i('route_known', 'Evacuation Route Known', 'Everyone knows the primary evacuation route'),
          _i('route_practiced', 'Evacuation Route Practiced', 'Family has walked the evacuation route together', 180),
          _i('responsibilities', 'Responsibilities Assigned', 'Who grabs what, who helps whom'),
          _i('out_of_area_contact', 'Out-of-Area Contact', 'A relative/friend outside the area to coordinate through'),
        ],
      ),
      ChecklistCategory(
        id: 'home_safety',
        name: 'Home Safety',
        icon: 'home',
        items: [
          _i('kit_location', 'Emergency Kit Location Known', 'Kit is in an accessible location known to all'),
          _i('shoes_ready', 'Sturdy Shoes Ready', 'Shoes near bed for quick evacuation (debris protection)'),
          _i('phone_charged', 'Phone Charged at Night', 'Keep phone charged, especially at night'),
          _i('insurance', 'Insurance Reviewed', 'Home/contents insurance covers natural disasters', 365),
        ],
      ),
      ChecklistCategory(
        id: 'knowledge',
        name: 'Knowledge & Skills',
        icon: 'school',
        items: [
          _i('warning_signs', 'Know Natural Warning Signs', 'Can recognize earthquake, ocean withdrawal, etc.'),
          _i('first_aid_training', 'Basic First Aid Knowledge', 'Know CPR, wound care, recovery position'),
          _i('safe_zones', 'Know Nearby Safe Zones', 'Can identify at least 2 nearby evacuation points'),
          _i('app_notifications', 'App Notifications Enabled', 'TsunamiSense notifications are turned on'),
        ],
      ),
    ];

// ---------------------------------------------------------------------------
// Sinhala (සිංහල)
// ---------------------------------------------------------------------------
List<ChecklistCategory> _si() => [
      ChecklistCategory(
        id: 'emergency_kit',
        name: 'හදිසි කට්ටලය',
        icon: 'backpack',
        items: [
          _i('water', 'පානීය ජලය', 'පුද්ගලයෙකුට දින 3කට අවම වශයෙන් ලීටර් 3ක්', 180),
          _i('food', 'නොනැසෙන ආහාර', 'දින 3කට ටින් කළ ආහාර, වියළි ආහාර, ශක්ති පුවරු', 180),
          _i('first_aid', 'ප්‍රථමාධාර කට්ටලය', 'බෙහෙත් පටි, විෂබීජ නාශක, වේදනා නාශක, පෞද්ගලික ඖෂධ', 365),
          _i('flashlight', 'අත්විදුලි පහන සහ බැටරි', 'අමතර බැටරි සහිත LED අත්විදුලි පහනක්', 180),
          _i('radio', 'බැටරි/හැඬ රේඩියෝව', 'හදිසි විකාශන ලබා ගැනීමට', 365),
          _i('phone_charger', 'දුරකථන ආරෝපකය / පවර් බෑංකුව', 'සම්පූර්ණයෙන් ආරෝපිත පවර් බෑංකුවක්', 30),
          _i('cash', 'මුදල් (කුඩා නෝට්ටු)', 'ආපදාවෙන් පසු ATM ක්‍රියා නොකළ හැක'),
          _i('documents', 'වැදගත් ලේඛන', 'හැඳුනුම්පත්, රක්ෂණ, බැංකු විස්තර පිටපත් ජල ආරක්ෂිත බෑගයක'),
          _i('medications', 'පෞද්ගලික ඖෂධ', 'අත්‍යවශ්‍ය ඖෂධ දින 7ක සැපයුමක් වත්', 90),
          _i('whistle', 'විසිල් නලාව', 'හිරවුවහොත් උදව් ඉල්ලීමට'),
        ],
      ),
      ChecklistCategory(
        id: 'family_plan',
        name: 'පවුල් සැලැස්ම',
        icon: 'family_restroom',
        items: [
          _i('meeting_point', 'හමුවන ස්ථානය හඳුනාගෙන', 'පවුලේ අය නැවත එක්වන ආරක්ෂිත ස්ථානයක්'),
          _i('contacts', 'හදිසි ඇමතුම් සුරැකීම', 'පවුලේ ඇමතුම් සුරැකී කටපාඩම් කර ඇත'),
          _i('route_known', 'ඉවත් වීමේ මාර්ගය දැනීම', 'සැමට ප්‍රධාන ඉවත් වීමේ මාර්ගය දනී'),
          _i('route_practiced', 'ඉවත් වීමේ මාර්ගය පුහුණු කර ඇත', 'පවුල එක්ව ඉවත් වීමේ මාර්ගයේ ගමන් කර ඇත', 180),
          _i('responsibilities', 'වගකීම් පවරා ඇත', 'කවුද කුමක් රැගෙන යන්නේ, කවුද කාට උදව් කරන්නේ'),
          _i('out_of_area_contact', 'ප්‍රදේශයෙන් පිටත ඇමතුමක්', 'සම්බන්ධීකරණය සඳහා ප්‍රදේශයෙන් පිටත ඥාතියෙක්/මිතුරෙක්'),
        ],
      ),
      ChecklistCategory(
        id: 'home_safety',
        name: 'නිවසේ ආරක්ෂාව',
        icon: 'home',
        items: [
          _i('kit_location', 'හදිසි කට්ටලයේ ස්ථානය දැනීම', 'කට්ටලය සැමට ප්‍රවේශ විය හැකි ස්ථානයක ඇත'),
          _i('shoes_ready', 'ශක්තිමත් සපත්තු සූදානම්', 'ඉක්මන් ඉවත් වීමට ඇඳ අසල සපත්තු (සුන්බුන්වලින් ආරක්ෂාව)'),
          _i('phone_charged', 'රාත්‍රියේ දුරකථනය ආරෝපණය කර', 'විශේෂයෙන් රාත්‍රියේ දුරකථනය ආරෝපිතව තබා ගන්න'),
          _i('insurance', 'රක්ෂණය සමාලෝචනය කර', 'නිවස/අන්තර්ගත රක්ෂණය ස්වභාවික ආපදා ආවරණය කරයි', 365),
        ],
      ),
      ChecklistCategory(
        id: 'knowledge',
        name: 'දැනුම සහ කුසලතා',
        icon: 'school',
        items: [
          _i('warning_signs', 'ස්වභාවික අනතුරු ඇඟවීමේ සංඥා දැනීම', 'භූමිකම්පා, මුහුද ඈත්වීම ආදිය හඳුනාගත හැක'),
          _i('first_aid_training', 'මූලික ප්‍රථමාධාර දැනුම', 'CPR, තුවාල රැකවරණය, ප්‍රකෘති ඉරියව්ව දැනීම'),
          _i('safe_zones', 'ආසන්න ආරක්ෂිත කලාප දැනීම', 'ආසන්න ඉවත් වීමේ ස්ථාන අවම 2ක් හඳුනාගත හැක'),
          _i('app_notifications', 'යෙදුම් දැනුම්දීම් සක්‍රීයයි', 'TsunamiSense දැනුම්දීම් සක්‍රීය කර ඇත'),
        ],
      ),
    ];

// ---------------------------------------------------------------------------
// Tamil (தமிழ்)
// ---------------------------------------------------------------------------
List<ChecklistCategory> _ta() => [
      ChecklistCategory(
        id: 'emergency_kit',
        name: 'அவசரப் பெட்டி',
        icon: 'backpack',
        items: [
          _i('water', 'குடிநீர்', 'ஒருவருக்கு 3 நாட்களுக்கு குறைந்தது 3 லிட்டர்', 180),
          _i('food', 'கெடாத உணவு', '3 நாட்களுக்கு பதிவு உணவு, உலர் உணவு, ஆற்றல் பார்கள்', 180),
          _i('first_aid', 'முதலுதவிப் பெட்டி', 'கட்டுகள், கிருமிநாசினி, வலி நிவாரணிகள், தனிப்பட்ட மருந்துகள்', 365),
          _i('flashlight', 'டார்ச் விளக்கு & பேட்டரிகள்', 'கூடுதல் பேட்டரிகளுடன் LED டார்ச்', 180),
          _i('radio', 'பேட்டரி/கைச்சுழற்சி வானொலி', 'அவசர ஒளிபரப்புகளைப் பெற', 365),
          _i('phone_charger', 'தொலைபேசி சார்ஜர் / பவர் பேங்க்', 'முழுமையாக சார்ஜ் செய்யப்பட்ட பவர் பேங்க்', 30),
          _i('cash', 'பணம் (சிறிய நோட்டுகள்)', 'பேரழிவுக்குப் பிறகு ATM வேலை செய்யாமல் போகலாம்'),
          _i('documents', 'முக்கிய ஆவணங்கள்', 'அடையாள அட்டை, காப்பீடு, வங்கி விவரங்களின் நகல்கள் நீர்ப்புகா பையில்'),
          _i('medications', 'தனிப்பட்ட மருந்துகள்', 'அத்தியாவசிய மருந்துகளின் குறைந்தது 7 நாள் இருப்பு', 90),
          _i('whistle', 'விசில்', 'சிக்கினால் உதவிக்கு சமிக்ஞை செய்ய'),
        ],
      ),
      ChecklistCategory(
        id: 'family_plan',
        name: 'குடும்பத் திட்டம்',
        icon: 'family_restroom',
        items: [
          _i('meeting_point', 'சந்திக்கும் இடம் அடையாளம் காணப்பட்டது', 'குடும்ப உறுப்பினர்கள் மீண்டும் ஒன்றுசேரும் பாதுகாப்பான இடம்'),
          _i('contacts', 'அவசர தொடர்புகள் சேமிக்கப்பட்டன', 'குடும்பத் தொடர்புகள் சேமிக்கப்பட்டு மனப்பாடம் செய்யப்பட்டன'),
          _i('route_known', 'வெளியேற்றப் பாதை தெரியும்', 'அனைவருக்கும் முதன்மை வெளியேற்றப் பாதை தெரியும்'),
          _i('route_practiced', 'வெளியேற்றப் பாதை பயிற்சி செய்யப்பட்டது', 'குடும்பம் ஒன்றாக வெளியேற்றப் பாதையில் நடந்துள்ளது', 180),
          _i('responsibilities', 'பொறுப்புகள் ஒதுக்கப்பட்டன', 'யார் எதை எடுப்பது, யார் யாருக்கு உதவுவது'),
          _i('out_of_area_contact', 'பகுதிக்கு வெளியே தொடர்பு', 'ஒருங்கிணைக்க பகுதிக்கு வெளியே ஒரு உறவினர்/நண்பர்'),
        ],
      ),
      ChecklistCategory(
        id: 'home_safety',
        name: 'வீட்டுப் பாதுகாப்பு',
        icon: 'home',
        items: [
          _i('kit_location', 'அவசரப் பெட்டியின் இடம் தெரியும்', 'பெட்டி அனைவருக்கும் தெரிந்த அணுகக்கூடிய இடத்தில் உள்ளது'),
          _i('shoes_ready', 'உறுதியான காலணிகள் தயார்', 'விரைவு வெளியேற்றத்திற்கு படுக்கைக்கு அருகில் காலணிகள் (குப்பை பாதுகாப்பு)'),
          _i('phone_charged', 'இரவில் தொலைபேசி சார்ஜ் செய்யப்பட்டது', 'குறிப்பாக இரவில் தொலைபேசியை சார்ஜ் செய்து வைக்கவும்'),
          _i('insurance', 'காப்பீடு மறுஆய்வு செய்யப்பட்டது', 'வீடு/பொருட்கள் காப்பீடு இயற்கை பேரழிவுகளை உள்ளடக்கியது', 365),
        ],
      ),
      ChecklistCategory(
        id: 'knowledge',
        name: 'அறிவு & திறன்கள்',
        icon: 'school',
        items: [
          _i('warning_signs', 'இயற்கை எச்சரிக்கை அறிகுறிகளை அறிதல்', 'நிலநடுக்கம், கடல் பின்வாங்கல் போன்றவற்றை அடையாளம் காணலாம்'),
          _i('first_aid_training', 'அடிப்படை முதலுதவி அறிவு', 'CPR, காயம் பராமரிப்பு, மீட்பு நிலை தெரியும்'),
          _i('safe_zones', 'அருகிலுள்ள பாதுகாப்பான மண்டலங்களை அறிதல்', 'அருகிலுள்ள குறைந்தது 2 வெளியேற்றப் புள்ளிகளை அடையாளம் காணலாம்'),
          _i('app_notifications', 'ஆப் அறிவிப்புகள் இயக்கப்பட்டன', 'TsunamiSense அறிவிப்புகள் இயக்கப்பட்டுள்ளன'),
        ],
      ),
    ];
