import 'dart:convert';

enum HabitCategory {
  morning,
  focus,
  health,
  learning,
  evening,
  custom;

  String get label {
    switch (this) {
      case HabitCategory.morning:
        return 'Morning';
      case HabitCategory.focus:
        return 'Focus';
      case HabitCategory.health:
        return 'Health';
      case HabitCategory.learning:
        return 'Learning';
      case HabitCategory.evening:
        return 'Evening';
      case HabitCategory.custom:
        return 'Custom';
    }
  }

  String get icon {
    switch (this) {
      case HabitCategory.morning:
        return '🌅';
      case HabitCategory.focus:
        return '🎯';
      case HabitCategory.health:
        return '💚';
      case HabitCategory.learning:
        return '📚';
      case HabitCategory.evening:
        return '🌙';
      case HabitCategory.custom:
        return '✨';
    }
  }
}

class Habit {
  final String id;
  final String name;
  final HabitCategory category;
  final String? description;
  final DateTime createdAt;
  final bool isPremium;

  const Habit({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.createdAt,
    this.isPremium = false,
  });

  Habit copyWith({
    String? id,
    String? name,
    HabitCategory? category,
    String? description,
    DateTime? createdAt,
    bool? isPremium,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.index,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'isPremium': isPremium,
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        category: HabitCategory.values[json['category'] as int],
        description: json['description'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isPremium: json['isPremium'] as bool? ?? false,
      );

  String encode() => jsonEncode(toJson());
  static Habit decode(String source) =>
      Habit.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

class HabitCompletion {
  final String habitId;
  final DateTime date;
  final bool completed;
  final String? note;

  const HabitCompletion({
    required this.habitId,
    required this.date,
    required this.completed,
    this.note,
  });

  Map<String, dynamic> toJson() => {
        'habitId': habitId,
        'date': date.toIso8601String(),
        'completed': completed,
        'note': note,
      };

  factory HabitCompletion.fromJson(Map<String, dynamic> json) =>
      HabitCompletion(
        habitId: json['habitId'] as String,
        date: DateTime.parse(json['date'] as String),
        completed: json['completed'] as bool,
        note: json['note'] as String?,
      );
}
