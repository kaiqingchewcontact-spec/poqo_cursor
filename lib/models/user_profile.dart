import 'dart:convert';

enum SubscriptionTier { free, premium, lifetime }

class UserProfile {
  final String id;
  final SubscriptionTier tier;
  final DateTime? subscriptionStartDate;
  final DateTime? trialEndDate;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String? reminderTime;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    this.tier = SubscriptionTier.free,
    this.subscriptionStartDate,
    this.trialEndDate,
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.reminderTime,
    required this.createdAt,
  });

  bool get isPremium =>
      tier == SubscriptionTier.premium || tier == SubscriptionTier.lifetime;

  bool get isInTrial {
    if (trialEndDate == null) return false;
    return DateTime.now().isBefore(trialEndDate!);
  }

  bool get hasAccess => isPremium || isInTrial;

  UserProfile copyWith({
    String? id,
    SubscriptionTier? tier,
    DateTime? subscriptionStartDate,
    DateTime? trialEndDate,
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? reminderTime,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      tier: tier ?? this.tier,
      subscriptionStartDate:
          subscriptionStartDate ?? this.subscriptionStartDate,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tier': tier.index,
        'subscriptionStartDate': subscriptionStartDate?.toIso8601String(),
        'trialEndDate': trialEndDate?.toIso8601String(),
        'isDarkMode': isDarkMode,
        'notificationsEnabled': notificationsEnabled,
        'reminderTime': reminderTime,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        tier: SubscriptionTier.values[json['tier'] as int],
        subscriptionStartDate: json['subscriptionStartDate'] != null
            ? DateTime.parse(json['subscriptionStartDate'] as String)
            : null,
        trialEndDate: json['trialEndDate'] != null
            ? DateTime.parse(json['trialEndDate'] as String)
            : null,
        isDarkMode: json['isDarkMode'] as bool? ?? false,
        notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
        reminderTime: json['reminderTime'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  String encode() => jsonEncode(toJson());
  static UserProfile decode(String source) =>
      UserProfile.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
