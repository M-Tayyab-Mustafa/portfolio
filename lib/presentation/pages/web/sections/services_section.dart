import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/hover_surface.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_container.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_header.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({required this.content, super.key});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      background: AppColors.surface,
      ambientAlignment: Alignment.bottomRight,
      ambientOpacity: .055,
      child: Column(
        children: [
          RevealOnScroll(
            child: SectionHeader(
              eyebrow: content.heading('services').eyebrow,
              title: content.heading('services').title,
              accentTitle: content.heading('services').accentTitle,
            ),
          ),
          const SizedBox(height: 74),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 1040 ? 2 : 3;
              final gap = columns == 2 ? 20.0 : 24.0;
              final cardWidth =
                  (constraints.maxWidth - (gap * (columns - 1))) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final entry in content.services.indexed)
                    SizedBox(
                      width: cardWidth,
                      height: 288,
                      child: RevealOnScroll(
                        delay: Duration(
                          milliseconds: (entry.$1 % columns) * 80,
                        ),
                        child: _ServiceCard(
                          service: entry.$2,
                          ctaLabel: 'Inquire service',
                          onDiscuss: () => context
                              .read<PortfolioNavigationCubit>()
                              .navigateTo(PortfolioSection.contact),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.ctaLabel,
    required this.onDiscuss,
  });

  final ServiceItem service;
  final String ctaLabel;
  final VoidCallback onDiscuss;

  @override
  Widget build(BuildContext context) {
    return HoverSurface(
      background: AppColors.background,
      padding: EdgeInsets.zero,
      builder: (context, hovered) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: hovered
                        ? AppColors.accent.withValues(alpha: .08)
                        : AppColors.surface,
                    border: Border.all(
                      color: hovered
                          ? AppColors.accent.withValues(alpha: .32)
                          : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(AppLayout.radius),
                  ),
                  child: Center(
                    child: AnimatedScale(
                      scale: hovered ? 1.1 : 1,
                      duration: const Duration(milliseconds: 280),
                      child: AppIcon(
                        service.iconName,
                        size: 27,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 21),
                Text(
                  service.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 19),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    service.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: onDiscuss,
                  style: TextButton.styleFrom(
                    foregroundColor: hovered
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: const Size(48, 42),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ctaLabel.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 7),
                      const AppIcon('external', size: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 480),
              curve: Curves.easeOutCubic,
              width: hovered ? 320 : 0,
              height: 2,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
