import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/brand_logo.dart';

class PortfolioNavbar extends StatelessWidget {
  const PortfolioNavbar({
    required this.content,
    required this.activeSection,
    required this.isScrolled,
    super.key,
  });

  final PortfolioContent content;
  final PortfolioSection activeSection;
  final bool isScrolled;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < AppLayout.compactDesktop;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      height: isScrolled ? 72 : AppLayout.navigationHeight,
      decoration: BoxDecoration(
        color: isScrolled
            ? AppColors.background.withValues(alpha: .86)
            : AppColors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isScrolled ? AppColors.border : AppColors.transparent,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isScrolled ? 16 : 0,
            sigmaY: isScrolled ? 16 : 0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppLayout.contentMaxWidth,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppLayout.horizontalPadding(width),
                ),
                child: Row(
                  children: [
                    BrandLogo(
                      profile: content.profile,
                      semanticLabel:
                          'Muhammad Tayyab, go to the portfolio home section',
                      compact: compact,
                      onPressed: () => context
                          .read<PortfolioNavigationCubit>()
                          .navigateTo(PortfolioSection.home),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final section in PortfolioSection.values)
                            _NavLink(
                              section: section,
                              label: content.navigationLabel(section.name),
                              active: section == activeSection,
                              compact: compact,
                              onPressed: () => context
                                  .read<PortfolioNavigationCubit>()
                                  .navigateTo(section),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    AppButton(
                      label: 'Hire me',
                      compact: true,
                      icon: const AppIcon(
                        'external',
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => context
                          .read<PortfolioNavigationCubit>()
                          .navigateTo(PortfolioSection.contact),
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

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.section,
    required this.label,
    required this.active,
    required this.compact,
    required this.onPressed,
  });

  final PortfolioSection section;
  final String label;
  final bool active;
  final bool compact;
  final VoidCallback onPressed;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.active || _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          foregroundColor: highlighted
              ? AppColors.textPrimary
              : AppColors.textSecondary,
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 5 : 9,
            vertical: 14,
          ),
          minimumSize: const Size(40, 48),
          shape: const StadiumBorder(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontSize: widget.compact ? 9.5 : 11,
                fontWeight: FontWeight.w700,
                letterSpacing: widget.compact ? .45 : .75,
              ),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: widget.active ? 24 : (_hovered ? 12 : 0),
              height: 2,
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}
