import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/lesson.dart';

/// Provider for education module lessons
class LessonProvider extends ChangeNotifier {
  List<Lesson> _lessons = [];
  bool _isLoading = false;
  String? _error;

  List<Lesson> get lessons => _lessons;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get completed lessons count
  int get completedCount => _lessons.where((l) => l.isCompleted).length;

  /// Get total lessons count
  int get totalCount => _lessons.length;

  /// Get completion percentage
  double get completionPercentage {
    if (_lessons.isEmpty) return 0;
    return completedCount / totalCount;
  }

  /// Initialize lessons with default content
  Future<void> loadLessons() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load completion status from preferences
      final prefs = await SharedPreferences.getInstance();
      final completedIds = prefs.getStringList('completed_lessons') ?? [];

      // Initialize default lessons
      _lessons = _getDefaultLessons().map((lesson) {
        return lesson.copyWith(
          isCompleted: completedIds.contains(lesson.id),
        );
      }).toList();

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mark a lesson as completed
  Future<void> markLessonCompleted(String lessonId) async {
    final index = _lessons.indexWhere((l) => l.id == lessonId);
    if (index == -1) return;

    _lessons[index] = _lessons[index].copyWith(isCompleted: true);
    notifyListeners();

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    final completedIds = _lessons
        .where((l) => l.isCompleted)
        .map((l) => l.id)
        .toList();
    await prefs.setStringList('completed_lessons', completedIds);
  }

  /// Reset all progress
  Future<void> resetProgress() async {
    _lessons = _lessons.map((l) => l.copyWith(isCompleted: false)).toList();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('completed_lessons');
  }

  /// Get default lessons content
  List<Lesson> _getDefaultLessons() {
    return [
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
            options: [
              '100 km/h',
              '300 km/h',
              '800 km/h',
              '50 km/h',
            ],
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

| Distance from Earthquake | Time to Prepare |
|-------------------------|-----------------|
| Local (< 100 km) | Minutes |
| Regional (100-1000 km) | 1-2 hours |
| Distant (> 1000 km) | Several hours |

## Golden Rule

**If you feel an earthquake OR see the ocean recede unusually, don't wait - move to high ground immediately!**
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

## 🚗 If Driving
- Drive calmly away from the coast
- Avoid bridges over water
- If stuck in traffic, abandon vehicle and proceed on foot

## 🏢 Vertical Evacuation
If you cannot reach high ground:
- Go to the **3rd floor or higher** of a reinforced concrete building
- Stay away from windows
- Multi-story hotels, schools, and hospitals are often designated safe buildings

## ⏳ How Long to Stay

- Wait for **official "all clear"** announcement
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

### Check if You're in a Tsunami Zone
- Are you within 2 km of the coast?
- Are you at elevation less than 10 meters?
- Are you near a river mouth or harbor?

If YES to any of these, you need an evacuation plan.

## 🗺️ Plan Your Route

### Identify Multiple Routes
- Primary route to nearest high ground
- Secondary route (in case primary is blocked)
- Meeting point for family members

### What Makes a Good Evacuation Route?
✅ Leads AWAY from the coast
✅ Goes UPHILL
✅ Avoids bridges over water
✅ Wide enough to handle crowds
✅ Accessible (consider elderly, disabled)

## 🏢 Know Your Safe Zones

### Types of Safe Zones:
1. **Natural High Ground** - Hills, elevated areas
2. **Vertical Evacuation Buildings** - Tall, strong buildings
3. **Designated Shelters** - Schools, temples, government buildings

### In Galle District:
Use the **TsunamiSense Map** feature to see:
- Tsunami inundation zones (danger areas)
- Safe evacuation points
- Distance to nearest safe zone

## 👨‍👩‍👧‍👦 Family Plan

1. **Designate a meeting point** outside the danger zone
2. **Share the plan** with all family members
3. **Practice the route** at least twice a year
4. **Assign responsibilities** (who grabs the emergency kit, who helps elderly)

## ⏱️ Time Estimates

| Method | Speed | 1 km takes |
|--------|-------|------------|
| Walking | 5 km/h | 12 minutes |
| Running | 10 km/h | 6 minutes |
| Driving | 30 km/h | 2 minutes |

**Plan for walking speed** - roads may be congested!

## 🎯 Practice Makes Perfect

- Walk your evacuation route regularly
- Time yourself
- Note any obstacles or hazards
- Update your plan if conditions change
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

### Before Entering Buildings:
- Check for structural damage
- Look for gas leaks (smell)
- Check for electrical hazards
- Watch for weakened floors

### Hazards to Watch For:
- Contaminated water
- Debris and sharp objects
- Unstable structures
- Downed power lines
- Displaced wildlife (snakes, etc.)

## 💧 Water Safety

- **Don't drink tap water** until authorities confirm it's safe
- Floodwater is contaminated - avoid contact
- Boil water if unsure

## 🆘 If You Need Help

- Call emergency services
- Go to designated relief centers
- Register with authorities so family can find you

## 📱 Communication

- Keep phone calls short to reduce network load
- Use text messages instead of calls
- Update family on your status
- Check social media for official updates

## 🤝 Help Others

If you're safe, consider helping:
- Check on neighbors, especially elderly
- Share supplies if you have extra
- Report missing persons
- Don't spread rumors - only share verified information

## 🧠 Mental Health

It's normal to feel:
- Anxiety
- Difficulty sleeping
- Flashbacks
- Sadness or anger

**Seek help if these feelings persist.** Talk to family, friends, or professionals.

## 📝 Document Damage

For insurance and aid:
- Take photos of damage
- Keep receipts for emergency purchases
- List damaged or lost items

## 🔄 Review and Improve

After the event:
- What worked well?
- What could be improved?
- Update your emergency kit
- Review your evacuation plan
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
  }
}
