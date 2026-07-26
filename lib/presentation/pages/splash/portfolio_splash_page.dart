import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/brand_loader.dart';

class PortfolioSplashPage extends StatelessWidget {
  const PortfolioSplashPage({
    required this.errorMessage,
    required this.onRetry,
    this.onAnimationComplete,
    super.key,
  });

  final String? errorMessage;
  final VoidCallback onRetry;
  final VoidCallback? onAnimationComplete;

  @override
  Widget build(BuildContext context) {
    final message = errorMessage;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: message == null
            ? BrandLoader(onStartupAnimationCompleted: onAnimationComplete)
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(label: 'Retry', onPressed: onRetry),
                  ],
                ),
              ),
      ),
    );
  }
}
