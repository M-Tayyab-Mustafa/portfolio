import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

class OutlinedText extends StatelessWidget {
  const OutlinedText(
    this.text, {
    required this.style,
    super.key,
    this.color = AppColors.accent,
    this.strokeWidth = 1.25,
  });

  final String text;
  final TextStyle style;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(
        color: null,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = color,
      ),
    );
  }
}
