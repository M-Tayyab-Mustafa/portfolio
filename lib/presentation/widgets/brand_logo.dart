import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/presentation/widgets/portfolio_image.dart';

class BrandLogo extends StatefulWidget {
  const BrandLogo({
    required this.profile,
    required this.semanticLabel,
    super.key,
    this.compact = false,
    this.showWordmark = true,
  });

  final PersonalProfile profile;
  final String semanticLabel;
  final bool compact;
  final bool showWordmark;

  @override
  State<BrandLogo> createState() => _BrandLogoState();
}

class _BrandLogoState extends State<BrandLogo> {
  static const _animationDuration = Duration(milliseconds: 280);
  static const _flippedColorMatrix = <double>[
    1.1264408415,
    -.1459188368,
    -.0825220047,
    0,
    0,
    1.1837088923,
    -.6192722855,
    -.5294366069,
    0,
    0,
    1.1808554437,
    -.5956868877,
    -.507168556,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];
  static const _identityColorMatrix = <double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];
  bool _hovered = false;

  List<double> _logoColorMatrix(double progress) {
    return List<double>.generate(
      _identityColorMatrix.length,
      (index) =>
          _identityColorMatrix[index] +
          (_flippedColorMatrix[index] - _identityColorMatrix[index]) * progress,
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final markSize = widget.compact ? 34.0 : 38.0;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : _animationDuration;
    final logo = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: duration,
          curve: Curves.easeOutCubic,
          width: markSize,
          height: markSize,
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.borderStrong,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
          clipBehavior: Clip.antiAlias,
          child: TweenAnimationBuilder<double>(
            duration: duration,
            curve: Curves.easeOutCubic,
            tween: Tween(end: _hovered ? 1 : 0),
            builder: (context, progress, child) {
              if (progress <= 0) return child!;
              return ColorFiltered(
                colorFilter: ColorFilter.matrix(_logoColorMatrix(progress)),
                child: child,
              );
            },
            child: PortfolioImage(
              source: widget.profile.logoAsset,
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
        ),
        if (widget.showWordmark) ...[
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: duration,
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  color: _hovered ? AppColors.accent : AppColors.textPrimary,
                  fontFamily: 'SpaceGrotesk',
                  fontSize: widget.compact ? 12 : 14,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
                child: Text(widget.profile.firstName.toUpperCase()),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: duration,
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  color: _hovered ? AppColors.textPrimary : AppColors.accent,
                  fontFamily: 'monospace',
                  fontSize: widget.compact ? 8 : 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3.2,
                  height: 1,
                ),
                child: Text(widget.profile.lastName.toUpperCase()),
              ),
            ],
          ),
        ],
      ],
    );

    return Semantics(
      label: widget.semanticLabel,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: logo,
      ),
    );
  }
}
