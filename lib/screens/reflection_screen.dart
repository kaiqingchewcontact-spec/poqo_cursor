import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reflection_provider.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart';

class ReflectionScreen extends ConsumerStatefulWidget {
  const ReflectionScreen({super.key});

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  late TextEditingController _responseController;

  @override
  void initState() {
    super.initState();
    final todayReflection = ref.read(todayReflectionProvider);
    _responseController =
        TextEditingController(text: todayReflection?.response ?? '');
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prompt = ref.watch(dailyPromptProvider);
    final reflections = ref.watch(reflectionsProvider);
    final pastReflections = reflections
        .where(
            (r) => !r.createdAt.dateOnly.isSameDay(DateTime.now().dateOnly))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflect'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    PoqoColors.categoryEvening.withValues(alpha: 0.1),
                    theme.colorScheme.primary.withValues(alpha: 0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('💭', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Text(
                        'Today\'s Prompt',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: PoqoColors.categoryEvening,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    prompt.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _responseController,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Write your thoughts here...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveReflection,
                child: const Text('Save Reflection'),
              ),
            ),

            if (pastReflections.isNotEmpty) ...[
              const SizedBox(height: 36),
              const Text(
                'Past Reflections',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...pastReflections.take(10).map((r) => _PastReflectionTile(
                    prompt: r.prompt,
                    response: r.response,
                    date: r.createdAt,
                  )),
            ],
          ],
        ),
      ),
    );
  }

  void _saveReflection() {
    final response = _responseController.text.trim();
    if (response.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write something to save your reflection')),
      );
      return;
    }

    final prompt = ref.read(dailyPromptProvider);
    ref.read(reflectionsProvider.notifier).addReflection(
          prompt: prompt.text,
          response: response,
          isPremiumPrompt: prompt.isPremium,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reflection saved ✨'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }
}

class _PastReflectionTile extends StatelessWidget {
  final String prompt;
  final String response;
  final DateTime date;

  const _PastReflectionTile({
    required this.prompt,
    required this.response,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                date.shortDate,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PoqoColors.categoryEvening,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            prompt,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color:
                  theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            response,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
