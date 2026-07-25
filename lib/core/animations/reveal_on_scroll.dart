import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    required this.child,
    super.key,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 560),
    this.offset = const Offset(0, .12),
    this.visibilityThreshold = .08,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final double visibilityThreshold;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _started = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    // Keep content readable even if a browser throttles off-screen animation
    // callbacks; the reveal enhances the section instead of gating it.
    _opacity = Tween<double>(begin: .68, end: 1).animate(curved);
    _slide = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(curved);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _started = true;
      _completed = true;
      _controller.value = 1;
    }
  }

  Future<void> _reveal() async {
    if (_started) return;
    setState(() => _started = true);
    if (widget.delay > Duration.zero) await Future<void>.delayed(widget.delay);
    if (!mounted) return;
    await _controller.forward();
    if (mounted) setState(() => _completed = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) return widget.child;

    final transition = RepaintBoundary(
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
    if (_started) return transition;

    return VisibilityDetector(
      key: ValueKey('reveal-${widget.key ?? hashCode}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= widget.visibilityThreshold) _reveal();
      },
      child: transition,
    );
  }
}
