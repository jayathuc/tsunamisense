import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/checklist.dart';

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

  /// Load checklist from storage or create default
  Future<void> loadChecklist() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('user_checklist');

      if (savedData != null) {
        _checklist = UserChecklist.fromJson(
          json.decode(savedData) as Map<String, dynamic>,
        );
      } else {
        _checklist = _getDefaultChecklist();
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      _checklist = _getDefaultChecklist();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  /// Create default checklist
  UserChecklist _getDefaultChecklist() {
    return UserChecklist(
      categories: [
        ChecklistCategory(
          id: 'emergency_kit',
          name: 'Emergency Kit',
          icon: 'backpack',
          items: [
            ChecklistItem(
              id: 'water',
              title: 'Drinking Water',
              description: 'At least 3 liters per person for 3 days',
              reminderDays: 180, // Check every 6 months
            ),
            ChecklistItem(
              id: 'food',
              title: 'Non-perishable Food',
              description: 'Canned goods, dry foods, energy bars for 3 days',
              reminderDays: 180,
            ),
            ChecklistItem(
              id: 'first_aid',
              title: 'First Aid Kit',
              description: 'Bandages, antiseptic, pain relievers, any personal medications',
              reminderDays: 365,
            ),
            ChecklistItem(
              id: 'flashlight',
              title: 'Flashlight & Batteries',
              description: 'LED flashlight with extra batteries',
              reminderDays: 180,
            ),
            ChecklistItem(
              id: 'radio',
              title: 'Battery/Crank Radio',
              description: 'To receive emergency broadcasts',
              reminderDays: 365,
            ),
            ChecklistItem(
              id: 'phone_charger',
              title: 'Phone Charger / Power Bank',
              description: 'Fully charged power bank',
              reminderDays: 30,
            ),
            ChecklistItem(
              id: 'cash',
              title: 'Cash (Small Bills)',
              description: 'ATMs may not work after disaster',
            ),
            ChecklistItem(
              id: 'documents',
              title: 'Important Documents',
              description: 'Copies of ID, insurance, bank details in waterproof bag',
            ),
            ChecklistItem(
              id: 'medications',
              title: 'Personal Medications',
              description: 'At least 7-day supply of essential medications',
              reminderDays: 90,
            ),
            ChecklistItem(
              id: 'whistle',
              title: 'Whistle',
              description: 'To signal for help if trapped',
            ),
          ],
        ),
        ChecklistCategory(
          id: 'family_plan',
          name: 'Family Plan',
          icon: 'family_restroom',
          items: [
            ChecklistItem(
              id: 'meeting_point',
              title: 'Meeting Point Identified',
              description: 'A safe location where family members will reunite',
            ),
            ChecklistItem(
              id: 'contacts',
              title: 'Emergency Contacts Saved',
              description: 'Family contacts saved and memorized',
            ),
            ChecklistItem(
              id: 'route_known',
              title: 'Evacuation Route Known',
              description: 'Everyone knows the primary evacuation route',
            ),
            ChecklistItem(
              id: 'route_practiced',
              title: 'Evacuation Route Practiced',
              description: 'Family has walked the evacuation route together',
              reminderDays: 180,
            ),
            ChecklistItem(
              id: 'responsibilities',
              title: 'Responsibilities Assigned',
              description: 'Who grabs what, who helps whom',
            ),
            ChecklistItem(
              id: 'out_of_area_contact',
              title: 'Out-of-Area Contact',
              description: 'A relative/friend outside the area to coordinate through',
            ),
          ],
        ),
        ChecklistCategory(
          id: 'home_safety',
          name: 'Home Safety',
          icon: 'home',
          items: [
            ChecklistItem(
              id: 'kit_location',
              title: 'Emergency Kit Location Known',
              description: 'Kit is in an accessible location known to all',
            ),
            ChecklistItem(
              id: 'shoes_ready',
              title: 'Sturdy Shoes Ready',
              description: 'Shoes near bed for quick evacuation (debris protection)',
            ),
            ChecklistItem(
              id: 'phone_charged',
              title: 'Phone Charged at Night',
              description: 'Keep phone charged, especially at night',
            ),
            ChecklistItem(
              id: 'insurance',
              title: 'Insurance Reviewed',
              description: 'Home/contents insurance covers natural disasters',
              reminderDays: 365,
            ),
          ],
        ),
        ChecklistCategory(
          id: 'knowledge',
          name: 'Knowledge & Skills',
          icon: 'school',
          items: [
            ChecklistItem(
              id: 'warning_signs',
              title: 'Know Natural Warning Signs',
              description: 'Can recognize earthquake, ocean withdrawal, etc.',
            ),
            ChecklistItem(
              id: 'first_aid_training',
              title: 'Basic First Aid Knowledge',
              description: 'Know CPR, wound care, recovery position',
            ),
            ChecklistItem(
              id: 'safe_zones',
              title: 'Know Nearby Safe Zones',
              description: 'Can identify at least 2 nearby evacuation points',
            ),
            ChecklistItem(
              id: 'app_notifications',
              title: 'App Notifications Enabled',
              description: 'TsunamiSense notifications are turned on',
            ),
          ],
        ),
      ],
      lastUpdated: DateTime.now(),
    );
  }

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
