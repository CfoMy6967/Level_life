import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/xp_service.dart';
import '../theme/app_theme.dart';

class LevelBar extends StatelessWidget {
  final Player player;
  final bool leveledUp;

  const LevelBar({super.key, required this.player, this.leveledUp = false});

  @override
  Widget build(BuildContext context) {
    final required = XpService.requiredXpForLevel(player.level);
    final ratio = XpService.progressRatio(player);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: leveledUp ? AppColors.orange : AppColors.cardBorder,
          width: leveledUp ? 2 : 1,
        ),
        boxShadow: leveledUp
            ? [BoxShadow(color: AppColors.orange.withValues(alpha: 0.6), blurRadius: 24, spreadRadius: 2)]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedScale(
            scale: leveledUp ? 1.08 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Text(
              'LEVEL ${player.level}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 16,
              child: Stack(
                children: [
                  Container(color: Colors.black54),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: ratio),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) {
                      return FractionallySizedBox(
                        widthFactor: value,
                        child: Container(decoration: const BoxDecoration(gradient: AppColors.xpGradient)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${player.currentLevelXp} / $required XP',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
