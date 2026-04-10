import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'mood_screen.dart';
import 'reflection_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  /// 0 = Home, 1 = Stats, 2 = Settings
  int _pageIndex = 0;

  static const _pages = [
    HomeScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _showQuickLogSheet(context),
        elevation: 2,
        child: const Icon(Icons.add_rounded, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _DockNavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    selected: _pageIndex == 0,
                    onTap: () => setState(() => _pageIndex = 0),
                  ),
                  _DockNavItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Stats',
                    selected: _pageIndex == 1,
                    onTap: () => setState(() => _pageIndex = 1),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 72),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _DockNavItem(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    selected: _pageIndex == 2,
                    onTap: () => setState(() => _pageIndex = 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickLogSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          8,
          24,
          24 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quick log',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Log mood or a short reflection in one tap.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: schemeOnSurfaceMuted(theme),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _QuickLogOption(
                    icon: Icons.emoji_emotions_rounded,
                    label: 'Mood',
                    color: PoqoColors.categoryMorning,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const MoodScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickLogOption(
                    icon: Icons.edit_note_rounded,
                    label: 'Reflection',
                    color: PoqoColors.categoryEvening,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const ReflectionScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color schemeOnSurfaceMuted(ThemeData theme) =>
    theme.colorScheme.onSurface.withValues(alpha: 0.55);

class _DockNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DockNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : schemeOnSurfaceMuted(theme);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLogOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickLogOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.22)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
