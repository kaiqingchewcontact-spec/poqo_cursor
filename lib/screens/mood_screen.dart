import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_entry.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_selector.dart';

class MoodScreen extends ConsumerStatefulWidget {
  const MoodScreen({super.key});

  @override
  ConsumerState<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends ConsumerState<MoodScreen> {
  MoodLevel? _selectedMood;
  final _noteController = TextEditingController();
  final List<String> _selectedTags = [];

  static const _moodTags = [
    'Energetic',
    'Calm',
    'Stressed',
    'Focused',
    'Tired',
    'Happy',
    'Anxious',
    'Grateful',
    'Motivated',
    'Relaxed',
    'Creative',
    'Restless',
  ];

  @override
  void initState() {
    super.initState();
    final todayMood = ref.read(todayMoodProvider);
    if (todayMood != null) {
      _selectedMood = todayMood.mood;
      _noteController.text = todayMood.note ?? '';
      _selectedTags.addAll(todayMood.tags);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you?'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How are you feeling right now?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Be honest — there are no wrong answers.',
              style: TextStyle(
                fontSize: 15,
                color:
                    theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 28),

            MoodSelector(
              selectedMood: _selectedMood,
              onMoodSelected: (mood) {
                setState(() => _selectedMood = mood);
              },
            ),
            const SizedBox(height: 28),

            AnimatedOpacity(
              opacity: _selectedMood != null ? 1.0 : 0.3,
              duration: const Duration(milliseconds: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add a note (optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    enabled: _selectedMood != null,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind?',
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Tags',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _moodTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: _selectedMood != null
                            ? (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedTags.add(tag);
                                  } else {
                                    _selectedTags.remove(tag);
                                  }
                                });
                              }
                            : null,
                        selectedColor: theme.colorScheme.primary
                            .withValues(alpha: 0.15),
                        checkmarkColor: theme.colorScheme.primary,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _selectedMood != null ? _saveMoodEntry : null,
                      child: const Text('Save Mood'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMoodEntry() {
    if (_selectedMood == null) return;

    ref.read(moodEntriesProvider.notifier).addMoodEntry(
          mood: _selectedMood!,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          tags: _selectedTags,
        );

    Navigator.pop(context);
  }
}
