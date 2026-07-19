import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

class GridBackdrop extends StatelessWidget {
  const GridBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: .34,
        child: CustomPaint(painter: const _GridPainter(), size: Size.infinite),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 64.0;
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
        radius: .75,
        colors: [Colors.transparent, AppColors.background],
        stops: [.28, 1],
      ).createShader(Offset.zero & size)
      ..blendMode = BlendMode.srcOver;
    canvas.drawRect(Offset.zero & size, fade);
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}
