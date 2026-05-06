import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ─── FadeSlide ────────────────────────────────────────────────
/// Fades + slides in when scrolled into view.
/// Automatically RESETS when scrolled completely out, so it replays
/// every time the user scrolls back to this position.
class FadeSlide extends StatefulWidget {
  const FadeSlide({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 650),
    this.beginOffset = const Offset(0, 40),
    this.curve = Curves.easeOutCubic,
    this.visibilityThreshold = 0.08,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;
  final Curve curve;
  final double visibilityThreshold;

  @override
  State<FadeSlide> createState() => _FadeSlideState();
}

class _FadeSlideState extends State<FadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Key _visKey;

  @override
  void initState() {
    super.initState();
    _visKey = UniqueKey();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: Interval(0, 0.85, curve: widget.curve),
    );
    _slide = Tween<Offset>(
      begin: Offset(widget.beginOffset.dx / 200, widget.beginOffset.dy / 200),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction >= widget.visibilityThreshold) {
      // Only forward if not already playing / played
      if (_ctrl.status == AnimationStatus.dismissed) {
        Future.delayed(widget.delay, () {
          if (mounted) _ctrl.forward();
        });
      }
    } else if (info.visibleFraction == 0.0) {
      // Completely out of view → reset so it animates again on next scroll
      _ctrl.reset();
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: _visKey,
    onVisibilityChanged: _onVisibilityChanged,
    child: FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    ),
  );
}

// ─── ScaleFade ────────────────────────────────────────────────
/// Scales from [beginScale] and fades in. Resets when out of view.
class ScaleFade extends StatefulWidget {
  const ScaleFade({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 520),
    this.beginScale = 0.88,
    this.visibilityThreshold = 0.08,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double beginScale;
  final double visibilityThreshold;

  @override
  State<ScaleFade> createState() => _ScaleFadeState();
}

class _ScaleFadeState extends State<ScaleFade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Key _visKey;

  @override
  void initState() {
    super.initState();
    _visKey = UniqueKey();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0, 0.75, curve: Curves.easeOut),
    );
    _scale = Tween<double>(
      begin: widget.beginScale,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction >= widget.visibilityThreshold) {
      if (_ctrl.status == AnimationStatus.dismissed) {
        Future.delayed(widget.delay, () {
          if (mounted) _ctrl.forward();
        });
      }
    } else if (info.visibleFraction == 0.0) {
      _ctrl.reset();
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: _visKey,
    onVisibilityChanged: _onVisibilityChanged,
    child: FadeTransition(
      opacity: _fade,
      child: ScaleTransition(scale: _scale, child: widget.child),
    ),
  );
}

// ─── HoverCard ────────────────────────────────────────────────
/// Lifts slightly on hover — no visibility detection needed.
class HoverCard extends StatefulWidget {
  const HoverCard({super.key, required this.child, this.hoverScale = 1.025});
  final Widget child;
  final double hoverScale;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: widget.hoverScale,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => _ctrl.forward(),
    onExit: (_) => _ctrl.reverse(),
    child: AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: widget.child,
    ),
  );
}

// ─── AnimatedCounter ─────────────────────────────────────────
/// Counts from 0 to [target]. Resets when out of view.
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.target,
    required this.suffix,
    this.style,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 1400),
  });

  final int target;
  final String suffix;
  final TextStyle? style;
  final Duration delay;
  final Duration duration;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;
  late final Key _visKey;

  @override
  void initState() {
    super.initState();
    _visKey = UniqueKey();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(
      begin: 0,
      end: widget.target.toDouble(),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction >= 0.1) {
      if (_ctrl.status == AnimationStatus.dismissed) {
        Future.delayed(widget.delay, () {
          if (mounted) _ctrl.forward();
        });
      }
    } else if (info.visibleFraction == 0.0) {
      _ctrl.reset();
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: _visKey,
    onVisibilityChanged: _onVisibilityChanged,
    child: AnimatedBuilder(
      animation: _anim,
      builder: (_, _) =>
          Text('${_anim.value.toInt()}${widget.suffix}', style: widget.style),
    ),
  );
}

// ─── PulsingDot ───────────────────────────────────────────────
/// Always-pulsing circle for timeline nodes.
class PulsingDot extends StatefulWidget {
  const PulsingDot({super.key, this.size = 12, this.color});
  final double size;
  final Color? color;

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 0.75,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return ScaleTransition(
      scale: _scale,
      child: Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(100),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
      ),
    );
  }
}
