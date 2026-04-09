import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../theme/app_theme.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  final Habit? editHabit;

  const AddHabitScreen({super.key, this.editHabit});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late HabitCategory _selectedCategory;
  bool get _isEditing => widget.editHabit != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.editHabit?.name ?? '');
    _descController =
        TextEditingController(text: widget.editHabit?.description ?? '');
    _selectedCategory = widget.editHabit?.category ?? HabitCategory.morning;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Habit' : 'New Habit'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded,
                  color: PoqoColors.errorLight),
              onPressed: _deleteHabit,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What habit do you want to build?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'e.g., Drink water, Read 10 pages',
                label: Text('Habit name'),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _descController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Optional description or goal',
                label: Text('Description'),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: HabitCategory.values.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text('${cat.icon}  ${cat.label}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedCategory = cat);
                    }
                  },
                  selectedColor:
                      theme.colorScheme.primary.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Suggestion chips
            if (!_isEditing) ...[
              Text(
                'Quick suggestions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestions.map((s) {
                  return ActionChip(
                    label: Text(s),
                    onPressed: () {
                      _nameController.text = s;
                      setState(() {});
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveHabit,
                child: Text(_isEditing ? 'Save Changes' : 'Add Habit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveHabit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
      );
      return;
    }

    if (_isEditing) {
      ref.read(habitsProvider.notifier).updateHabit(
            widget.editHabit!.copyWith(
              name: name,
              category: _selectedCategory,
              description: _descController.text.trim().isEmpty
                  ? null
                  : _descController.text.trim(),
            ),
          );
    } else {
      ref.read(habitsProvider.notifier).addHabit(
            name: name,
            category: _selectedCategory,
            description: _descController.text.trim().isEmpty
                ? null
                : _descController.text.trim(),
          );
    }

    Navigator.pop(context);
  }

  void _deleteHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Remove "${widget.editHabit!.name}" from your habits?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(habitsProvider.notifier)
                  .removeHabit(widget.editHabit!.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: PoqoColors.errorLight),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static const _suggestions = [
    'Drink 8 glasses of water',
    'Read for 15 minutes',
    'Meditate for 5 minutes',
    'Go for a walk',
    'Write in journal',
    'No phone first hour',
    'Stretch for 5 minutes',
    'Healthy breakfast',
    'Practice gratitude',
    'Learn something new',
  ];
}
