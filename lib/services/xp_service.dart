import '../models/player.dart';

class LevelUpResult {
  final bool leveledUp;
  final int levelsGained;
  final int newLevel;
  LevelUpResult(this.leveledUp, this.levelsGained, this.newLevel);
}

/// All XP / Level math lives here so it stays easy to test in isolation.
class XpService {
  /// XP required to go from [level] to [level + 1].
  /// Formula: 125 * 2^(level-1)
  ///
  /// Uses a bit-shift instead of `pow()` and clamps the shift amount so a
  /// pathologically high level (which should never realistically happen)
  /// can never overflow Dart's 64-bit int.
  static int requiredXpForLevel(int level) {
    const maxSafeShift = 50; // 125 * 2^50 is still far inside the 64-bit range
    final shift = (level - 1).clamp(0, maxSafeShift);
    return 125 * (1 << shift);
  }

  /// Adds [xpGained] to the player, rolling over as many levels as needed.
  /// Excess XP is always carried into the next level - it is never lost.
  static LevelUpResult addXp(Player player, int xpGained) {
    if (xpGained <= 0) return LevelUpResult(false, 0, player.level);

    player.totalXp += xpGained;
    player.todayXp += xpGained;
    player.currentLevelXp += xpGained;

    int levelsGained = 0;
    while (player.currentLevelXp >= requiredXpForLevel(player.level)) {
      player.currentLevelXp -= requiredXpForLevel(player.level);
      player.level += 1;
      levelsGained++;
    }

    return LevelUpResult(levelsGained > 0, levelsGained, player.level);
  }

  /// 0.0 - 1.0 fill ratio of the current level's progress bar.
  static double progressRatio(Player player) {
    final required = requiredXpForLevel(player.level);
    if (required == 0) return 0;
    return (player.currentLevelXp / required).clamp(0.0, 1.0);
  }
}
