import 'package:flutter/material.dart';
import '../models/daily_task.dart';
import '../models/player.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final Player player;
  final List<DailyTask> tasks;
  final VoidCallback onDataChanged;

  const SettingsScreen({super.key, required this.player, required this.tasks, required this.onDataChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _save() async {
    await StorageService.savePlayer(widget.player);
    await StorageService.saveTasks(widget.tasks);
    widget.onDataChanged();
    if (mounted) setState(() {});
  }

  Future<void> _editUsername() async {
    final controller = TextEditingController(text: widget.player.username);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('ชื่อผู้ใช้', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('บันทึก')),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      widget.player.username = result.trim();
      await _save();
    }
  }

  Future<void> _editDailyGoal() async {
    final controller = TextEditingController(text: widget.player.dailyGoalXp.toString());
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('เป้าหมาย XP ต่อวัน', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('บันทึก')),
        ],
      ),
    );
    final value = int.tryParse(result ?? '');
    if (value != null && value > 0) {
      widget.player.dailyGoalXp = value;
      await _save();
    }
  }

  Future<void> _editTask(DailyTask task) async {
    final titleC = TextEditingController(text: task.title);
    final descC = TextEditingController(text: task.description);
    final xpC = TextEditingController(text: task.xpReward.toString());

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('แก้ไข Quest', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleC,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'ชื่อกิจกรรม')),
            TextField(
                controller: descC,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'คำอธิบาย')),
            TextField(
                controller: xpC,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'XP')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ยกเลิก')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('บันทึก')),
        ],
      ),
    );

    if (result == true) {
      final idx = widget.tasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) {
        widget.tasks[idx] = task.copyWith(
          title: titleC.text.trim().isEmpty ? task.title : titleC.text.trim(),
          description: descC.text.trim(),
          xpReward: int.tryParse(xpC.text) ?? task.xpReward,
        );
      }
      await _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel('บัญชี'),
          _tile(title: 'ชื่อผู้ใช้', subtitle: widget.player.username, onTap: _editUsername),
          _tile(title: 'เป้าหมาย XP ต่อวัน', subtitle: '${widget.player.dailyGoalXp} XP', onTap: _editDailyGoal),
          const SizedBox(height: 20),
          _sectionLabel('Daily Activities'),
          ...widget.tasks.map((task) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: ListTile(
                  leading: Text(task.icon, style: const TextStyle(fontSize: 22)),
                  title: Text(task.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('+${task.xpReward} XP · ${task.category}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: task.isEnabled,
                        activeThumbColor: AppColors.red,
                        onChanged: (v) async {
                          task.isEnabled = v;
                          await _save();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.textSecondary, size: 20),
                        onPressed: () => _editTask(task),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text.toUpperCase(),
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 1.5)),
      );

  Widget _tile({required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
