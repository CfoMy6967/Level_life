import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_task.dart';
import '../models/player.dart';
import '../models/skill.dart';

/// One archived day, used to compute weekly/monthly stats.
class HistoryEntry {
  final String date; // yyyy-MM-dd
  final int xp;
  final int questsCompleted;

  HistoryEntry({required this.date, required this.xp, required this.questsCompleted});

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        date: json['date'],
        xp: json['xp'] ?? 0,
        questsCompleted: json['questsCompleted'] ?? 0,
      );

  Map<String, dynamic> toJson() => {'date': date, 'xp': xp, 'questsCompleted': questsCompleted};
}

/// All persistence goes through here (SharedPreferences, key-value JSON).
/// Nothing about Level or Total XP is ever cleared by a daily reset.
class StorageService {
  static const _kPlayer = 'life_leveling_player';
  static const _kTasks = 'life_leveling_tasks';
  static const _kSkills = 'life_leveling_skills';
  static const _kHistory = 'life_leveling_history';

  static String todayString() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static Future<Player> loadPlayer() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPlayer);
    if (raw == null) return Player(lastActiveDate: todayString());
    return Player.fromJson(jsonDecode(raw));
  }

  static Future<void> savePlayer(Player player) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPlayer, jsonEncode(player.toJson()));
  }

  static Future<List<DailyTask>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kTasks);
    if (raw == null) return defaultDailyTasks();
    final list = jsonDecode(raw) as List;
    return list.map((e) => DailyTask.fromJson(e)).toList();
  }

  static Future<void> saveTasks(List<DailyTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTasks, jsonEncode(tasks.map((e) => e.toJson()).toList()));
  }

  static Future<List<SkillXp>> loadSkills() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kSkills);
    if (raw == null) return defaultSkills();
    final list = jsonDecode(raw) as List;
    return list.map((e) => SkillXp.fromJson(e)).toList();
  }

  static Future<void> saveSkills(List<SkillXp> skills) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSkills, jsonEncode(skills.map((e) => e.toJson()).toList()));
  }

  static Future<List<HistoryEntry>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kHistory);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => HistoryEntry.fromJson(e)).toList();
  }

  static Future<void> saveHistory(List<HistoryEntry> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kHistory, jsonEncode(history.map((e) => e.toJson()).toList()));
  }
}
