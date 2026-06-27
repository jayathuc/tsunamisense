/// Checklist model for preparedness tracking
class ChecklistCategory {
  final String id;
  final String name;
  final String icon;
  final List<ChecklistItem> items;

  ChecklistCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.items,
  });

  factory ChecklistCategory.fromJson(Map<String, dynamic> json) {
    return ChecklistCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      items: (json['items'] as List<dynamic>)
          .map((i) => ChecklistItem.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'items': items.map((i) => i.toJson()).toList(),
  };

  /// Calculate completion percentage
  double get completionPercentage {
    if (items.isEmpty) return 0;
    final completed = items.where((i) => i.isChecked).length;
    return completed / items.length;
  }

  /// Get completed count
  int get completedCount => items.where((i) => i.isChecked).length;
}

/// Individual checklist item
class ChecklistItem {
  final String id;
  final String title;
  final String? description;
  final bool isChecked;
  final DateTime? lastChecked;
  final int? reminderDays; // Days after which to remind to check
  final String? note;
  final bool isRequired;

  ChecklistItem({
    required this.id,
    required this.title,
    this.description,
    this.isChecked = false,
    this.lastChecked,
    this.reminderDays,
    this.note,
    this.isRequired = false,
  });

  // Alias for name to match UI expectations
  String get name => title;
  
  // Alias for isCompleted to match UI expectations
  bool get isCompleted => isChecked;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isChecked: json['isChecked'] as bool? ?? false,
      lastChecked: json['lastChecked'] != null
          ? DateTime.parse(json['lastChecked'] as String)
          : null,
      reminderDays: json['reminderDays'] as int?,
      note: json['note'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isChecked': isChecked,
    'lastChecked': lastChecked?.toIso8601String(),
    'reminderDays': reminderDays,
    'note': note,
    'isRequired': isRequired,
  };

  ChecklistItem copyWith({
    bool? isChecked,
    DateTime? lastChecked,
    String? note,
  }) {
    return ChecklistItem(
      id: id,
      title: title,
      description: description,
      isChecked: isChecked ?? this.isChecked,
      lastChecked: lastChecked ?? this.lastChecked,
      reminderDays: reminderDays,
      note: note ?? this.note,
      isRequired: isRequired,
    );
  }

  /// Check if reminder is due
  bool get isReminderDue {
    if (reminderDays == null || lastChecked == null) return false;
    final daysSinceCheck = DateTime.now().difference(lastChecked!).inDays;
    return daysSinceCheck >= reminderDays!;
  }
}

/// User's complete checklist state
class UserChecklist {
  final List<ChecklistCategory> categories;
  final DateTime? lastUpdated;

  UserChecklist({
    required this.categories,
    this.lastUpdated,
  });

  factory UserChecklist.fromJson(Map<String, dynamic> json) {
    return UserChecklist(
      categories: (json['categories'] as List<dynamic>)
          .map((c) => ChecklistCategory.fromJson(c as Map<String, dynamic>))
          .toList(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'categories': categories.map((c) => c.toJson()).toList(),
    'lastUpdated': lastUpdated?.toIso8601String(),
  };

  /// Calculate overall completion percentage
  double get overallCompletion {
    if (categories.isEmpty) return 0;
    final totalItems = categories.fold<int>(
      0, (sum, cat) => sum + cat.items.length,
    );
    if (totalItems == 0) return 0;
    final completedItems = categories.fold<int>(
      0, (sum, cat) => sum + cat.completedCount,
    );
    return completedItems / totalItems;
  }

  /// Get total items count
  int get totalItems => categories.fold<int>(
    0, (sum, cat) => sum + cat.items.length,
  );

  /// Get completed items count
  int get completedItems => categories.fold<int>(
    0, (sum, cat) => sum + cat.completedCount,
  );
}
