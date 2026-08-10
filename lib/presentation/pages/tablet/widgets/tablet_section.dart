import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/widgets/outlined_text.dart';

class TabletSection extends StatelessWidget {
  const TabletSection({
    required this.child,
    super.key,
    this.background = AppColors.background,
    this.ambientAlignment = Alignment.centerRight,
    this.topPadding = 88,
    this.bottomPadding = 88,
  });

  final Widget child;
  final Color background;
  final Alignment ambientAlignment;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = AppLayout.tabletHorizontalPadding(width);

    return ColoredBox(
      color: background,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: ambientAlignment,
                child: Container(
                  width: 360,
                  height: 360,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: .055),
                        AppColors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppLayout.tabletContentMaxWidth,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  bottomPadding,
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabletSectionHeader extends StatelessWidget {
  const TabletSectionHeader({
    required this.eyebrow,
    required this.title,
    required this.accentTitle,
    super.key,
    this.centered = false,
  });

  final String eyebrow;
  final String title;
  final String accentTitle;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final alignment = centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final headingStyle = Theme.of(context).textTheme.displayMedium!.copyWith(
      fontSize: 42,
      height: 1.04,
      letterSpacing: -1.8,
    );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 28, height: 2, color: AppColors.accent),
            const SizedBox(width: 10),
            Text(
              eyebrow.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accent,
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 11,
          runSpacing: 3,
          children: [
            Text(title.toUpperCase(), style: headingStyle),
            OutlinedText(
              accentTitle.toUpperCase(),
              style: headingStyle,
              strokeWidth: 1.2,
            ),
          ],
        ),
      ],
    );
  }
}

class TabletSurface extends StatelessWidget {
  const TabletSurface({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(22),
    this.color = AppColors.surface,
    this.accent = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: accent
              ? AppColors.accent.withValues(alpha: .38)
              : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(AppLayout.radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
