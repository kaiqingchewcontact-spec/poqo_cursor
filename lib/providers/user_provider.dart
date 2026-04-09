import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/user_profile.dart';
import 'storage_provider.dart';

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier(ref);
});

class UserProfileNotifier extends StateNotifier<UserProfile> {
  final Ref _ref;

  UserProfileNotifier(this._ref) : super(_loadOrCreate(_ref));

  static UserProfile _loadOrCreate(Ref ref) {
    final storage = ref.read(storageServiceProvider);
    final existing = storage.getUserProfile();
    if (existing != null) return existing;

    final profile = UserProfile(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
    );
    storage.saveUserProfile(profile);
    return profile;
  }

  Future<void> toggleDarkMode() async {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
    await _ref.read(storageServiceProvider).saveUserProfile(state);
  }

  Future<void> updateTier(SubscriptionTier tier) async {
    state = state.copyWith(
      tier: tier,
      subscriptionStartDate:
          tier != SubscriptionTier.free ? DateTime.now() : null,
    );
    await _ref.read(storageServiceProvider).saveUserProfile(state);
  }

  Future<void> startTrial() async {
    state = state.copyWith(
      trialEndDate: DateTime.now().add(const Duration(days: 14)),
    );
    await _ref.read(storageServiceProvider).saveUserProfile(state);
  }

  Future<void> toggleNotifications() async {
    state = state.copyWith(
      notificationsEnabled: !state.notificationsEnabled,
    );
    await _ref.read(storageServiceProvider).saveUserProfile(state);
  }

  Future<void> setReminderTime(String time) async {
    state = state.copyWith(reminderTime: time);
    await _ref.read(storageServiceProvider).saveUserProfile(state);
  }
}
