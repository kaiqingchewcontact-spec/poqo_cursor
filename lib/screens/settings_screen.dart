import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/legal_urls.dart';
import '../models/user_profile.dart';
import '../providers/user_provider.dart';
import '../providers/storage_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_badge.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String? _appVersion;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) {
        setState(() => _appVersion = '${info.version} (${info.buildNumber})');
      }
    });
  }

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),

              _SubscriptionCard(user: user),
              const SizedBox(height: 24),

              _SettingsSection(
                title: 'Appearance',
                children: [
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: Switch.adaptive(
                      value: user.isDarkMode,
                      onChanged: (_) {
                        ref
                            .read(userProfileProvider.notifier)
                            .toggleDarkMode();
                      },
                      activeTrackColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _SettingsSection(
                title: 'Reminders',
                children: [
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Daily Reminder',
                    trailing: Switch.adaptive(
                      value: user.notificationsEnabled,
                      onChanged: (_) {
                        ref
                            .read(userProfileProvider.notifier)
                            .toggleNotifications();
                      },
                      activeTrackColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _SettingsSection(
                title: 'Data',
                children: [
                  _SettingsTile(
                    icon: Icons.download_outlined,
                    title: 'Export Data',
                    subtitle: 'Download all your data as JSON',
                    onTap: () {
                      final data = ref
                          .read(storageServiceProvider)
                          .exportAllData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Data exported (${data.length} bytes)',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _SettingsSection(
                title: 'About',
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Poqo',
                    subtitle: _appVersion ?? 'Loading version…',
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () => _openExternalUrl(kPrivacyPolicyUrl),
                  ),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () => _openExternalUrl(kTermsOfServiceUrl),
                  ),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubscriptionCard extends ConsumerWidget {
  final UserProfile user;

  const _SubscriptionCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isPremium = user.hasAccess;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isPremium
            ? const LinearGradient(
                colors: [PoqoColors.primaryLight, PoqoColors.secondaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPremium ? null : theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: isPremium
            ? null
            : Border.all(
                color: theme.dividerTheme.color ?? Colors.grey.shade200,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPremium
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: isPremium ? Colors.white : theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isPremium ? 'Premium Active' : 'Free Plan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isPremium
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                ),
              ),
              if (isPremium) ...[
                const SizedBox(width: 8),
                const PremiumBadge(),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isPremium
                ? 'You have access to all premium features.'
                : 'Upgrade for unlimited habits, AI insights, and more.',
            style: TextStyle(
              fontSize: 14,
              color: isPremium
                  ? Colors.white70
                  : theme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              height: 1.4,
            ),
          ),
          if (user.isInTrial) ...[
            const SizedBox(height: 6),
            Text(
              'Trial ends ${user.trialEndDate?.difference(DateTime.now()).inDays ?? 0} days from now',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
          if (!isPremium) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(userProfileProvider.notifier)
                          .updateTier(SubscriptionTier.premium);
                    },
                    child: const Text('\$5/month'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref
                          .read(userProfileProvider.notifier)
                          .updateTier(SubscriptionTier.lifetime);
                    },
                    child: const Text('\$49/year'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  ref.read(userProfileProvider.notifier).startTrial();
                },
                child: Text(
                  'Start 14-day free trial',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ] else if (user.tier != SubscriptionTier.lifetime) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                ref
                    .read(userProfileProvider.notifier)
                    .updateTier(SubscriptionTier.free);
              },
              child: Text(
                'Manage subscription',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isPremium
                      ? Colors.white.withValues(alpha: 0.8)
                      : theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color:
                  theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.dividerTheme.color ?? Colors.grey.shade200,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.3),
              ),
          ],
        ),
      ),
    );
  }
}
