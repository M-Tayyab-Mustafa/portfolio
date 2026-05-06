import 'dart:math';

import 'package:portfolio/utils/exports.dart';

class EasyLoader {
  static OverlayEntry? _entry;
  static bool _isShowing = false;

  static void show() {
    if (_isShowing) return;

    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _entry = OverlayEntry(builder: (_) => const LoaderWidget());

    overlay.insert(_entry!);
    _isShowing = true;
  }

  static void hide() {
    if (!_isShowing) return;

    _entry?.remove();
    _entry = null;
    _isShowing = false;
  }

  static bool get isShowing => _isShowing;
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.6),
      child: PopScope(
        canPop: false,
        child: AbsorbPointer(
          absorbing: true,
          child: Center(child: const _ArcLoader()),
        ),
      ),
    );
  }
}

class _ArcLoader extends StatefulWidget {
  const _ArcLoader();

  @override
  State<_ArcLoader> createState() => _ArcLoaderState();
}

class _ArcLoaderState extends State<_ArcLoader> with TickerProviderStateMixin {
  late final AnimationController _outerCtrl;
  late final AnimationController _middleCtrl;
  late final AnimationController _innerCtrl;
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();

    _outerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _middleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _innerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _outerCtrl.dispose();
    _middleCtrl.dispose();
    _innerCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Pull colors from the app theme here, where context is available
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _outerCtrl,
        _middleCtrl,
        _innerCtrl,
        _pulseCtrl,
      ]),
      builder: (context, _) {
        return SizedBox(
          width: 110,
          height: 110,
          child: CustomPaint(
            painter: _ArcPainter(
              outerAngle: _outerCtrl.value * 2 * pi,
              middleAngle: -_middleCtrl.value * 2 * pi,
              innerAngle: _innerCtrl.value * 2 * pi,
              pulseValue: _pulseCtrl.value,
              // ✅ Pass theme colors into the painter
              outerColor: colorScheme.primary,
              middleColor: colorScheme.secondary,
              innerColor: colorScheme.tertiary,
              dotColor: colorScheme.onPrimary,
              glowColor: colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.outerAngle,
    required this.middleAngle,
    required this.innerAngle,
    required this.pulseValue,
    // ✅ New theme color parameters
    required this.outerColor,
    required this.middleColor,
    required this.innerColor,
    required this.dotColor,
    required this.glowColor,
  });

  final double outerAngle;
  final double middleAngle;
  final double innerAngle;
  final double pulseValue;

  final Color outerColor;
  final Color middleColor;
  final Color innerColor;
  final Color dotColor;
  final Color glowColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // ✅ Glow uses theme's primary color
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [glowColor.withValues(alpha: 0.25), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawCircle(center, size.width / 2, glowPaint);

    // ✅ Outer arc → colorScheme.primary
    _drawArc(
      canvas: canvas,
      center: center,
      radius: size.width / 2 - 6,
      strokeWidth: 4.5,
      startAngle: outerAngle,
      sweepAngle: 3 * pi / 2,
      colors: [outerColor, outerColor.withValues(alpha: 0.1)],
      capStyle: StrokeCap.round,
    );

    // ✅ Middle arc → colorScheme.secondary
    _drawArc(
      canvas: canvas,
      center: center,
      radius: size.width / 2 - 20,
      strokeWidth: 4,
      startAngle: middleAngle,
      sweepAngle: (200 / 360) * 2 * pi,
      colors: [middleColor, middleColor.withValues(alpha: 0.1)],
      capStyle: StrokeCap.round,
    );

    // ✅ Inner arc → colorScheme.tertiary
    _drawArc(
      canvas: canvas,
      center: center,
      radius: size.width / 2 - 34,
      strokeWidth: 3.5,
      startAngle: innerAngle,
      sweepAngle: (120 / 360) * 2 * pi,
      colors: [innerColor, innerColor.withValues(alpha: 0.05)],
      capStyle: StrokeCap.round,
    );

    final dotRadius = 5.0 + pulseValue * 3.5;
    final dotOpacity = 0.6 + pulseValue * 0.4;

    // ✅ Dot glow + fill → colorScheme.onPrimary
    final dotGlow = Paint()
      ..color = dotColor.withValues(alpha: dotOpacity * 0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, dotRadius * 1.6);
    canvas.drawCircle(center, dotRadius * 1.8, dotGlow);

    final dotFill = Paint()
      ..color = dotColor.withValues(alpha: dotOpacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, dotRadius, dotFill);
  }

  void _drawArc({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double strokeWidth,
    required double startAngle,
    required double sweepAngle,
    required List<Color> colors,
    StrokeCap capStyle = StrokeCap.butt,
  }) {
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = capStyle
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: colors,
        transform: GradientRotation(startAngle),
      ).createShader(rect);

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.outerAngle != outerAngle ||
      old.middleAngle != middleAngle ||
      old.innerAngle != innerAngle ||
      old.pulseValue != pulseValue ||
      old.outerColor != outerColor ||
      old.middleColor != middleColor ||
      old.innerColor != innerColor ||
      old.dotColor != dotColor ||
      old.glowColor != glowColor;
}
