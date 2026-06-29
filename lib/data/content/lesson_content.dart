import '../models/lesson.dart';

/// Lesson content in English, Sinhala and Tamil. The structure (ids, order,
/// number of lessons and quiz questions) is identical across languages so that
/// completion state, which is keyed by the stable lesson id, survives a language
/// switch. Translations are authored for demonstration and should be reviewed by
/// a native speaker before any real-world deployment.
List<Lesson> lessonsFor(String langCode) {
  switch (langCode) {
    case 'si':
      return _lessonsSi();
    case 'ta':
      return _lessonsTa();
    default:
      return _lessonsEn();
  }
}

// ---------------------------------------------------------------------------
// English
// ---------------------------------------------------------------------------
List<Lesson> _lessonsEn() => [
      Lesson(
        id: 'lesson_1',
        order: 1,
        title: 'What is a Tsunami?',
        description: 'Learn about the science behind tsunamis and how they form.',
        estimatedMinutes: 5,
        content: '''
# What is a Tsunami?

A **tsunami** (from Japanese: 津波, meaning "harbor wave") is a series of ocean waves with very long wavelengths caused by large-scale disturbances of the ocean.

## How Tsunamis Form

Tsunamis are typically caused by:

1. **Underwater Earthquakes** - The most common cause (about 80% of tsunamis)
2. **Volcanic Eruptions** - Underwater or coastal volcanoes
3. **Landslides** - Underwater or coastal landslides
4. **Meteorite Impacts** - Rare but possible

## Key Facts

- Tsunami waves can travel at speeds up to **800 km/h** (500 mph) in deep ocean
- In the open ocean, waves may be only 30-60 cm high
- As they approach shore, waves slow down but **grow in height**
- A tsunami is not a single wave but a **series of waves** (wave train)
- The first wave is often not the largest

## The 2004 Indian Ocean Tsunami

On December 26, 2004, a magnitude 9.1 earthquake off Sumatra, Indonesia triggered a devastating tsunami that affected Sri Lanka, killing over 35,000 people.

This tragedy showed the importance of **early warning systems** and **public education**.

## Remember

⚠️ Tsunamis can arrive within **minutes** of a nearby earthquake, or take **hours** if the source is far away.
''',
        quiz: [
          QuizQuestion(
            question: 'What is the most common cause of tsunamis?',
            options: [
              'Volcanic eruptions',
              'Underwater earthquakes',
              'Meteorite impacts',
              'Strong winds',
            ],
            correctIndex: 1,
            explanation: 'About 80% of tsunamis are caused by underwater earthquakes.',
          ),
          QuizQuestion(
            question: 'How fast can tsunami waves travel in the deep ocean?',
            options: ['100 km/h', '300 km/h', '800 km/h', '50 km/h'],
            correctIndex: 2,
            explanation: 'Tsunami waves can travel at speeds up to 800 km/h in deep ocean waters.',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_2',
        order: 2,
        title: 'Natural Warning Signs',
        description: 'Recognize nature\'s warning signs of an approaching tsunami.',
        estimatedMinutes: 5,
        content: '''
# Natural Warning Signs

Nature often provides warning signs before a tsunami arrives. Knowing these signs could save your life.

## 🌊 Sudden Sea Withdrawal

The ocean may **recede dramatically** from the shore, exposing the sea floor. This is a major warning sign!

- Do NOT go to investigate the exposed sea floor
- This water WILL return as a powerful wave
- You may have only **5-10 minutes** before the wave arrives

## 🌍 Strong Earthquake

If you feel a strong earthquake while near the coast:

- **Drop, Cover, and Hold On** during the shaking
- Once shaking stops, **immediately move to high ground**
- Don't wait for an official warning if the earthquake was strong

## 🔊 Unusual Sounds

Listen for:
- A **loud roar** like a train or aircraft
- Unusual **rumbling** sounds from the ocean

## 🐟 Unusual Animal Behavior

Animals may sense danger before humans:
- Fish swimming erratically
- Birds flying inland
- Dogs barking or acting restless

## ⏰ Time is Critical

If you feel an earthquake OR see the ocean recede unusually, don't wait - move to high ground immediately!
''',
        quiz: [
          QuizQuestion(
            question: 'What should you do if you see the ocean suddenly recede from the shore?',
            options: [
              'Go investigate the exposed sea floor',
              'Take photos for social media',
              'Immediately move to high ground',
              'Wait for an official announcement',
            ],
            correctIndex: 2,
            explanation: 'A sudden sea withdrawal is a major tsunami warning sign. Move to high ground immediately!',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_3',
        order: 3,
        title: 'What to Do When Alert Sounds',
        description: 'Step-by-step actions when a tsunami warning is issued.',
        estimatedMinutes: 7,
        content: '''
# What to Do When Alert Sounds

When you receive a tsunami warning, **every second counts**. Here's what to do:

## 📱 When You Receive an Alert

1. **Stay calm** - Panic wastes precious time
2. **Verify the alert** - Check official sources if possible
3. **Alert others** - Tell family members and neighbors
4. **Begin evacuation immediately**

## 🏃 Evacuation Steps

### Step 1: Grab Your Emergency Kit
If it's ready and nearby (30 seconds max), take it. Otherwise, **just go**.

### Step 2: Move to High Ground
- Go to **at least 30 meters (100 feet) elevation**
- Or move **2 km (1.2 miles) inland**
- If no high ground available, go to upper floors of a **reinforced concrete building**

### Step 3: Use Designated Routes
- Follow evacuation route signs if available
- Avoid beaches, harbors, and low-lying coastal areas
- **Never go towards the ocean to watch**

## 🏢 Vertical Evacuation
If you cannot reach high ground:
- Go to the **3rd floor or higher** of a reinforced concrete building
- Stay away from windows

## ⏳ How Long to Stay

- Wait for the **official "all clear"** announcement
- Waves may continue for **8-12 hours**
- The first wave is often NOT the largest
- Do not return until authorities say it's safe

## ⚠️ Never Do These
- ❌ Go to the beach to watch
- ❌ Return home too early
- ❌ Assume one wave is all
- ❌ Use elevators during evacuation
''',
        quiz: [
          QuizQuestion(
            question: 'How high should you evacuate to be safe from a tsunami?',
            options: [
              '5 meters elevation',
              '10 meters elevation',
              'At least 30 meters elevation',
              '100 meters elevation',
            ],
            correctIndex: 2,
            explanation: 'You should evacuate to at least 30 meters (100 feet) elevation or 2 km inland.',
          ),
          QuizQuestion(
            question: 'If you cannot reach high ground, what should you do?',
            options: [
              'Stay on the beach',
              'Go to the 3rd floor or higher of a reinforced concrete building',
              'Hide in a basement',
              'Get in a boat',
            ],
            correctIndex: 1,
            explanation: 'Vertical evacuation to the 3rd floor or higher of a strong building is a valid option when high ground is not accessible.',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_4',
        order: 4,
        title: 'Evacuation Basics',
        description: 'Plan your evacuation route and know your safe zones.',
        estimatedMinutes: 6,
        content: '''
# Evacuation Basics

Preparation is key. Know your evacuation route BEFORE a disaster strikes.

## 📍 Know Your Zone

Check if you are in a tsunami zone:
- Are you within 2 km of the coast?
- Are you at elevation less than 10 meters?
- Are you near a river mouth or harbor?

If YES to any of these, you need an evacuation plan.

## 🗺️ Plan Your Route

Identify multiple routes:
- Primary route to nearest high ground
- Secondary route (in case primary is blocked)
- Meeting point for family members

A good evacuation route:
- Leads AWAY from the coast
- Goes UPHILL
- Avoids bridges over water
- Is wide enough to handle crowds

## 🏢 Know Your Safe Zones

Types of safe zones:
1. **Natural High Ground** - Hills, elevated areas
2. **Vertical Evacuation Buildings** - Tall, strong buildings
3. **Designated Shelters** - Schools, temples, government buildings

Use the **TsunamiSense Map** to see inundation zones, safe evacuation points, and the distance to the nearest safe zone.

## 👨‍👩‍👧‍👦 Family Plan

1. **Designate a meeting point** outside the danger zone
2. **Share the plan** with all family members
3. **Practice the route** at least twice a year
4. **Assign responsibilities** (who grabs the kit, who helps elderly)

## ⏱️ Plan for Walking Speed

Roads may be congested, so plan to evacuate on foot. Walking 1 km takes about 12 minutes.
''',
        quiz: [
          QuizQuestion(
            question: 'How often should you practice your evacuation route?',
            options: [
              'Once in a lifetime',
              'Every month',
              'At least twice a year',
              'Only after a warning',
            ],
            correctIndex: 2,
            explanation: 'Practice your evacuation route at least twice a year to ensure everyone knows what to do.',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_5',
        order: 5,
        title: 'After the Tsunami',
        description: 'What to do after the immediate danger has passed.',
        estimatedMinutes: 5,
        content: '''
# After the Tsunami

Even after the waves stop, dangers remain. Here's how to stay safe.

## ⏳ Wait for the All Clear

- **Do NOT return** until authorities give the "all clear"
- Tsunami waves can continue for **8-12 hours**
- Later waves are often **larger** than the first

## 🏠 Returning Home

Before entering buildings, check for:
- Structural damage
- Gas leaks (smell)
- Electrical hazards
- Weakened floors

Watch for contaminated water, debris, unstable structures, downed power lines, and displaced wildlife such as snakes.

## 💧 Water Safety

- **Don't drink tap water** until authorities confirm it's safe
- Floodwater is contaminated - avoid contact
- Boil water if unsure

## 📱 Communication

- Keep phone calls short to reduce network load
- Use text messages instead of calls
- Update family on your status
- Only share verified information; do not spread rumors

## 🤝 Help Others

If you are safe, check on neighbors, especially the elderly, share supplies if you have extra, and report missing persons.

## 🧠 Mental Health

It is normal to feel anxiety, difficulty sleeping, or sadness. **Seek help if these feelings persist.** Talk to family, friends, or professionals.
''',
        quiz: [
          QuizQuestion(
            question: 'When is it safe to return home after a tsunami?',
            options: [
              'After the first wave',
              'After 1 hour',
              'When authorities give the "all clear"',
              'When the water recedes',
            ],
            correctIndex: 2,
            explanation: 'Only return when authorities confirm it is safe. Waves can continue for 8-12 hours.',
          ),
        ],
      ),
    ];

// ---------------------------------------------------------------------------
// Sinhala (සිංහල)
// ---------------------------------------------------------------------------
List<Lesson> _lessonsSi() => [
      Lesson(
        id: 'lesson_1',
        order: 1,
        title: 'සුනාමි යනු කුමක්ද?',
        description: 'සුනාමි පිටුපස ඇති විද්‍යාව සහ ඒවා සෑදෙන ආකාරය ඉගෙන ගන්න.',
        estimatedMinutes: 5,
        content: '''
# සුනාමි යනු කුමක්ද?

**සුනාමි** (ජපන් භාෂාවෙන්: 津波, අර්ථය "වරාය රළ") යනු සාගරයේ මහා පරිමාණ කැළඹීම් නිසා ඇතිවන, ඉතා දිගු තරංග ආයාම සහිත සාගර තරංග මාලාවකි.

## සුනාමි සෑදෙන ආකාරය

සුනාමි සාමාන්‍යයෙන් ඇතිවන්නේ:

1. **සාගරය යට භූමිකම්පා** - වඩාත්ම පොදු හේතුව (සුනාමිවලින් ~80%ක්)
2. **ගිනිකඳු පිපිරීම්** - සාගරය යට හෝ වෙරළබඩ ගිනිකඳු
3. **නායයෑම්** - සාගරය යට හෝ වෙරළබඩ නායයෑම්
4. **උල්කා පතනය** - දුර්ලභ නමුත් හැකි

## ප්‍රධාන කරුණු

- ගැඹුරු සාගරයේ සුනාමි තරංග පැයට **කි.මී. 800** දක්වා වේගයෙන් ගමන් කළ හැක
- විවෘත සාගරයේදී තරංග උස සෙ.මී. 30-60ක් පමණක් විය හැක
- වෙරළට ළං වන විට තරංග මන්දගාමී වන නමුත් **උසින් වැඩි වේ**
- සුනාමියක් යනු තනි තරංගයක් නොව **තරංග මාලාවකි**
- පළමු තරංගය බොහෝ විට විශාලම නොවේ

## 2004 ඉන්දියන් සාගර සුනාමිය

2004 දෙසැම්බර් 26 වන දින, ඉන්දුනීසියාවේ සුමාත්‍රා අසල සිදුවූ විශාලත්වය 9.1ක භූමිකම්පාවක් ශ්‍රී ලංකාවට බලපෑ විනාශකාරී සුනාමියක් ඇති කළ අතර, පුද්ගලයින් 35,000කට වැඩි පිරිසක් මිය ගියහ.

මෙම ඛේදවාචකය **පූර්ව අනතුරු ඇඟවීමේ පද්ධති** සහ **මහජන අධ්‍යාපනය**ේ වැදගත්කම පෙන්වා දුන්නේය.

## මතක තබා ගන්න

⚠️ ආසන්න භූමිකම්පාවකින් **මිනිත්තු** කිහිපයකින් සුනාමි පැමිණිය හැක, නැතහොත් මූලාශ්‍රය දුර නම් **පැය** ගණනක් ගත විය හැක.
''',
        quiz: [
          QuizQuestion(
            question: 'සුනාමි ඇතිවීමට වඩාත්ම පොදු හේතුව කුමක්ද?',
            options: [
              'ගිනිකඳු පිපිරීම්',
              'සාගරය යට භූමිකම්පා',
              'උල්කා පතනය',
              'තද සුළං',
            ],
            correctIndex: 1,
            explanation: 'සුනාමිවලින් ~80%ක් ඇතිවන්නේ සාගරය යට භූමිකම්පා නිසාය.',
          ),
          QuizQuestion(
            question: 'ගැඹුරු සාගරයේ සුනාමි තරංග කොතරම් වේගයෙන් ගමන් කළ හැකිද?',
            options: ['පැයට කි.මී. 100', 'පැයට කි.මී. 300', 'පැයට කි.මී. 800', 'පැයට කි.මී. 50'],
            correctIndex: 2,
            explanation: 'ගැඹුරු සාගරයේ සුනාමි තරංග පැයට කි.මී. 800ක් දක්වා වේගයෙන් ගමන් කළ හැක.',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_2',
        order: 2,
        title: 'ස්වභාවික අනතුරු ඇඟවීමේ සංඥා',
        description: 'ළඟා වන සුනාමියක ස්වභාවධර්මයේ අනතුරු ඇඟවීමේ සංඥා හඳුනා ගන්න.',
        estimatedMinutes: 5,
        content: '''
# ස්වභාවික අනතුරු ඇඟවීමේ සංඥා

සුනාමියක් පැමිණීමට පෙර ස්වභාවධර්මය බොහෝ විට අනතුරු ඇඟවීමේ සංඥා සපයයි. මෙම සංඥා දැනගැනීම ඔබේ ජීවිතය බේරාගත හැක.

## 🌊 හදිසි මුහුද ඈත්වීම

මුහුද වෙරළෙන් **නාටකාකාරව ඈත් වී** මුහුදු පත්ල හෙළිදරව් කළ හැක. මෙය ප්‍රධාන අනතුරු ඇඟවීමේ සංඥාවකි!

- හෙළිදරව් වූ මුහුදු පත්ල බැලීමට නොයන්න
- මෙම ජලය බලවත් තරංගයක් ලෙස නැවත පැමිණේ
- තරංගය පැමිණීමට පෙර ඔබට ඇත්තේ **මිනිත්තු 5-10ක්** පමණි

## 🌍 තද භූමිකම්පාව

ඔබ වෙරළට ආසන්නව සිටියදී තද භූමිකම්පාවක් දැනේ නම්:

- කම්පනය අතරතුර **බිම නැවී, ආවරණය වී, අල්ලාගෙන සිටින්න**
- කම්පනය නැවතුණු විට, **වහාම උස් බිමකට යන්න**
- භූමිකම්පාව තද නම් නිල අනතුරු ඇඟවීමක් එනතුරු බලා නොසිටින්න

## 🔊 අසාමාන්‍ය ශබ්ද

මෙයට සවන් දෙන්න:
- දුම්රියක් හෝ ගුවන් යානයක් වැනි **මහත් ගර්ජනයක්**
- සාගරයෙන් එන අසාමාන්‍ය **ගුගුරන** ශබ්ද

## 🐟 අසාමාන්‍ය සත්ව හැසිරීම

මිනිසුන්ට පෙර සතුන් අන්තරාව දැනගත හැක:
- මත්ස්‍යයන් අවිධිමත් ලෙස පිහිනීම
- පක්ෂීන් ගොඩබිමට පියාසර කිරීම
- බල්ලන් බුරමින් නොසන්සුන්ව හැසිරීම

## ⏰ කාලය තීරණාත්මකයි

ඔබට භූමිකම්පාවක් දැනේ නම් හෝ මුහුද අසාමාන්‍ය ලෙස ඈත් වනු දකින්නේ නම්, බලා නොසිට වහාම උස් බිමකට යන්න!
''',
        quiz: [
          QuizQuestion(
            question: 'මුහුද හදිසියේ වෙරළෙන් ඈත් වනු දුටුවහොත් ඔබ කළ යුත්තේ කුමක්ද?',
            options: [
              'හෙළිදරව් වූ මුහුදු පත්ල බැලීමට යන්න',
              'සමාජ මාධ්‍ය සඳහා ඡායාරූප ගන්න',
              'වහාම උස් බිමකට යන්න',
              'නිල නිවේදනයක් එනතුරු බලා සිටින්න',
            ],
            correctIndex: 2,
            explanation: 'හදිසි මුහුද ඈත්වීම ප්‍රධාන සුනාමි අනතුරු ඇඟවීමේ සංඥාවකි. වහාම උස් බිමකට යන්න!',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_3',
        order: 3,
        title: 'අනතුරු ඇඟවීම නාද වන විට කළ යුතු දේ',
        description: 'සුනාමි අනතුරු ඇඟවීමක් නිකුත් වූ විට පියවරෙන් පියවර ක්‍රියාමාර්ග.',
        estimatedMinutes: 7,
        content: '''
# අනතුරු ඇඟවීම නාද වන විට කළ යුතු දේ

ඔබට සුනාමි අනතුරු ඇඟවීමක් ලැබුණු විට, **සෑම තත්පරයක්ම වැදගත්ය**. කළ යුත්තේ මෙයයි:

## 📱 අනතුරු ඇඟවීමක් ලැබුණු විට

1. **සන්සුන්ව සිටින්න** - භීතිය වටිනා කාලය නාස්ති කරයි
2. **අනතුරු ඇඟවීම තහවුරු කරන්න** - හැකි නම් නිල මූලාශ්‍ර පරීක්ෂා කරන්න
3. **අන් අයට දැනුම් දෙන්න** - පවුලේ අය සහ අසල්වැසියන්ට කියන්න
4. **වහාම ඉවත් වීම ආරම්භ කරන්න**

## 🏃 ඉවත් වීමේ පියවර

### පියවර 1: ඔබේ හදිසි කට්ටලය රැගෙන යන්න
එය සූදානම්ව ආසන්නව ඇත්නම් (උපරිම තත්පර 30) රැගෙන යන්න. නැතහොත් **යන්නම යන්න**.

### පියවර 2: උස් බිමකට යන්න
- අවම වශයෙන් **මීටර් 30 (අඩි 100) උසකට** යන්න
- නැතහොත් **කි.මී. 2ක් අභ්‍යන්තරයට** යන්න
- උස් බිමක් නොමැති නම්, **ශක්තිමත් කොන්ක්‍රීට් ගොඩනැගිල්ලක** ඉහළ මහල්වලට යන්න

### පියවර 3: නියමිත මාර්ග භාවිතා කරන්න
- තිබේ නම් ඉවත් වීමේ මාර්ග සලකුණු අනුගමනය කරන්න
- වෙරළවල්, වරායන් සහ පහත් වෙරළබඩ ප්‍රදේශ වළකින්න
- **බැලීමට කිසිවිටෙක මුහුද දෙසට නොයන්න**

## 🏢 සිරස් ඉවත් වීම
ඔබට උස් බිමකට යා නොහැකි නම්:
- ශක්තිමත් කොන්ක්‍රීට් ගොඩනැගිල්ලක **3 වන මහල හෝ ඊට ඉහළ** මහලකට යන්න
- ජනේලවලින් ඈත්ව සිටින්න

## ⏳ කොපමණ කාලයක් රැඳී සිටිය යුතුද

- නිල **"සියල්ල සුරක්ෂිතයි"** නිවේදනය එනතුරු බලා සිටින්න
- තරංග **පැය 8-12ක්** දිගටම පැවතිය හැක
- පළමු තරංගය බොහෝ විට විශාලම නොවේ
- බලධාරීන් ආරක්ෂිත යැයි පවසන තුරු ආපසු නොයන්න

## ⚠️ කිසිවිටෙක මේවා නොකරන්න
- ❌ බැලීමට වෙරළට යාම
- ❌ ඉතා ඉක්මනින් නිවසට ආපසු යාම
- ❌ එක් තරංගයක් පමණයි යැයි සිතීම
- ❌ ඉවත් වීමේදී විදුලි සෝපාන භාවිතය
''',
        quiz: [
          QuizQuestion(
            question: 'සුනාමියකින් ආරක්ෂිත වීමට ඔබ කොතරම් උසකට ඉවත් විය යුතුද?',
            options: [
              'මීටර් 5 උසකට',
              'මීටර් 10 උසකට',
              'අවම වශයෙන් මීටර් 30 උසකට',
              'මීටර් 100 උසකට',
            ],
            correctIndex: 2,
            explanation: 'ඔබ අවම වශයෙන් මීටර් 30 (අඩි 100) උසකට හෝ කි.මී. 2ක් අභ්‍යන්තරයට ඉවත් විය යුතුය.',
          ),
          QuizQuestion(
            question: 'ඔබට උස් බිමකට යා නොහැකි නම්, ඔබ කළ යුත්තේ කුමක්ද?',
            options: [
              'වෙරළේ රැඳී සිටින්න',
              'ශක්තිමත් කොන්ක්‍රීට් ගොඩනැගිල්ලක 3 වන මහල හෝ ඊට ඉහළට යන්න',
              'බිම් මහලක සැඟවී සිටින්න',
              'බෝට්ටුවකට නැගීම',
            ],
            correctIndex: 1,
            explanation: 'උස් බිමකට යා නොහැකි විට, ශක්තිමත් ගොඩනැගිල්ලක 3 වන මහල හෝ ඊට ඉහළට සිරස් ඉවත් වීම වලංගු විකල්පයකි.',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_4',
        order: 4,
        title: 'ඉවත් වීමේ මූලික කරුණු',
        description: 'ඔබේ ඉවත් වීමේ මාර්ගය සැලසුම් කර ඔබේ ආරක්ෂිත කලාප දැනගන්න.',
        estimatedMinutes: 6,
        content: '''
# ඉවත් වීමේ මූලික කරුණු

සූදානම වැදගත්ය. ආපදාවක් සිදුවීමට **පෙර** ඔබේ ඉවත් වීමේ මාර්ගය දැනගන්න.

## 📍 ඔබේ කලාපය දැනගන්න

ඔබ සුනාමි කලාපයක සිටීද යන්න පරීක්ෂා කරන්න:
- ඔබ වෙරළේ සිට කි.මී. 2ක් ඇතුළත සිටීද?
- ඔබ මීටර් 10ට අඩු උසක සිටීද?
- ඔබ ගඟ මුඛයකට හෝ වරායකට ආසන්නද?

මෙයින් කිසිවකට ඔව් නම්, ඔබට ඉවත් වීමේ සැලැස්මක් අවශ්‍යයි.

## 🗺️ ඔබේ මාර්ගය සැලසුම් කරන්න

මාර්ග කිහිපයක් හඳුනා ගන්න:
- ආසන්නම උස් බිමට ප්‍රධාන මාර්ගය
- ද්විතීයික මාර්ගය (ප්‍රධාන මාර්ගය අවහිර වුවහොත්)
- පවුලේ අය හමුවන ස්ථානය

හොඳ ඉවත් වීමේ මාර්ගයක්:
- වෙරළෙන් **ඈතට** යයි
- **උඩුබලාට** යයි
- ජලය මත පාලම් වළකියි
- සෙනඟට ප්‍රමාණවත් තරම් පළල්ය

## 🏢 ඔබේ ආරක්ෂිත කලාප දැනගන්න

ආරක්ෂිත කලාප වර්ග:
1. **ස්වභාවික උස් බිම** - කඳු, උස් ප්‍රදේශ
2. **සිරස් ඉවත් වීමේ ගොඩනැගිලි** - උස්, ශක්තිමත් ගොඩනැගිලි
3. **නියමිත නවාතැන්** - පාසල්, විහාර, රාජ්‍ය ගොඩනැගිලි

යටවීමේ කලාප, ආරක්ෂිත ඉවත් වීමේ ස්ථාන සහ ආසන්නම ආරක්ෂිත කලාපයට දුර බැලීමට **TsunamiSense සිතියම** භාවිතා කරන්න.

## 👨‍👩‍👧‍👦 පවුල් සැලැස්ම

1. අන්තරා කලාපයෙන් පිටත **හමුවන ස්ථානයක් නියම කරන්න**
2. සියලු පවුලේ අය සමඟ **සැලැස්ම බෙදා ගන්න**
3. වසරකට අවම වශයෙන් දෙවරක් **මාර්ගය පුහුණු වන්න**
4. **වගකීම් පවරන්න** (කට්ටලය රැගෙන යන්නේ කවුද, වැඩිහිටියන්ට උදව් කරන්නේ කවුද)

## ⏱️ ඇවිදීමේ වේගය සඳහා සැලසුම් කරන්න

මාර්ග තදබදයෙන් යුක්ත විය හැක, එබැවින් පයින් ඉවත් වීමට සැලසුම් කරන්න. කි.මී. 1ක් ඇවිදීමට මිනිත්තු 12ක් පමණ ගතවේ.
''',
        quiz: [
          QuizQuestion(
            question: 'ඔබ ඔබේ ඉවත් වීමේ මාර්ගය කොපමණ වාර ගණනක් පුහුණු විය යුතුද?',
            options: [
              'ජීවිතයේ එක් වරක්',
              'සෑම මසකම',
              'වසරකට අවම වශයෙන් දෙවරක්',
              'අනතුරු ඇඟවීමකින් පසුව පමණි',
            ],
            correctIndex: 2,
            explanation: 'සෑම කෙනෙකුම කළ යුත්ත දන්නා බව සහතික කිරීමට වසරකට අවම වශයෙන් දෙවරක් ඔබේ මාර්ගය පුහුණු වන්න.',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_5',
        order: 5,
        title: 'සුනාමියෙන් පසු',
        description: 'ක්ෂණික අන්තරාව පහව ගිය පසු කළ යුතු දේ.',
        estimatedMinutes: 5,
        content: '''
# සුනාමියෙන් පසු

තරංග නැවතුණු පසුව පවා අන්තරා පවතී. ආරක්ෂිතව සිටින්නේ කෙසේද යන්න මෙන්න.

## ⏳ සියල්ල සුරක්ෂිත වන තුරු බලා සිටින්න

- බලධාරීන් **"සියල්ල සුරක්ෂිතයි"** නිවේදනය කරන තුරු **ආපසු නොයන්න**
- සුනාමි තරංග **පැය 8-12ක්** දිගටම පැවතිය හැක
- පසු තරංග බොහෝ විට පළමු තරංගයට වඩා **විශාලය**

## 🏠 නිවසට ආපසු යාම

ගොඩනැගිලිවලට ඇතුළු වීමට පෙර, මේවා පරීක්ෂා කරන්න:
- ව්‍යුහාත්මක හානි
- ගෑස් කාන්දු (ගඳ)
- විදුලි අන්තරා
- දුර්වල වූ බිම්

දූෂිත ජලය, සුන්බුන්, අස්ථායී ව්‍යුහ, බිඳ වැටුණු විදුලි රැහැන් සහ සර්පයන් වැනි අවතැන් වූ සතුන් ගැන විමසිලිමත් වන්න.

## 💧 ජල ආරක්ෂාව

- බලධාරීන් ආරක්ෂිත බව තහවුරු කරන තුරු **කරාම ජලය නොබොන්න**
- ගංවතුර ජලය දූෂිතයි - ස්පර්ශය වළකින්න
- විශ්වාස නැත්නම් ජලය නටවන්න

## 📱 සන්නිවේදනය

- ජාල භාරය අඩු කිරීමට දුරකථන ඇමතුම් කෙටියෙන් තබා ගන්න
- ඇමතුම් වෙනුවට කෙටි පණිවිඩ භාවිතා කරන්න
- ඔබේ තත්ත්වය පිළිබඳ පවුලට දැනුම් දෙන්න
- තහවුරු කළ තොරතුරු පමණක් බෙදා ගන්න; කටකතා පතුරුවා නොහරින්න

## 🤝 අන් අයට උදව් කරන්න

ඔබ ආරක්ෂිත නම්, විශේෂයෙන් වැඩිහිටි අසල්වැසියන් බලන්න, ඔබට අමතර තිබේ නම් සැපයුම් බෙදා ගන්න, අතුරුදහන් වූවන් වාර්තා කරන්න.

## 🧠 මානසික සෞඛ්‍යය

කනස්සල්ල, නින්ද නොයාම හෝ දුක දැනීම සාමාන්‍යයි. **මෙම හැඟීම් දිගටම පවතී නම් උපකාර පතන්න.** පවුලේ අය, මිතුරන් හෝ වෘත්තිකයන් සමඟ කතා කරන්න.
''',
        quiz: [
          QuizQuestion(
            question: 'සුනාමියකින් පසු නිවසට ආපසු යාම ආරක්ෂිත වන්නේ කවදාද?',
            options: [
              'පළමු තරංගයෙන් පසු',
              'පැයකට පසු',
              'බලධාරීන් "සියල්ල සුරක්ෂිතයි" යැයි පැවසූ විට',
              'ජලය ඈත් වූ විට',
            ],
            correctIndex: 2,
            explanation: 'බලධාරීන් ආරක්ෂිත බව තහවුරු කළ විට පමණක් ආපසු යන්න. තරංග පැය 8-12ක් පැවතිය හැක.',
          ),
        ],
      ),
    ];

// ---------------------------------------------------------------------------
// Tamil (தமிழ்)
// ---------------------------------------------------------------------------
List<Lesson> _lessonsTa() => [
      Lesson(
        id: 'lesson_1',
        order: 1,
        title: 'சுனாமி என்றால் என்ன?',
        description: 'சுனாமிகளுக்குப் பின்னால் உள்ள அறிவியல் மற்றும் அவை எவ்வாறு உருவாகின்றன என்பதைக் கற்றுக்கொள்ளுங்கள்.',
        estimatedMinutes: 5,
        content: '''
# சுனாமி என்றால் என்ன?

**சுனாமி** (ஜப்பானிய மொழியில்: 津波, அதாவது "துறைமுக அலை") என்பது கடலின் பெரிய அளவிலான இடையூறுகளால் ஏற்படும், மிக நீண்ட அலைநீளம் கொண்ட கடல் அலைகளின் தொடர்.

## சுனாமிகள் எவ்வாறு உருவாகின்றன

சுனாமிகள் பொதுவாக இவற்றால் ஏற்படுகின்றன:

1. **கடலடி நிலநடுக்கங்கள்** - மிகவும் பொதுவான காரணம் (சுனாமிகளில் ~80%)
2. **எரிமலை வெடிப்புகள்** - கடலடி அல்லது கடற்கரை எரிமலைகள்
3. **நிலச்சரிவுகள்** - கடலடி அல்லது கடற்கரை நிலச்சரிவுகள்
4. **விண்கல் மோதல்கள்** - அரிதானது ஆனால் சாத்தியம்

## முக்கிய உண்மைகள்

- ஆழ்கடலில் சுனாமி அலைகள் மணிக்கு **800 கி.மீ.** வேகத்தில் பயணிக்கலாம்
- திறந்த கடலில் அலைகள் 30-60 செ.மீ. உயரம் மட்டுமே இருக்கலாம்
- கரையை நெருங்கும்போது அலைகள் மெதுவாகின்றன ஆனால் **உயரத்தில் வளர்கின்றன**
- சுனாமி என்பது ஒரே அலை அல்ல, **அலைகளின் தொடர்**
- முதல் அலை பெரும்பாலும் மிகப் பெரியதல்ல

## 2004 இந்தியப் பெருங்கடல் சுனாமி

2004 டிசம்பர் 26 அன்று, இந்தோனேசியாவின் சுமாத்ரா அருகே ஏற்பட்ட 9.1 அளவு நிலநடுக்கம் இலங்கையைப் பாதித்த ஒரு பேரழிவு சுனாமியைத் தூண்டியது, 35,000 க்கும் மேற்பட்டோர் உயிரிழந்தனர்.

இந்தச் சோகம் **முன்கூட்டிய எச்சரிக்கை அமைப்புகள்** மற்றும் **பொது கல்வியின்** முக்கியத்துவத்தைக் காட்டியது.

## நினைவில் கொள்ளுங்கள்

⚠️ அருகிலுள்ள நிலநடுக்கத்திலிருந்து **சில நிமிடங்களில்** சுனாமி வரலாம், அல்லது மூலம் தொலைவில் இருந்தால் **பல மணிநேரம்** ஆகலாம்.
''',
        quiz: [
          QuizQuestion(
            question: 'சுனாமிகளுக்கு மிகவும் பொதுவான காரணம் என்ன?',
            options: [
              'எரிமலை வெடிப்புகள்',
              'கடலடி நிலநடுக்கங்கள்',
              'விண்கல் மோதல்கள்',
              'பலத்த காற்று',
            ],
            correctIndex: 1,
            explanation: 'சுனாமிகளில் ~80% கடலடி நிலநடுக்கங்களால் ஏற்படுகின்றன.',
          ),
          QuizQuestion(
            question: 'ஆழ்கடலில் சுனாமி அலைகள் எவ்வளவு வேகமாக பயணிக்கலாம்?',
            options: ['மணிக்கு 100 கி.மீ.', 'மணிக்கு 300 கி.மீ.', 'மணிக்கு 800 கி.மீ.', 'மணிக்கு 50 கி.மீ.'],
            correctIndex: 2,
            explanation: 'ஆழ்கடல் நீரில் சுனாமி அலைகள் மணிக்கு 800 கி.மீ. வேகத்தில் பயணிக்கலாம்.',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_2',
        order: 2,
        title: 'இயற்கை எச்சரிக்கை அறிகுறிகள்',
        description: 'நெருங்கும் சுனாமியின் இயற்கை எச்சரிக்கை அறிகுறிகளை அடையாளம் காணுங்கள்.',
        estimatedMinutes: 5,
        content: '''
# இயற்கை எச்சரிக்கை அறிகுறிகள்

சுனாமி வருவதற்கு முன் இயற்கை பெரும்பாலும் எச்சரிக்கை அறிகுறிகளை வழங்குகிறது. இந்த அறிகுறிகளை அறிந்திருப்பது உங்கள் உயிரைக் காப்பாற்றும்.

## 🌊 திடீர் கடல் பின்வாங்கல்

கடல் கரையிலிருந்து **வியத்தகு முறையில் பின்வாங்கி** கடற்தளத்தை வெளிப்படுத்தலாம். இது ஒரு முக்கிய எச்சரிக்கை அறிகுறி!

- வெளிப்பட்ட கடற்தளத்தைப் பார்க்கச் செல்லாதீர்கள்
- இந்த நீர் ஒரு சக்திவாய்ந்த அலையாகத் திரும்பும்
- அலை வருவதற்கு முன் உங்களிடம் **5-10 நிமிடங்கள்** மட்டுமே இருக்கலாம்

## 🌍 பலத்த நிலநடுக்கம்

கடற்கரைக்கு அருகில் இருக்கும்போது பலத்த நிலநடுக்கத்தை உணர்ந்தால்:

- அதிர்வின்போது **குனிந்து, மறைந்து, பிடித்துக் கொள்ளுங்கள்**
- அதிர்வு நின்றதும், **உடனடியாக உயரமான இடத்திற்குச் செல்லுங்கள்**
- நிலநடுக்கம் பலமாக இருந்தால் அதிகாரப்பூர்வ எச்சரிக்கைக்காகக் காத்திருக்காதீர்கள்

## 🔊 அசாதாரண ஒலிகள்

இவற்றைக் கேளுங்கள்:
- ரயில் அல்லது விமானம் போன்ற **உரத்த முழக்கம்**
- கடலில் இருந்து வரும் அசாதாரண **முழங்கும்** ஒலிகள்

## 🐟 அசாதாரண விலங்கு நடத்தை

மனிதர்களுக்கு முன் விலங்குகள் ஆபத்தை உணரலாம்:
- மீன்கள் ஒழுங்கற்ற முறையில் நீந்துதல்
- பறவைகள் உள்நாட்டை நோக்கி பறத்தல்
- நாய்கள் குரைத்தல் அல்லது அமைதியின்மை

## ⏰ நேரம் முக்கியமானது

நிலநடுக்கத்தை உணர்ந்தாலோ அல்லது கடல் அசாதாரணமாகப் பின்வாங்குவதைக் கண்டாலோ, காத்திருக்காமல் உடனடியாக உயரமான இடத்திற்குச் செல்லுங்கள்!
''',
        quiz: [
          QuizQuestion(
            question: 'கடல் திடீரெனக் கரையிலிருந்து பின்வாங்குவதைக் கண்டால் நீங்கள் என்ன செய்ய வேண்டும்?',
            options: [
              'வெளிப்பட்ட கடற்தளத்தைப் பார்க்கச் செல்லுங்கள்',
              'சமூக ஊடகங்களுக்காக புகைப்படம் எடுங்கள்',
              'உடனடியாக உயரமான இடத்திற்குச் செல்லுங்கள்',
              'அதிகாரப்பூர்வ அறிவிப்புக்காகக் காத்திருங்கள்',
            ],
            correctIndex: 2,
            explanation: 'திடீர் கடல் பின்வாங்கல் ஒரு முக்கிய சுனாமி எச்சரிக்கை அறிகுறி. உடனடியாக உயரமான இடத்திற்குச் செல்லுங்கள்!',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_3',
        order: 3,
        title: 'எச்சரிக்கை ஒலிக்கும்போது என்ன செய்வது',
        description: 'சுனாமி எச்சரிக்கை வெளியிடப்படும்போது படிப்படியான நடவடிக்கைகள்.',
        estimatedMinutes: 7,
        content: '''
# எச்சரிக்கை ஒலிக்கும்போது என்ன செய்வது

சுனாமி எச்சரிக்கையைப் பெறும்போது, **ஒவ்வொரு நொடியும் முக்கியம்**. செய்ய வேண்டியது இதோ:

## 📱 எச்சரிக்கையைப் பெறும்போது

1. **அமைதியாக இருங்கள்** - பீதி விலையுயர்ந்த நேரத்தை வீணாக்குகிறது
2. **எச்சரிக்கையை உறுதிப்படுத்துங்கள்** - முடிந்தால் அதிகாரப்பூர்வ மூலங்களைச் சரிபார்க்கவும்
3. **மற்றவர்களை எச்சரியுங்கள்** - குடும்ப உறுப்பினர்கள் மற்றும் அண்டை வீட்டாரிடம் சொல்லுங்கள்
4. **உடனடியாக வெளியேற்றத்தைத் தொடங்குங்கள்**

## 🏃 வெளியேற்ற படிகள்

### படி 1: உங்கள் அவசரப் பெட்டியை எடுத்துக் கொள்ளுங்கள்
அது தயாராக அருகில் இருந்தால் (அதிகபட்சம் 30 நொடிகள்) எடுத்துக் கொள்ளுங்கள். இல்லையெனில், **உடனே செல்லுங்கள்**.

### படி 2: உயரமான இடத்திற்குச் செல்லுங்கள்
- குறைந்தது **30 மீட்டர் (100 அடி) உயரத்திற்குச்** செல்லுங்கள்
- அல்லது **2 கி.மீ. உள்நாட்டிற்குச்** செல்லுங்கள்
- உயரமான இடம் இல்லையெனில், **வலுவூட்டப்பட்ட கான்கிரீட் கட்டிடத்தின்** மேல் தளங்களுக்குச் செல்லுங்கள்

### படி 3: குறிக்கப்பட்ட பாதைகளைப் பயன்படுத்துங்கள்
- இருந்தால் வெளியேற்றப் பாதை அடையாளங்களைப் பின்தொடரவும்
- கடற்கரைகள், துறைமுகங்கள் மற்றும் தாழ்வான கடற்கரைப் பகுதிகளைத் தவிர்க்கவும்
- **பார்க்க ஒருபோதும் கடலை நோக்கிச் செல்லாதீர்கள்**

## 🏢 செங்குத்து வெளியேற்றம்
உயரமான இடத்தை அடைய முடியாவிட்டால்:
- வலுவூட்டப்பட்ட கான்கிரீட் கட்டிடத்தின் **3வது தளம் அல்லது அதற்கு மேல்** செல்லுங்கள்
- ஜன்னல்களிலிருந்து விலகி இருங்கள்

## ⏳ எவ்வளவு நேரம் இருக்க வேண்டும்

- அதிகாரப்பூர்வ **"அபாயம் நீங்கியது"** அறிவிப்புக்காகக் காத்திருங்கள்
- அலைகள் **8-12 மணிநேரம்** தொடரலாம்
- முதல் அலை பெரும்பாலும் மிகப் பெரியதல்ல
- அதிகாரிகள் பாதுகாப்பானது என்று சொல்லும் வரை திரும்பாதீர்கள்

## ⚠️ இவற்றை ஒருபோதும் செய்யாதீர்கள்
- ❌ பார்க்க கடற்கரைக்குச் செல்வது
- ❌ மிக விரைவில் வீடு திரும்புவது
- ❌ ஒரே அலைதான் என்று கருதுவது
- ❌ வெளியேற்றத்தின்போது மின் தூக்கிகளைப் பயன்படுத்துவது
''',
        quiz: [
          QuizQuestion(
            question: 'சுனாமியிலிருந்து பாதுகாப்பாக இருக்க எவ்வளவு உயரத்திற்கு வெளியேற வேண்டும்?',
            options: [
              '5 மீட்டர் உயரம்',
              '10 மீட்டர் உயரம்',
              'குறைந்தது 30 மீட்டர் உயரம்',
              '100 மீட்டர் உயரம்',
            ],
            correctIndex: 2,
            explanation: 'நீங்கள் குறைந்தது 30 மீட்டர் (100 அடி) உயரத்திற்கு அல்லது 2 கி.மீ. உள்நாட்டிற்கு வெளியேற வேண்டும்.',
          ),
          QuizQuestion(
            question: 'உயரமான இடத்தை அடைய முடியாவிட்டால், நீங்கள் என்ன செய்ய வேண்டும்?',
            options: [
              'கடற்கரையில் இருங்கள்',
              'வலுவூட்டப்பட்ட கான்கிரீட் கட்டிடத்தின் 3வது தளம் அல்லது அதற்கு மேல் செல்லுங்கள்',
              'நிலவறையில் ஒளிந்து கொள்ளுங்கள்',
              'படகில் ஏறுங்கள்',
            ],
            correctIndex: 1,
            explanation: 'உயரமான இடம் கிடைக்காதபோது, வலுவான கட்டிடத்தின் 3வது தளம் அல்லது அதற்கு மேல் செங்குத்து வெளியேற்றம் ஒரு சரியான தேர்வாகும்.',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_4',
        order: 4,
        title: 'வெளியேற்ற அடிப்படைகள்',
        description: 'உங்கள் வெளியேற்றப் பாதையைத் திட்டமிட்டு பாதுகாப்பான மண்டலங்களை அறியுங்கள்.',
        estimatedMinutes: 6,
        content: '''
# வெளியேற்ற அடிப்படைகள்

தயார்நிலை முக்கியம். பேரழிவு ஏற்படுவதற்கு **முன்** உங்கள் வெளியேற்றப் பாதையை அறிந்து கொள்ளுங்கள்.

## 📍 உங்கள் மண்டலத்தை அறியுங்கள்

நீங்கள் சுனாமி மண்டலத்தில் இருக்கிறீர்களா எனச் சரிபார்க்கவும்:
- நீங்கள் கடற்கரையிலிருந்து 2 கி.மீ. க்குள் இருக்கிறீர்களா?
- நீங்கள் 10 மீட்டருக்குக் குறைவான உயரத்தில் இருக்கிறீர்களா?
- நீங்கள் ஆற்றுமுகம் அல்லது துறைமுகத்திற்கு அருகில் இருக்கிறீர்களா?

இவற்றில் ஏதேனும் ஒன்றுக்கு ஆம் எனில், உங்களுக்கு வெளியேற்றத் திட்டம் தேவை.

## 🗺️ உங்கள் பாதையைத் திட்டமிடுங்கள்

பல பாதைகளை அடையாளம் காணுங்கள்:
- அருகிலுள்ள உயரமான இடத்திற்கு முதன்மை பாதை
- இரண்டாம் நிலை பாதை (முதன்மை தடைபட்டால்)
- குடும்ப உறுப்பினர்கள் சந்திக்கும் இடம்

ஒரு நல்ல வெளியேற்றப் பாதை:
- கடற்கரையிலிருந்து **விலகிச்** செல்கிறது
- **மேட்டை நோக்கிச்** செல்கிறது
- நீர் மீதான பாலங்களைத் தவிர்க்கிறது
- கூட்டத்தைச் சமாளிக்கப் போதுமான அகலம் கொண்டது

## 🏢 உங்கள் பாதுகாப்பான மண்டலங்களை அறியுங்கள்

பாதுகாப்பான மண்டல வகைகள்:
1. **இயற்கை உயர்நிலம்** - மலைகள், உயரமான பகுதிகள்
2. **செங்குத்து வெளியேற்றக் கட்டிடங்கள்** - உயரமான, வலுவான கட்டிடங்கள்
3. **குறிக்கப்பட்ட தங்குமிடங்கள்** - பள்ளிகள், கோவில்கள், அரசு கட்டிடங்கள்

வெள்ளப் பகுதிகள், பாதுகாப்பான வெளியேற்றப் புள்ளிகள் மற்றும் அருகிலுள்ள பாதுகாப்பான மண்டலத்திற்கான தூரத்தைப் பார்க்க **TsunamiSense வரைபடத்தைப்** பயன்படுத்துங்கள்.

## 👨‍👩‍👧‍👦 குடும்பத் திட்டம்

1. ஆபத்து மண்டலத்திற்கு வெளியே **சந்திக்கும் இடத்தைக் குறிக்கவும்**
2. அனைத்து குடும்ப உறுப்பினர்களுடனும் **திட்டத்தைப் பகிரவும்**
3. ஆண்டுக்கு குறைந்தது இரண்டு முறை **பாதையைப் பயிற்சி செய்யவும்**
4. **பொறுப்புகளை ஒதுக்கவும்** (பெட்டியை எடுப்பவர் யார், முதியோருக்கு உதவுபவர் யார்)

## ⏱️ நடைபயணம் வேகத்திற்குத் திட்டமிடுங்கள்

சாலைகள் நெரிசலாக இருக்கலாம், எனவே கால்நடையாக வெளியேறத் திட்டமிடுங்கள். 1 கி.மீ. நடக்க சுமார் 12 நிமிடங்கள் ஆகும்.
''',
        quiz: [
          QuizQuestion(
            question: 'உங்கள் வெளியேற்றப் பாதையை எத்தனை முறை பயிற்சி செய்ய வேண்டும்?',
            options: [
              'வாழ்க்கையில் ஒரு முறை',
              'ஒவ்வொரு மாதமும்',
              'ஆண்டுக்கு குறைந்தது இரண்டு முறை',
              'எச்சரிக்கைக்குப் பிறகு மட்டும்',
            ],
            correctIndex: 2,
            explanation: 'ஒவ்வொருவரும் என்ன செய்வது என்பதை அறிய ஆண்டுக்கு குறைந்தது இரண்டு முறை உங்கள் பாதையைப் பயிற்சி செய்யுங்கள்.',
          ),
        ],
      ),
      Lesson(
        id: 'lesson_5',
        order: 5,
        title: 'சுனாமிக்குப் பிறகு',
        description: 'உடனடி ஆபத்து கடந்த பிறகு என்ன செய்வது.',
        estimatedMinutes: 5,
        content: '''
# சுனாமிக்குப் பிறகு

அலைகள் நின்ற பிறகும் ஆபத்துகள் இருக்கின்றன. பாதுகாப்பாக இருப்பது எப்படி என்பது இதோ.

## ⏳ அபாயம் நீங்கும் வரை காத்திருங்கள்

- அதிகாரிகள் **"அபாயம் நீங்கியது"** என்று அறிவிக்கும் வரை **திரும்பாதீர்கள்**
- சுனாமி அலைகள் **8-12 மணிநேரம்** தொடரலாம்
- பிந்தைய அலைகள் பெரும்பாலும் முதல் அலையை விட **பெரியவை**

## 🏠 வீடு திரும்புதல்

கட்டிடங்களுக்குள் நுழைவதற்கு முன், இவற்றைச் சரிபார்க்கவும்:
- கட்டமைப்பு சேதம்
- எரிவாயு கசிவு (வாசனை)
- மின்சார ஆபத்துகள்
- பலவீனமான தளங்கள்

மாசுபட்ட நீர், குப்பைகள், நிலையற்ற கட்டமைப்புகள், விழுந்த மின் கம்பிகள் மற்றும் பாம்புகள் போன்ற இடம்பெயர்ந்த விலங்குகள் குறித்து எச்சரிக்கையாக இருங்கள்.

## 💧 நீர் பாதுகாப்பு

- அதிகாரிகள் பாதுகாப்பானது என்று உறுதிப்படுத்தும் வரை **குழாய் நீரைக் குடிக்காதீர்கள்**
- வெள்ள நீர் மாசுபட்டது - தொடர்பைத் தவிர்க்கவும்
- உறுதியில்லையெனில் நீரைக் கொதிக்க வைக்கவும்

## 📱 தொடர்பு

- வலையமைப்பு சுமையைக் குறைக்க தொலைபேசி அழைப்புகளைக் குறுகியதாக வைக்கவும்
- அழைப்புகளுக்குப் பதிலாக குறுஞ்செய்திகளைப் பயன்படுத்துங்கள்
- உங்கள் நிலை குறித்து குடும்பத்திற்குத் தெரிவியுங்கள்
- உறுதிப்படுத்தப்பட்ட தகவலை மட்டும் பகிருங்கள்; வதந்திகளைப் பரப்பாதீர்கள்

## 🤝 மற்றவர்களுக்கு உதவுங்கள்

நீங்கள் பாதுகாப்பாக இருந்தால், குறிப்பாக முதியோர் அண்டை வீட்டாரைப் பார்க்கவும், உங்களிடம் கூடுதலாக இருந்தால் பொருட்களைப் பகிரவும், காணாமல் போனவர்களைப் புகாரளிக்கவும்.

## 🧠 மனநலம்

கவலை, தூக்கமின்மை அல்லது சோகம் உணர்வது இயல்பானது. **இந்த உணர்வுகள் தொடர்ந்தால் உதவியை நாடுங்கள்.** குடும்பத்தினர், நண்பர்கள் அல்லது நிபுணர்களிடம் பேசுங்கள்.
''',
        quiz: [
          QuizQuestion(
            question: 'சுனாமிக்குப் பிறகு வீடு திரும்புவது எப்போது பாதுகாப்பானது?',
            options: [
              'முதல் அலைக்குப் பிறகு',
              '1 மணிநேரத்திற்குப் பிறகு',
              'அதிகாரிகள் "அபாயம் நீங்கியது" என்று சொல்லும்போது',
              'நீர் வடிந்தபோது',
            ],
            correctIndex: 2,
            explanation: 'அதிகாரிகள் பாதுகாப்பானது என உறுதிப்படுத்தும்போது மட்டுமே திரும்பவும். அலைகள் 8-12 மணிநேரம் தொடரலாம்.',
          ),
        ],
      ),
    ];
