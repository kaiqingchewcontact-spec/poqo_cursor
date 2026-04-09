import 'dart:convert';

enum MoodLevel {
  awful,
  bad,
  meh,
  good,
  great;

  String get emoji {
    switch (this) {
      case MoodLevel.awful:
        return '😫';
      case MoodLevel.bad:
        return '😔';
      case MoodLevel.meh:
        return '😐';
      case MoodLevel.good:
        return '😊';
      case MoodLevel.great:
        return '🤩';
    }
  }

  String get label {
    switch (this) {
      case MoodLevel.awful:
        return 'Awful';
      case MoodLevel.bad:
        return 'Bad';
      case MoodLevel.meh:
        return 'Meh';
      case MoodLevel.good:
        return 'Good';
      case MoodLevel.great:
        return 'Great';
    }
  }

  double get value {
    switch (this) {
      case MoodLevel.awful:
        return 1.0;
      case MoodLevel.bad:
        return 2.0;
      case MoodLevel.meh:
        return 3.0;
      case MoodLevel.good:
        return 4.0;
      case MoodLevel.great:
        return 5.0;
    }
  }
}

class MoodEntry {
  final String id;
  final MoodLevel mood;
  final String? note;
  final DateTime createdAt;
  final List<String> tags;

  const MoodEntry({
    required this.id,
    required this.mood,
    this.note,
    required this.createdAt,
    this.tags = const [],
  });

  MoodEntry copyWith({
    String? id,
    MoodLevel? mood,
    String? note,
    DateTime? createdAt,
    List<String>? tags,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mood': mood.index,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
        'tags': tags,
      };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
        id: json['id'] as String,
        mood: MoodLevel.values[json['mood'] as int],
        note: json['note'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );

  String encode() => jsonEncode(toJson());
  static MoodEntry decode(String source) =>
      MoodEntry.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
