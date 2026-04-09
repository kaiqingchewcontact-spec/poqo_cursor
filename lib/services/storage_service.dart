import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';
import '../models/mood_entry.dart';
import '../models/reflection.dart';
import '../models/user_profile.dart';

class StorageService {
  static const String _habitsKey = 'poqo_habits';
  static const String _completionsKey = 'poqo_completions';
  static const String _moodEntriesKey = 'poqo_mood_entries';
  static const String _reflectionsKey = 'poqo_reflections';
  static const String _userProfileKey = 'poqo_user_profile';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Habits
  List<Habit> getHabits() {
    final data = _prefs.getStringList(_habitsKey) ?? [];
    return data.map((e) => Habit.decode(e)).toList();
  }

  Future<void> saveHabits(List<Habit> habits) async {
    await _prefs.setStringList(
      _habitsKey,
      habits.map((e) => e.encode()).toList(),
    );
  }

  // Completions
  List<HabitCompletion> getCompletions() {
    final data = _prefs.getStringList(_completionsKey) ?? [];
    return data
        .map((e) =>
            HabitCompletion.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCompletions(List<HabitCompletion> completions) async {
    await _prefs.setStringList(
      _completionsKey,
      completions.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  // Mood entries
  List<MoodEntry> getMoodEntries() {
    final data = _prefs.getStringList(_moodEntriesKey) ?? [];
    return data.map((e) => MoodEntry.decode(e)).toList();
  }

  Future<void> saveMoodEntries(List<MoodEntry> entries) async {
    await _prefs.setStringList(
      _moodEntriesKey,
      entries.map((e) => e.encode()).toList(),
    );
  }

  // Reflections
  List<Reflection> getReflections() {
    final data = _prefs.getStringList(_reflectionsKey) ?? [];
    return data.map((e) => Reflection.decode(e)).toList();
  }

  Future<void> saveReflections(List<Reflection> reflections) async {
    await _prefs.setStringList(
      _reflectionsKey,
      reflections.map((e) => e.encode()).toList(),
    );
  }

  // User profile
  UserProfile? getUserProfile() {
    final data = _prefs.getString(_userProfileKey);
    if (data == null) return null;
    return UserProfile.decode(data);
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _prefs.setString(_userProfileKey, profile.encode());
  }

  // Export all data as JSON
  String exportAllData() {
    return jsonEncode({
      'habits': getHabits().map((e) => e.toJson()).toList(),
      'completions': getCompletions().map((e) => e.toJson()).toList(),
      'moodEntries': getMoodEntries().map((e) => e.toJson()).toList(),
      'reflections': getReflections().map((e) => e.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    });
  }
}
