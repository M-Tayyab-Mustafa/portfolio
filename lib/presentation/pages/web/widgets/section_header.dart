import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/presentation/pages/web/widgets/outlined_text.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.accentTitle,
    super.key,
    this.centered = true,
  });

  final String eyebrow;
  final String title;
  final String accentTitle;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final style = Theme.of(context).textTheme.displayMedium!.copyWith(
      fontSize: AppTypography.sectionTitleSize(width),
      height: 1.05,
      letterSpacing: -2,
    );
    final alignment = centered ? WrapAlignment.center : WrapAlignment.start;
    final crossAxis = centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAxis,
      children: [
        Text(
          eyebrow.toUpperCase(),
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
            color: AppColors.accent,
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          alignment: alignment,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 4,
          children: [
            Text(title.toUpperCase(), style: style),
            OutlinedText(accentTitle.toUpperCase(), style: style),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(width: 64, height: 4, color: AppColors.accent),
      ],
    );
  }
}
