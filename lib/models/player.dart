/// The player's persistent RPG state.
/// `currentLevelXp` is the XP accumulated *inside* the current level only
/// (never the cumulative total) so level math never has to be re-derived
/// from a huge cumulative number.
class Player {
  String username;
  int level;
  int currentLevelXp;
  int totalXp;
  int todayXp;
  int streak;
  String lastActiveDate; // yyyy-MM-dd
  int dailyGoalXp;

  Player({
    this.username = 'Player',
    this.level = 1,
    this.currentLevelXp = 0,
    this.totalXp = 0,
    this.todayXp = 0,
    this.streak = 0,
    required this.lastActiveDate,
    this.dailyGoalXp = 100,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        username: json['username'] ?? 'Player',
        level: json['level'] ?? 1,
        currentLevelXp: json['currentLevelXp'] ?? 0,
        totalXp: json['totalXp'] ?? 0,
        todayXp: json['todayXp'] ?? 0,
        streak: json['streak'] ?? 0,
        lastActiveDate: json['lastActiveDate'],
        dailyGoalXp: json['dailyGoalXp'] ?? 100,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'level': level,
        'currentLevelXp': currentLevelXp,
        'totalXp': totalXp,
        'todayXp': todayXp,
        'streak': streak,
        'lastActiveDate': lastActiveDate,
        'dailyGoalXp': dailyGoalXp,
      };
}
