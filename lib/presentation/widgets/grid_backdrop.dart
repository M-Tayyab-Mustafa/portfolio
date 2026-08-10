import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

class GridBackdrop extends StatelessWidget {
  const GridBackdrop({super.key, this.spacing = 56, this.opacity = .32});

  final double spacing;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(painter: _GridPainter(spacing), size: Size.infinite),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter(this.spacing);

  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: .055)
      ..strokeWidth = 1;

    for (var x = 0.0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final fade = Paint()
      ..shader = const RadialGradient(
        radius: .78,
        colors: [Colors.transparent, AppColors.background],
        stops: [.25, 1],
      ).createShader(Offset.zero & size)
      ..blendMode = BlendMode.srcOver;
    canvas.drawRect(Offset.zero & size, fade);
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.spacing != spacing;
  }
}
