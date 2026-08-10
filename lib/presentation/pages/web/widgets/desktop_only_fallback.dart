import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/presentation/widgets/portfolio_image.dart';

import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';

class DesktopOnlyFallback extends StatelessWidget {
  const DesktopOnlyFallback({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.borderStrong),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PortfolioImage(
                      source: content.profile.logoAsset,
                      width: 72,
                      height: 72,
                      semanticLabel: 'Muhammad Tayyab logo',
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'TABLET / DESKTOP EXPERIENCE',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This portfolio is optimized for tablets and desktop displays. Open it in a window at least 600 pixels wide.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
