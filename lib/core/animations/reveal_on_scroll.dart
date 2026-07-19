import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RevealScrollScope extends InheritedWidget {
  const RevealScrollScope({
    required this.controller,
    required super.child,
    super.key,
  });

  final ScrollController controller;

  static RevealScrollScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RevealScrollScope>();
  }

  @override
  bool updateShouldNotify(RevealScrollScope oldWidget) {
    return controller != oldWidget.controller;
  }
}

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
  ScrollController? _scrollController;
  bool _played = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkViewport());
  }

  void _checkViewport() {
    if (!mounted || _played) return;
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final top = renderObject.localToGlobal(Offset.zero).dy;
      final bottom = top + renderObject.size.height;
      final viewportHeight = MediaQuery.sizeOf(context).height;
      if (bottom > 0 && top < viewportHeight) {
        _reveal();
      }
    }
  }

  void _handleScroll() {
    if (_played) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkViewport());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextController = RevealScrollScope.maybeOf(context)?.controller;
    if (nextController != _scrollController) {
      _scrollController?.removeListener(_handleScroll);
      _scrollController = nextController;
      _scrollController?.addListener(_handleScroll);
    }
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _played = true;
      _controller.value = 1;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkViewport());
  }

  Future<void> _reveal() async {
    if (_played) return;
    _played = true;
    _scrollController?.removeListener(_handleScroll);
    if (widget.delay > Duration.zero) await Future<void>.delayed(widget.delay);
    if (mounted) await _controller.forward();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_handleScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey('reveal-${widget.key ?? hashCode}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= widget.visibilityThreshold) _reveal();
      },
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
  }
}
