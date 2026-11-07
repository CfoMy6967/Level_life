import 'package:flutter/material.dart';
import '../models/daily_task.dart';
import '../models/player.dart';
import '../models/skill.dart';
import '../services/storage_service.dart';
import '../services/xp_service.dart';
import '../theme/app_theme.dart';
import '../widgets/level_bar.dart';
import '../widgets/quest_card.dart';
import '../widgets/xp_animation.dart';

class TodayScreen extends StatefulWidget {
  final Player player;
  final List<DailyTask> tasks;
  final List<SkillXp> skills;
  final VoidCallback onDataChanged;

  const TodayScreen({
    super.key,
    required this.player,
    required this.tasks,
    required this.skills,
    required this.onDataChanged,
  });

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final List<Widget> _floatingTexts = [];
  bool _showLevelUp = false;
  int _levelUpTo = 1;

  List<DailyTask> get _pendingTasks => widget.tasks.where((t) => t.isEnabled && !t.isCompleted).toList();

  Future<void> _completeTask(DailyTask task) async {
    // เช็คก่อนว่าเควสนี้เป็นเควสสุดท้ายของวันหรือไม่ (ครบทุกเควสที่เปิดใช้งาน)
    final isCritical = widget.tasks
        .where((t) => t.isEnabled)
        .every((t) => t.isCompleted || t.id == task.id);

    // ถ้าครบคริ ได้รับ XP ของเควสนี้ x2
    final xpGained = isCritical ? task.xpReward * 2 : task.xpReward;

    final result = XpService.addXp(widget.player, xpGained);

    if (task.skillId != null) {
      final skill = widget.skills.firstWhere(
        (s) => s.name == task.skillId,
        orElse: () => SkillXp(name: task.skillId!, icon: '⭐'),
      );
      skill.xp += xpGained;
      if (!widget.skills.contains(skill)) widget.skills.add(skill);
    }

    task.isCompleted = true;

    await StorageService.savePlayer(widget.player);
    await StorageService.saveTasks(widget.tasks);
    await StorageService.saveSkills(widget.skills);

    setState(() {
      _floatingTexts.add(FloatingXpText(
        key: UniqueKey(),
        xp: xpGained,
        isCritical: isCritical,
        onCompleted: () => setState(() => _floatingTexts.removeAt(0)),
      ));
      if (result.leveledUp) {
        _showLevelUp = true;
        _levelUpTo = result.newLevel;
      }
    });

    widget.onDataChanged();
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
      await StorageService.saveTasks(widget.tasks);
      widget.onDataChanged();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending = _pendingTasks;

    return Scaffold(
      appBar: AppBar(title: const Text('⚔️ Today')),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LevelBar(player: widget.player, leveledUp: _showLevelUp),
                  const SizedBox(height: 24),
                  Expanded(
                    child: pending.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🎉', style: TextStyle(fontSize: 48)),
                                SizedBox(height: 12),
                                Text(
                                  'ทำ Quest ครบทุกอันของวันนี้แล้ว!',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CURRENT QUEST',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 2),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: pending.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final task = pending[index];
                                    return QuestCard(
                                      key: ValueKey(task.id),
                                      task: task,
                                      onComplete: () => _completeTask(task),
                                      onEdit: () => _editTask(task),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            child: Center(child: Column(children: _floatingTexts)),
          ),
          if (_showLevelUp)
            LevelUpOverlay(newLevel: _levelUpTo, onFinished: () => setState(() => _showLevelUp = false)),
        ],
      ),
    );
  }
}
