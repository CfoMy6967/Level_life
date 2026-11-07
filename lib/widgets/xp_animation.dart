import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Floating "+XP" text that rises and fades out over ~700ms.
/// When [isCritical] is true, shows a bigger, gold "CRITICAL! +XP x2" version
/// for completing every quest of the day.
class FloatingXpText extends StatefulWidget {
  final int xp;
  final bool isCritical;
  final VoidCallback? onCompleted;

  const FloatingXpText({super.key, required this.xp, this.isCritical = false, this.onCompleted});

  @override
  State<FloatingXpText> createState() => _FloatingXpTextState();
}

class _FloatingXpTextState extends State<FloatingXpText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.isCritical ? 1000 : 700));
    _offset = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.2))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0)));
    _controller.forward().whenComplete(() => widget.onCompleted?.call());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: FadeTransition(
        opacity: _opacity,
        child: widget.isCritical
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✨ CRITICAL! ✨',
                      style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 18)),
                  Text('+${widget.xp} XP',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 26)),
                ],
              )
            : Text(
                '+${widget.xp} XP',
                style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w900, fontSize: 22),
              ),
      ),
    );
  }
}

/// Full-screen flash/glow/scale animation shown briefly on Level Up.
class LevelUpOverlay extends StatefulWidget {
  final int newLevel;
  final VoidCallback onFinished;

  const LevelUpOverlay({super.key, required this.newLevel, required this.onFinished});

  @override
  State<LevelUpOverlay> createState() => _LevelUpOverlayState();
}

class _LevelUpOverlayState extends State<LevelUpOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 30),
    ]).animate(_controller);
    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 25),
    ]).animate(_controller);
    _controller.forward().whenComplete(widget.onFinished);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FadeTransition(
        opacity: _opacity,
        child: Container(
          color: Colors.black.withValues(alpha: 0.55),
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('⚡ LEVEL UP ⚡',
                    style: TextStyle(color: AppColors.orange, fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text('LEVEL ${widget.newLevel}',
                    style: const TextStyle(color: Colors.white, fontSize: 46, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
