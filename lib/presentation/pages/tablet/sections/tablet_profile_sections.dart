import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';
import 'package:portfolio/presentation/pages/tablet/widgets/tablet_section.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';

class TabletAboutSection extends StatelessWidget {
  const TabletAboutSection({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final profile = content.profile;
    final heading = content.heading('about');

    return TabletSection(
      background: AppColors.surface,
      ambientAlignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(
            child: TabletSectionHeader(
              eyebrow: heading.eyebrow,
              title: heading.title,
              accentTitle: heading.accentTitle,
            ),
          ),
          const SizedBox(height: 44),
          RevealOnScroll(
            offset: const Offset(0, .05),
            child: TabletSurface(
              padding: const EdgeInsets.all(26),
              color: AppColors.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: .1),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: .3),
                          ),
                        ),
                        child: const Center(
                          child: AppIcon(
                            'person',
                            color: AppColors.accent,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          'Engineering products people enjoy using.',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontSize: 20, height: 1.25),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    profile.aboutBrief,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    profile.aboutLong,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (profile.coreFocus.isNotEmpty) ...[
                    const SizedBox(height: 26),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 650 ? 2 : 1;
                        const gap = 12.0;
                        final itemWidth =
                            (constraints.maxWidth - gap * (columns - 1)) /
                            columns;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final focus in profile.coreFocus)
                              SizedBox(
                                width: itemWidth,
                                child: _FocusItem(label: focus),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (content.stats.isNotEmpty) ...[
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 620
                    ? 3
                    : constraints.maxWidth >= 300
                    ? 2
                    : 1;
                const gap = 12.0;
                final width =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final entry in content.stats.indexed)
                      SizedBox(
                        width: width,
                        child: RevealOnScroll(
                          delay: Duration(milliseconds: entry.$1 * 60),
                          child: _StatCard(stat: entry.$2),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _FocusItem extends StatelessWidget {
  const _FocusItem({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            const AppIcon('check', size: 16, color: AppColors.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final StatItem stat;

  @override
  Widget build(BuildContext context) {
    return TabletSurface(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stat.value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              AppIcon(stat.iconName, size: 18, color: AppColors.accent),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            stat.label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontFamily: 'monospace',
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }
}

class TabletSkillsSection extends StatelessWidget {
  const TabletSkillsSection({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final heading = content.heading('skills');

    return TabletSection(
      ambientAlignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(
            child: TabletSectionHeader(
              eyebrow: heading.eyebrow,
              title: heading.title,
              accentTitle: heading.accentTitle,
            ),
          ),
          const SizedBox(height: 44),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 660 ? 2 : 1;
              const gap = 16.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final entry in content.skillGroups.indexed)
                    SizedBox(
                      width: width,
                      child: RevealOnScroll(
                        delay: Duration(milliseconds: entry.$1 * 60),
                        child: _SkillCard(group: entry.$2),
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

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.group});

  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    return TabletSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 5, height: 28, color: AppColors.accent),
              const SizedBox(width: 12),
              AppIcon(group.iconName, size: 20, color: AppColors.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  group.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 17),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in group.skills)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(
                          skill.iconName,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          skill.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class TabletServicesSection extends StatelessWidget {
  const TabletServicesSection({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final heading = content.heading('services');

    return TabletSection(
      background: AppColors.surface,
      ambientAlignment: Alignment.bottomRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(
            child: TabletSectionHeader(
              eyebrow: heading.eyebrow,
              title: heading.title,
              accentTitle: heading.accentTitle,
            ),
          ),
          const SizedBox(height: 44),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 670 ? 2 : 1;
              const gap = 16.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final entry in content.services.indexed)
                    SizedBox(
                      width: width,
                      child: RevealOnScroll(
                        delay: Duration(
                          milliseconds: (entry.$1 % columns) * 70,
                        ),
                        child: _ServiceCard(service: entry.$2),
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
  const _ServiceCard({required this.service});

  final ServiceItem service;

  @override
  Widget build(BuildContext context) {
    return TabletSurface(
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: .09),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: .28),
              ),
            ),
            child: Center(
              child: AppIcon(
                service.iconName,
                size: 23,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            service.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 9),
          Text(
            service.description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => context
                .read<PortfolioNavigationCubit>()
                .navigateTo(PortfolioSection.contact),
            iconAlignment: IconAlignment.end,
            icon: const AppIcon('arrowRight', size: 15),
            label: const Text('DISCUSS THIS SERVICE'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              textStyle: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                letterSpacing: .8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
