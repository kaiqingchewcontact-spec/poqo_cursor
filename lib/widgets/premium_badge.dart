import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PremiumBadge extends StatelessWidget {
  final double fontSize;

  const PremiumBadge({super.key, this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [PoqoColors.primaryLight, PoqoColors.secondaryLight],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'PRO',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class PremiumGate extends StatelessWidget {
  final bool isPremium;
  final Widget child;
  final VoidCallback onUpgrade;

  const PremiumGate({
    super.key,
    required this.isPremium,
    required this.child,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    if (isPremium) return child;

    return GestureDetector(
      onTap: onUpgrade,
      child: Stack(
        children: [
          Opacity(opacity: 0.4, child: AbsorbPointer(child: child)),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [PoqoColors.primaryLight, PoqoColors.secondaryLight],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_rounded, size: 12, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Upgrade',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
