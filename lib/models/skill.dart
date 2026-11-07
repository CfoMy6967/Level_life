/// Tracks cumulative XP earned in one skill category (e.g. Coding, Fitness).
class SkillXp {
  final String name;
  final String icon;
  int xp;

  SkillXp({required this.name, required this.icon, this.xp = 0});

  factory SkillXp.fromJson(Map<String, dynamic> json) => SkillXp(
        name: json['name'],
        icon: json['icon'] ?? '⭐',
        xp: json['xp'] ?? 0,
      );

  Map<String, dynamic> toJson() => {'name': name, 'icon': icon, 'xp': xp};
}

List<SkillXp> defaultSkills() {
  return [
    SkillXp(name: 'Coding', icon: '💻'),
    SkillXp(name: 'Chinese', icon: '🇨🇳'),
    SkillXp(name: 'English', icon: '🇬🇧'),
    SkillXp(name: 'Fitness', icon: '💪'),
    SkillXp(name: 'Discipline', icon: '🧱'),
    SkillXp(name: 'Study', icon: '📚'),
    SkillXp(name: 'Law', icon: '⚖️'),
    SkillXp(name: 'Trading', icon: '📊'),
  ];
}
