import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';

class PortfolioBackButton extends StatelessWidget {
  const PortfolioBackButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.45,
        ),
      ),
      icon: const AppIcon('arrowLeft', size: 16),
      label: const Text('BACK TO PORTFOLIO'),
    );
  }
}
