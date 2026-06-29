import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/checklist.dart';
import '../data/content/checklist_content.dart';

/// Provider for preparedness checklist
class ChecklistProvider extends ChangeNotifier {
  UserChecklist? _checklist;
  bool _isLoading = false;
  String? _error;

  UserChecklist? get checklist => _checklist;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get overall completion percentage
  double get completionPercentage => _checklist?.overallCompletion ?? 0;

  /// Get all categories
  List<ChecklistCategory> get categories => _checklist?.categories ?? [];

  /// Get total items count
  int get totalItemsCount => _checklist?.totalItems ?? 0;

  /// Get completed items count
  int get completedItemsCount => _checklist?.completedItems ?? 0;

  String _lang = 'en';

  /// Load the checklist for [lang], rebuilding the template in that language but
  /// carrying over the user's checked/note state (and any custom items) by the
  /// stable category/item ids, so a language switch never loses progress.
  Future<void> loadChecklist({String lang = 'en'}) async {
    _lang = lang;
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('user_checklist');
      final saved = savedData != null
          ? UserChecklist.fromJson(json.decode(savedData) as Map<String, dynamic>)
          : null;

      _checklist = _buildForLanguage(lang, saved);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _checklist = _getDefaultChecklist();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    // Persist so the stored copy matches the active language.
    await _saveChecklist();
  }

  /// Build the checklist for [lang] from the content template, overlaying any
  /// saved checked/note/lastChecked state and re-appending user-added items.
  UserChecklist _buildForLanguage(String lang, UserChecklist? saved) {
    final state = <String, ChecklistItem>{};
    final customByCategory = <String, List<ChecklistItem>>{};
    if (saved != null) {
      for (final cat in saved.categories) {
        for (final it in cat.items) {
          state['${cat.id}/${it.id}'] = it;
          if (it.id.startsWith('custom_')) {
            (customByCategory[cat.id] ??= []).add(it);
          }
        }
      }
    }

    final categories = categoriesFor(lang).map((cat) {
      final items = cat.items.map((tmpl) {
        final prev = state['${cat.id}/${tmpl.id}'];
        if (prev == null) return tmpl;
        return tmpl.copyWith(
          isChecked: prev.isChecked,
          lastChecked: prev.lastChecked,
          note: prev.note,
        );
      }).toList();
      final customs = customByCategory[cat.id];
      if (customs != null) items.addAll(customs);
      return ChecklistCategory(
        id: cat.id,
        name: cat.name,
        icon: cat.icon,
        items: items,
      );
    }).toList();

    return UserChecklist(categories: categories, lastUpdated: DateTime.now());
  }

  /// Toggle a checklist item
  Future<void> toggleItem(String categoryId, String itemId) async {
    if (_checklist == null) return;

    final categories = _checklist!.categories.map((category) {
      if (category.id != categoryId) return category;

      final items = category.items.map((item) {
        if (item.id != itemId) return item;
        return item.copyWith(
          isChecked: !item.isChecked,
          lastChecked: !item.isChecked ? DateTime.now() : item.lastChecked,
        );
      }).toList();

      return ChecklistCategory(
        id: category.id,
        name: category.name,
        icon: category.icon,
        items: items,
      );
    }).toList();

    _checklist = UserChecklist(
      categories: categories,
      lastUpdated: DateTime.now(),
    );

    notifyListeners();
    await _saveChecklist();
  }

  /// Reset all items
  Future<void> resetChecklist() async {
    _checklist = _getDefaultChecklist();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_checklist');
  }

  /// Update item note
  Future<void> updateItemNote(String categoryId, String itemId, String? note) async {
    if (_checklist == null) return;

    final categories = _checklist!.categories.map((category) {
      if (category.id != categoryId) return category;

      final items = category.items.map((item) {
        if (item.id != itemId) return item;
        return item.copyWith(note: note);
      }).toList();

      return ChecklistCategory(
        id: category.id,
        name: category.name,
        icon: category.icon,
        items: items,
      );
    }).toList();

    _checklist = UserChecklist(
      categories: categories,
      lastUpdated: DateTime.now(),
    );

    notifyListeners();
    await _saveChecklist();
  }

  /// Add a custom item to a category
  Future<void> addCustomItem(String categoryId, String title) async {
    if (_checklist == null) return;

    final categories = _checklist!.categories.map((category) {
      if (category.id != categoryId) return category;

      final items = List<ChecklistItem>.from(category.items);
      items.add(ChecklistItem(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
      ));

      return ChecklistCategory(
        id: category.id,
        name: category.name,
        icon: category.icon,
        items: items,
      );
    }).toList();

    _checklist = UserChecklist(
      categories: categories,
      lastUpdated: DateTime.now(),
    );

    notifyListeners();
    await _saveChecklist();
  }

  /// Save checklist to storage
  Future<void> _saveChecklist() async {
    if (_checklist == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'user_checklist',
      json.encode(_checklist!.toJson()),
    );
  }

  /// Get items that need attention (reminders due)
  List<ChecklistItem> get itemsNeedingAttention {
    if (_checklist == null) return [];

    final items = <ChecklistItem>[];
    for (final category in _checklist!.categories) {
      for (final item in category.items) {
        if (!item.isChecked || item.isReminderDue) {
          items.add(item);
        }
      }
    }
    return items;
  }

  /// Create the default (unstarted) checklist in the active language.
  UserChecklist _getDefaultChecklist() => UserChecklist(
        categories: categoriesFor(_lang),
        lastUpdated: DateTime.now(),
      );

  /// Generate summary for PDF export
  Map<String, dynamic> getSummaryForExport() {
    if (_checklist == null) {
      return {'error': 'No checklist loaded'};
    }

    return {
      'generatedAt': DateTime.now().toIso8601String(),
      'overallCompletion': '${(completionPercentage * 100).toStringAsFixed(0)}%',
      'totalItems': _checklist!.totalItems,
      'completedItems': _checklist!.completedItems,
      'categories': _checklist!.categories.map((cat) => {
        'name': cat.name,
        'completion': '${(cat.completionPercentage * 100).toStringAsFixed(0)}%',
        'items': cat.items.map((item) => {
          'title': item.title,
          'description': item.description,
          'checked': item.isChecked,
        }).toList(),
      }).toList(),
    };
  }
}
