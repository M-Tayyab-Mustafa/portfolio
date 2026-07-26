import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/brand_loader.dart';

class PortfolioSplashPage extends StatelessWidget {
  const PortfolioSplashPage({
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = errorMessage;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: message == null
            ? const BrandLoader()
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
