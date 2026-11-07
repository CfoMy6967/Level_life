import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/daily_task.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class StatsScreen extends StatefulWidget {
  final Player player;
  final List<DailyTask> tasks;

  const StatsScreen({super.key, required this.player, required this.tasks});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<HistoryEntry> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final h = await StorageService.loadHistory();
    if (mounted) setState(() => _history = h);
  }

  int _sumLastNDays(int n) {
    final cutoff = DateTime.now().subtract(Duration(days: n));
    final fromHistory = _history
        .where((h) => (DateTime.tryParse(h.date)?.isAfter(cutoff)) ?? false)
        .fold<int>(0, (sum, h) => sum + h.xp);
    return fromHistory + widget.player.todayXp;
  }

  @override
  Widget build(BuildContext context) {
    final completedToday = widget.tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      appBar: AppBar(title: const Text('📊 Stats')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _statCard('LEVEL', '${widget.player.level}', AppColors.red),
          _statCard('Total XP', '${widget.player.totalXp}', AppColors.orange),
          _statCard('XP วันนี้', '${widget.player.todayXp}', AppColors.magenta),
          _statCard('XP รายสัปดาห์ (7 วัน)', '${_sumLastNDays(7)}', AppColors.red),
          _statCard('XP รายเดือน (30 วัน)', '${_sumLastNDays(30)}', AppColors.orange),
          _statCard('Quest ที่ทำวันนี้', '$completedToday / ${widget.tasks.length}', AppColors.magenta),
          _statCard('🔥 Streak', '${widget.player.streak} วัน', AppColors.red),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color accent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: accent, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
