import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_entry.dart';
import '../providers/habit_provider.dart';
import '../providers/mood_provider.dart';
import '../providers/reflection_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';
import '../widgets/section_header.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider);
    final completions = ref.watch(completionsProvider);
    final moodEntries = ref.watch(moodEntriesProvider);
    final reflections = ref.watch(reflectionsProvider);
    final user = ref.watch(userProfileProvider);
    final theme = Theme.of(context);

    final last7 = DateTime.now().last7Days;
    final totalCompletionsThisWeek = completions
        .where((c) =>
            c.completed &&
            last7.any((d) => d.isSameDay(c.date.dateOnly)))
        .length;
    final possibleThisWeek = habits.length * 7;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '7-day overview',
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 24),

              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.check_circle_outline_rounded,
                      label: 'Completions',
                      value: '$totalCompletionsThisWeek',
                      subtitle:
                          possibleThisWeek > 0
                              ? 'of $possibleThisWeek possible'
                              : 'this week',
                      color: PoqoColors.successLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.emoji_emotions_outlined,
                      label: 'Mood Logs',
                      value: '${moodEntries.where((e) => last7.any((d) => d.isSameDay(e.createdAt.dateOnly))).length}',
                      subtitle: 'this week',
                      color: PoqoColors.categoryMorning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Best Streak',
                      value: habits.isEmpty
                          ? '0'
                          : '${habits.map((h) => ref.read(completionsProvider.notifier).getStreak(h.id)).fold<int>(0, max)}',
                      subtitle: 'days',
                      color: PoqoColors.secondaryLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.edit_note_rounded,
                      label: 'Reflections',
                      value: '${reflections.length}',
                      subtitle: 'total entries',
                      color: PoqoColors.categoryEvening,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Habit heatmap (7-day)
              const SectionHeader(title: 'Habit Completion'),
              if (habits.isEmpty)
                _EmptyState(message: 'Add habits to see your completion data')
              else
                _WeeklyHeatmap(
                  habits: habits,
                  completions: completions,
                  days: last7,
                ),
              const SizedBox(height: 28),

              // Mood chart
              const SectionHeader(title: 'Mood Trend'),
              if (moodEntries.isEmpty)
                _EmptyState(message: 'Log your mood to see trends')
              else
                _MoodChart(entries: moodEntries, days: last7),
              const SizedBox(height: 28),

              // Premium insights teaser
              if (!user.hasAccess) ...[
                _PremiumInsightsCard(),
              ],

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color:
                  theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyHeatmap extends StatelessWidget {
  final List<dynamic> habits;
  final List<dynamic> completions;
  final List<DateTime> days;

  const _WeeklyHeatmap({
    required this.habits,
    required this.completions,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // Day headers
          Row(
            children: [
              const SizedBox(width: 80),
              ...days.map((d) => Expanded(
                    child: Center(
                      child: Text(
                        d.dayOfWeekShort,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: d.isSameDay(DateTime.now().dateOnly)
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 8),
          // Habit rows
          ...habits.map((habit) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        habit.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...days.map((d) {
                      final completed = completions.any(
                        (c) =>
                            c.habitId == habit.id &&
                            c.completed &&
                            c.date.dateOnly.isSameDay(d),
                      );
                      return Expanded(
                        child: Center(
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: completed
                                  ? PoqoColors.successLight
                                      .withValues(alpha: 0.8)
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: completed
                                ? const Icon(Icons.check_rounded,
                                    size: 14, color: Colors.white)
                                : null,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _MoodChart extends StatelessWidget {
  final List<MoodEntry> entries;
  final List<DateTime> days;

  const _MoodChart({required this.entries, required this.days});

  Color _moodColor(double value) {
    if (value <= 1.5) return PoqoColors.moodAwful;
    if (value <= 2.5) return PoqoColors.moodBad;
    if (value <= 3.5) return PoqoColors.moodMeh;
    if (value <= 4.5) return PoqoColors.moodGood;
    return PoqoColors.moodGreat;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: days.map((d) {
                final dayEntries = entries
                    .where((e) => e.createdAt.dateOnly.isSameDay(d))
                    .toList();
                final avgMood = dayEntries.isEmpty
                    ? 0.0
                    : dayEntries.fold<double>(
                            0, (acc, e) => acc + e.mood.value) /
                        dayEntries.length;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (dayEntries.isNotEmpty)
                          Text(
                            dayEntries.last.mood.emoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: avgMood > 0 ? (avgMood / 5) * 70 : 4,
                          decoration: BoxDecoration(
                            color: avgMood > 0
                                ? _moodColor(avgMood)
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          d.dayOfWeekShort,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: d.isSameDay(DateTime.now().dateOnly)
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.grey.shade200,
        ),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color:
              theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _PremiumInsightsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [PoqoColors.primaryLight, PoqoColors.secondaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded,
                  size: 22, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Premium Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Unlock weekly and monthly heatmaps, correlation insights, and AI-powered suggestions.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Upgrade for \$5/month',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
