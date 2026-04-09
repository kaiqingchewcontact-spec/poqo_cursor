import 'dart:convert';

class Reflection {
  final String id;
  final String prompt;
  final String response;
  final DateTime createdAt;
  final bool isPremiumPrompt;

  const Reflection({
    required this.id,
    required this.prompt,
    required this.response,
    required this.createdAt,
    this.isPremiumPrompt = false,
  });

  Reflection copyWith({
    String? id,
    String? prompt,
    String? response,
    DateTime? createdAt,
    bool? isPremiumPrompt,
  }) {
    return Reflection(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
      createdAt: createdAt ?? this.createdAt,
      isPremiumPrompt: isPremiumPrompt ?? this.isPremiumPrompt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'prompt': prompt,
        'response': response,
        'createdAt': createdAt.toIso8601String(),
        'isPremiumPrompt': isPremiumPrompt,
      };

  factory Reflection.fromJson(Map<String, dynamic> json) => Reflection(
        id: json['id'] as String,
        prompt: json['prompt'] as String,
        response: json['response'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isPremiumPrompt: json['isPremiumPrompt'] as bool? ?? false,
      );

  String encode() => jsonEncode(toJson());
  static Reflection decode(String source) =>
      Reflection.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

class ReflectionPrompt {
  final String text;
  final bool isPremium;

  const ReflectionPrompt({required this.text, this.isPremium = false});
}

const List<ReflectionPrompt> defaultPrompts = [
  ReflectionPrompt(text: "What's one thing you're grateful for today?"),
  ReflectionPrompt(text: "What small win did you have today?"),
  ReflectionPrompt(text: "How did you take care of yourself today?"),
  ReflectionPrompt(text: "What's one thing you'd like to do differently tomorrow?"),
  ReflectionPrompt(text: "What moment brought you joy today?"),
  ReflectionPrompt(text: "What challenged you today, and how did you handle it?"),
  ReflectionPrompt(text: "What's one thing you learned today?"),
  ReflectionPrompt(
    text: "If you could describe your energy today in one word, what would it be?",
    isPremium: true,
  ),
  ReflectionPrompt(
    text: "What habit felt most natural today? What made it easy?",
    isPremium: true,
  ),
  ReflectionPrompt(
    text: "Describe a moment of calm you experienced today.",
    isPremium: true,
  ),
  ReflectionPrompt(
    text: "What would your ideal tomorrow look like?",
    isPremium: true,
  ),
  ReflectionPrompt(
    text: "What patterns do you notice in your mood this week?",
    isPremium: true,
  ),
];
