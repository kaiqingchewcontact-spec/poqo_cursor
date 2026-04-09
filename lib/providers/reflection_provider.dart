import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/reflection.dart';
import '../utils/date_utils.dart';
import 'storage_provider.dart';
import 'user_provider.dart';

final reflectionsProvider =
    StateNotifierProvider<ReflectionsNotifier, List<Reflection>>((ref) {
  return ReflectionsNotifier(ref);
});

final todayReflectionProvider = Provider<Reflection?>((ref) {
  final reflections = ref.watch(reflectionsProvider);
  final today = DateTime.now().dateOnly;
  try {
    return reflections.lastWhere((r) => r.createdAt.dateOnly.isSameDay(today));
  } catch (_) {
    return null;
  }
});

final dailyPromptProvider = Provider<ReflectionPrompt>((ref) {
  final user = ref.watch(userProfileProvider);
  final available = defaultPrompts
      .where((p) => !p.isPremium || user.hasAccess)
      .toList();
  final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
  return available[dayOfYear % available.length];
});

class ReflectionsNotifier extends StateNotifier<List<Reflection>> {
  final Ref _ref;

  ReflectionsNotifier(this._ref)
      : super(_ref.read(storageServiceProvider).getReflections());

  Future<void> addReflection({
    required String prompt,
    required String response,
    bool isPremiumPrompt = false,
  }) async {
    final today = DateTime.now().dateOnly;
    final existingIndex =
        state.indexWhere((r) => r.createdAt.dateOnly.isSameDay(today));

    final reflection = Reflection(
      id: existingIndex >= 0 ? state[existingIndex].id : const Uuid().v4(),
      prompt: prompt,
      response: response,
      createdAt: DateTime.now(),
      isPremiumPrompt: isPremiumPrompt,
    );

    if (existingIndex >= 0) {
      final updated = [...state];
      updated[existingIndex] = reflection;
      state = updated;
    } else {
      state = [...state, reflection];
    }
    await _ref.read(storageServiceProvider).saveReflections(state);
  }

  Future<void> removeReflection(String id) async {
    state = state.where((r) => r.id != id).toList();
    await _ref.read(storageServiceProvider).saveReflections(state);
  }
}
