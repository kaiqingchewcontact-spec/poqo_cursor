import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../theme/app_theme.dart';

class MoodSelector extends StatelessWidget {
  final MoodLevel? selectedMood;
  final ValueChanged<MoodLevel> onMoodSelected;
  final double emojiSize;

  const MoodSelector({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
    this.emojiSize = 40,
  });

  Color _moodColor(MoodLevel mood) {
    switch (mood) {
      case MoodLevel.awful:
        return PoqoColors.moodAwful;
      case MoodLevel.bad:
        return PoqoColors.moodBad;
      case MoodLevel.meh:
        return PoqoColors.moodMeh;
      case MoodLevel.good:
        return PoqoColors.moodGood;
      case MoodLevel.great:
        return PoqoColors.moodGreat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: MoodLevel.values.map((mood) {
        final isSelected = selectedMood == mood;
        final color = _moodColor(mood);

        return GestureDetector(
          onTap: () => onMoodSelected(mood),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    mood.emoji,
                    style: TextStyle(fontSize: emojiSize),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mood.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? color
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
