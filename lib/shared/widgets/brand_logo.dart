import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/portfolio_image.dart';

class BrandLogo extends StatefulWidget {
  const BrandLogo({
    required this.profile,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
    this.compact = false,
  });

  final PersonalProfile profile;
  final VoidCallback onPressed;
  final String semanticLabel;
  final bool compact;

  @override
  State<BrandLogo> createState() => _BrandLogoState();
}

class _BrandLogoState extends State<BrandLogo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final markSize = widget.compact ? 34.0 : 38.0;
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
            minimumSize: const Size(48, 48),
            shape: const StadiumBorder(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                width: markSize,
                height: markSize,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _hovered ? AppColors.accent : AppColors.borderStrong,
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: .2),
                            blurRadius: 18,
                          ),
                        ]
                      : const [],
                ),
                clipBehavior: Clip.antiAlias,
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
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.profile.firstName.toUpperCase(),
                    style: TextStyle(
                      color: _hovered
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontFamily: 'SpaceGrotesk',
                      fontSize: widget.compact ? 12 : 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.profile.lastName.toUpperCase(),
                    style: TextStyle(
                      color: _hovered
                          ? AppColors.textPrimary
                          : AppColors.accent,
                      fontFamily: 'monospace',
                      fontSize: widget.compact ? 8 : 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3.2,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
