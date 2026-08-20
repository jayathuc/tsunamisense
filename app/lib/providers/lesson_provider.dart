import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/lesson.dart';
import '../data/content/lesson_content.dart';

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

  /// Load lessons for the given language, carrying over completion (keyed by the
  /// stable lesson id) so a language switch never loses progress.
  Future<void> loadLessons({String lang = 'en'}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final completedIds = prefs.getStringList('completed_lessons') ?? [];

      _lessons = lessonsFor(lang).map((lesson) {
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
}
