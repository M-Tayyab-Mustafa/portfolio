import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer({
    required this.child,
    super.key,
    this.background = AppColors.background,
    this.ambientAlignment = Alignment.center,
    this.ambientOpacity = .04,
    this.topPadding,
    this.bottomPadding,
  });

  final Widget child;
  final Color background;
  final Alignment ambientAlignment;
  final double ambientOpacity;
  final double? topPadding;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final vertical = AppLayout.sectionPadding(width);

    return ColoredBox(
      color: background,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: ambientAlignment,
                child: Container(
                  width: 440,
                  height: 440,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: ambientOpacity),
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
                maxWidth: AppLayout.contentMaxWidth,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppLayout.horizontalPadding(width),
                  topPadding ?? vertical,
                  AppLayout.horizontalPadding(width),
                  bottomPadding ?? vertical,
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
