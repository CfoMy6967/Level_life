import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../theme/app_theme.dart';

class SkillsScreen extends StatelessWidget {
  final List<SkillXp> skills;

  const SkillsScreen({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧠 Skills')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: skills.length,
        itemBuilder: (context, i) {
          final s = skills[i];
          // Flavor-only skill level: every 100 XP in a skill = +1 skill level.
          final level = (s.xp / 100).floor() + 1;
          final progress = (s.xp % 100) / 100;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(s.icon, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(s.name,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Text('Lv.$level', style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.black54,
                    valueColor: const AlwaysStoppedAnimation(AppColors.magenta),
                  ),
                ),
                const SizedBox(height: 6),
                Text('${s.xp} XP รวม', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
