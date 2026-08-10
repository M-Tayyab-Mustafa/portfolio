import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';

class PortfolioBackButton extends StatelessWidget {
  const PortfolioBackButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width < 560) {
      return AppIconButton(
        size: 44,
        tooltip: 'Back to portfolio',
        onPressed: onPressed,
        icon: const AppIcon('arrowLeft', size: 17),
      );
    }
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
