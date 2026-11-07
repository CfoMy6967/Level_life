import 'package:flutter/material.dart';
import 'models/daily_task.dart';
import 'models/player.dart';
import 'models/skill.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'screens/today_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/skills_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const LifeLevelingApp());
}

class LifeLevelingApp extends StatelessWidget {
  const LifeLevelingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Leveling',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const RootShell(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  bool _loading = true;
  int _navIndex = 0;

  late Player _player;
  late List<DailyTask> _tasks;
  late List<SkillXp> _skills;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final player = await StorageService.loadPlayer();
    final tasks = await StorageService.loadTasks();
    final skills = await StorageService.loadSkills();

    await _handleDailyReset(player, tasks);

    setState(() {
      _player = player;
      _tasks = tasks;
      _skills = skills;
      _loading = false;
    });
  }

  /// Resets only the day's completed Quests & today's XP counter when the
  /// calendar date changes. Level and Total XP are NEVER touched here.
  Future<void> _handleDailyReset(Player player, List<DailyTask> tasks) async {
    final today = StorageService.todayString();
    if (player.lastActiveDate == today) return;

    final completedCount = tasks.where((t) => t.isCompleted).length;

    final history = await StorageService.loadHistory();
    history.add(HistoryEntry(date: player.lastActiveDate, xp: player.todayXp, questsCompleted: completedCount));
    await StorageService.saveHistory(history);

    // Streak continues only if at least one quest was completed yesterday.
    player.streak = completedCount > 0 ? player.streak + 1 : 0;

    player.todayXp = 0;
    player.lastActiveDate = today;
    for (final t in tasks) {
      t.isCompleted = false;
    }

    await StorageService.savePlayer(player);
    await StorageService.saveTasks(tasks);
  }

  void _onDataChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.red)),
      );
    }

    final screens = [
      TodayScreen(player: _player, tasks: _tasks, skills: _skills, onDataChanged: _onDataChanged),
      StatsScreen(player: _player, tasks: _tasks),
      SkillsScreen(skills: _skills),
      SettingsScreen(player: _player, tasks: _tasks, onDataChanged: _onDataChanged),
    ];

    return Scaffold(
      body: screens[_navIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Text('⚔️', style: TextStyle(fontSize: 20)), label: 'Today'),
          BottomNavigationBarItem(icon: Text('📊', style: TextStyle(fontSize: 20)), label: 'Stats'),
          BottomNavigationBarItem(icon: Text('🧠', style: TextStyle(fontSize: 20)), label: 'Skills'),
          BottomNavigationBarItem(icon: Text('⚙️', style: TextStyle(fontSize: 20)), label: 'Settings'),
        ],
      ),
    );
  }
}
