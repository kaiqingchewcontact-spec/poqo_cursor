import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../theme/app_theme.dart';

class HabitTile extends ConsumerWidget {
  final Habit habit;
  final VoidCallback? onTap;

  const HabitTile({
    super.key,
    required this.habit,
    this.onTap,
  });

  Color _categoryColor() {
    switch (habit.category) {
      case HabitCategory.morning:
        return PoqoColors.categoryMorning;
      case HabitCategory.focus:
        return PoqoColors.categoryFocus;
      case HabitCategory.health:
        return PoqoColors.categoryHealth;
      case HabitCategory.learning:
        return PoqoColors.categoryLearning;
      case HabitCategory.evening:
        return PoqoColors.categoryEvening;
      case HabitCategory.custom:
        return PoqoColors.categoryCustom;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completions = ref.watch(todayCompletionsProvider);
    final isCompleted = completions[habit.id] ?? false;
    final streak = ref.read(completionsProvider.notifier).getStreak(habit.id);
    final color = _categoryColor();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        ref
            .read(completionsProvider.notifier)
            .toggleCompletion(habit.id, DateTime.now());
      },
      onLongPress: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isCompleted
              ? color.withValues(alpha: 0.08)
              : theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? color.withValues(alpha: 0.3)
                : theme.dividerTheme.color ?? Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCompleted
                      ? color
                      : color.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check_rounded,
                      size: 18, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                      color: isCompleted
                          ? theme.colorScheme.onSurface
                              .withValues(alpha: 0.5)
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (habit.description != null &&
                      habit.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        habit.description!,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            if (streak > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department_rounded,
                        size: 14, color: color),
                    const SizedBox(width: 3),
                    Text(
                      '$streak',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 4),
            Text(
              habit.category.icon,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
