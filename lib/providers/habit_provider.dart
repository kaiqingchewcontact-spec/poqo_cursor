import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../utils/date_utils.dart';
import 'storage_provider.dart';
import 'user_provider.dart';

const int freeHabitLimit = 3;

final habitsProvider =
    StateNotifierProvider<HabitsNotifier, List<Habit>>((ref) {
  return HabitsNotifier(ref);
});

final completionsProvider =
    StateNotifierProvider<CompletionsNotifier, List<HabitCompletion>>((ref) {
  return CompletionsNotifier(ref);
});

final todayCompletionsProvider = Provider<Map<String, bool>>((ref) {
  final completions = ref.watch(completionsProvider);
  final today = DateTime.now().dateOnly;
  final map = <String, bool>{};
  for (final c in completions) {
    if (c.date.dateOnly.isSameDay(today)) {
      map[c.habitId] = c.completed;
    }
  }
  return map;
});

final todayProgressProvider = Provider<double>((ref) {
  final habits = ref.watch(habitsProvider);
  final completions = ref.watch(todayCompletionsProvider);
  if (habits.isEmpty) return 0.0;
  final completed = habits.where((h) => completions[h.id] == true).length;
  return completed / habits.length;
});

final canAddHabitProvider = Provider<bool>((ref) {
  final user = ref.watch(userProfileProvider);
  final habits = ref.watch(habitsProvider);
  return user.hasAccess || habits.length < freeHabitLimit;
});

class HabitsNotifier extends StateNotifier<List<Habit>> {
  final Ref _ref;

  HabitsNotifier(this._ref)
      : super(_ref.read(storageServiceProvider).getHabits());

  Future<void> addHabit({
    required String name,
    required HabitCategory category,
    String? description,
  }) async {
    final habit = Habit(
      id: const Uuid().v4(),
      name: name,
      category: category,
      description: description,
      createdAt: DateTime.now(),
    );
    state = [...state, habit];
    await _ref.read(storageServiceProvider).saveHabits(state);
  }

  Future<void> updateHabit(Habit updated) async {
    state = state.map((h) => h.id == updated.id ? updated : h).toList();
    await _ref.read(storageServiceProvider).saveHabits(state);
  }

  Future<void> removeHabit(String id) async {
    state = state.where((h) => h.id != id).toList();
    await _ref.read(storageServiceProvider).saveHabits(state);
  }

  Future<void> reorderHabits(int oldIndex, int newIndex) async {
    final items = [...state];
    final item = items.removeAt(oldIndex);
    items.insert(newIndex < oldIndex ? newIndex : newIndex - 1, item);
    state = items;
    await _ref.read(storageServiceProvider).saveHabits(state);
  }
}

class CompletionsNotifier extends StateNotifier<List<HabitCompletion>> {
  final Ref _ref;

  CompletionsNotifier(this._ref)
      : super(_ref.read(storageServiceProvider).getCompletions());

  Future<void> toggleCompletion(String habitId, DateTime date) async {
    final dateOnly = date.dateOnly;
    final existing = state.indexWhere(
      (c) => c.habitId == habitId && c.date.dateOnly.isSameDay(dateOnly),
    );

    if (existing >= 0) {
      final current = state[existing];
      final updated = [...state];
      updated[existing] = HabitCompletion(
        habitId: habitId,
        date: dateOnly,
        completed: !current.completed,
      );
      state = updated;
    } else {
      state = [
        ...state,
        HabitCompletion(
          habitId: habitId,
          date: dateOnly,
          completed: true,
        ),
      ];
    }
    await _ref.read(storageServiceProvider).saveCompletions(state);
  }

  int getCompletionCount(String habitId, {int days = 7}) {
    final cutoff = DateTime.now().subtract(Duration(days: days)).dateOnly;
    return state
        .where(
          (c) =>
              c.habitId == habitId &&
              c.completed &&
              c.date.isAfter(cutoff),
        )
        .length;
  }

  int getStreak(String habitId) {
    final completions = state
        .where((c) => c.habitId == habitId && c.completed)
        .map((c) => c.date.dateOnly)
        .toSet();

    int streak = 0;
    var day = DateTime.now().dateOnly;
    while (completions.any((d) => d.isSameDay(day))) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }
}
