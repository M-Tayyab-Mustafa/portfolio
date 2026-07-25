import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/presentation/widgets/portfolio_image.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    required this.profile,
    required this.semanticLabel,
    super.key,
    this.compact = false,
  });

  final PersonalProfile profile;
  final String semanticLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 34.0 : 38.0;
    final logo = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: markSize,
          height: markSize,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderStrong),
            borderRadius: BorderRadius.circular(3),
          ),
          clipBehavior: Clip.antiAlias,
          child: PortfolioImage(
            source: profile.logoAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(
              color: AppColors.surface,
              child: Center(
                child: Text(
                  'M//T',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.firstName.toUpperCase(),
              style: TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'SpaceGrotesk',
                fontSize: compact ? 12 : 14,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              profile.lastName.toUpperCase(),
              style: TextStyle(
                color: AppColors.accent,
                fontFamily: 'monospace',
                fontSize: compact ? 8 : 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 3.2,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );

    return Semantics(label: semanticLabel, child: logo);
  }
}
