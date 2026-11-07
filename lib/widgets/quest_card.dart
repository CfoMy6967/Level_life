import 'package:flutter/material.dart';
import '../models/daily_task.dart';
import '../theme/app_theme.dart';

/// A single quest card. Tapping it plays a scale + fade + slide-out
/// animation (300-600ms) and then reports completion via [onComplete].
class QuestCard extends StatefulWidget {
  final DailyTask task;
  final VoidCallback onComplete;
  final VoidCallback? onEdit;

  const QuestCard({super.key, required this.task, required this.onComplete, this.onEdit});

  @override
  State<QuestCard> createState() => _QuestCardState();
}

class _QuestCardState extends State<QuestCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _completing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scale = Tween<double>(begin: 1.0, end: 0.85).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    _slide = Tween<Offset>(begin: Offset.zero, end: const Offset(1.2, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_completing) return;
    setState(() => _completing = true);
    _controller.forward().whenComplete(widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _opacity,
        child: ScaleTransition(
          scale: _scale,
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(color: AppColors.red.withValues(alpha: 0.15), blurRadius: 18, spreadRadius: 1),
                ],
              ),
              child: Row(
                children: [
                  Text(widget.task.icon, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.task.title,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(widget.task.description,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration:
                        BoxDecoration(gradient: AppColors.xpGradient, borderRadius: BorderRadius.circular(12)),
                    child: Text('+${widget.task.xpReward} XP',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  if (widget.onEdit != null) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.textSecondary, size: 18),
                      onPressed: widget.onEdit,
                      tooltip: 'แก้ไขกิจกรรม',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
