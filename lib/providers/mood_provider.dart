import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/mood_entry.dart';
import '../utils/date_utils.dart';
import 'storage_provider.dart';

final moodEntriesProvider =
    StateNotifierProvider<MoodEntriesNotifier, List<MoodEntry>>((ref) {
  return MoodEntriesNotifier(ref);
});

final todayMoodProvider = Provider<MoodEntry?>((ref) {
  final entries = ref.watch(moodEntriesProvider);
  final today = DateTime.now().dateOnly;
  try {
    return entries.lastWhere((e) => e.createdAt.dateOnly.isSameDay(today));
  } catch (_) {
    return null;
  }
});

final weekMoodProvider = Provider<List<MoodEntry>>((ref) {
  final entries = ref.watch(moodEntriesProvider);
  final cutoff = DateTime.now().subtract(const Duration(days: 7)).dateOnly;
  return entries.where((e) => e.createdAt.isAfter(cutoff)).toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
});

final averageMoodProvider = Provider<double?>((ref) {
  final weekMoods = ref.watch(weekMoodProvider);
  if (weekMoods.isEmpty) return null;
  final sum = weekMoods.fold<double>(0, (acc, e) => acc + e.mood.value);
  return sum / weekMoods.length;
});

class MoodEntriesNotifier extends StateNotifier<List<MoodEntry>> {
  final Ref _ref;

  MoodEntriesNotifier(this._ref)
      : super(_ref.read(storageServiceProvider).getMoodEntries());

  Future<void> addMoodEntry({
    required MoodLevel mood,
    String? note,
    List<String> tags = const [],
  }) async {
    final today = DateTime.now().dateOnly;
    final existingIndex =
        state.indexWhere((e) => e.createdAt.dateOnly.isSameDay(today));

    final entry = MoodEntry(
      id: existingIndex >= 0 ? state[existingIndex].id : const Uuid().v4(),
      mood: mood,
      note: note,
      createdAt: DateTime.now(),
      tags: tags,
    );

    if (existingIndex >= 0) {
      final updated = [...state];
      updated[existingIndex] = entry;
      state = updated;
    } else {
      state = [...state, entry];
    }
    await _ref.read(storageServiceProvider).saveMoodEntries(state);
  }

  Future<void> removeMoodEntry(String id) async {
    state = state.where((e) => e.id != id).toList();
    await _ref.read(storageServiceProvider).saveMoodEntries(state);
  }
}
