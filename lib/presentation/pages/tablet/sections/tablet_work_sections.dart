import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';
import 'package:portfolio/presentation/blocs/projects/projects_cubit.dart';
import 'package:portfolio/presentation/pages/tablet/widgets/tablet_project_card.dart';
import 'package:portfolio/presentation/pages/tablet/widgets/tablet_section.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';

class TabletProjectsSection extends StatelessWidget {
  const TabletProjectsSection({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final heading = content.heading('projects');

    return TabletSection(
      ambientAlignment: Alignment.bottomCenter,
      child: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) {
          final projects = state.visibleProjects.take(4).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RevealOnScroll(
                child: TabletSectionHeader(
                  eyebrow: heading.eyebrow,
                  title: heading.title,
                  accentTitle: heading.accentTitle,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ProjectCategory.values.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = ProjectCategory.values[index];
                    final available =
                        category == ProjectCategory.all ||
                        state.allProjects.any(
                          (project) => project.category == category,
                        );
                    if (!available) return const SizedBox.shrink();
                    return _CategoryChip(
                      label: content.categoryLabel(category),
                      selected: state.selectedCategory == category,
                      onPressed: () => context
                          .read<ProjectsCubit>()
                          .selectCategory(category),
                    );
                  },
                ),
              ),
              const SizedBox(height: 34),
              if (projects.isEmpty)
                const _EmptyProjects()
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 700 ? 2 : 1;
                    const gap = 16.0;
                    final width =
                        (constraints.maxWidth - gap * (columns - 1)) / columns;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (final entry in projects.indexed)
                          SizedBox(
                            width: width,
                            child: RevealOnScroll(
                              delay: Duration(
                                milliseconds: (entry.$1 % columns) * 70,
                              ),
                              child: TabletProjectCard(project: entry.$2),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              if (state.allProjects.length > projects.length) ...[
                const SizedBox(height: 34),
                Center(
                  child: AppButton(
                    label: 'View all ${state.allProjects.length} projects',
                    compact: true,
                    variant: AppButtonVariant.outline,
                    icon: const AppIcon(
                      'arrowLongRight',
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => context.push(PortfolioRoute.projectsPath),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: selected
            ? AppColors.textPrimary
            : AppColors.textSecondary,
        backgroundColor: selected ? AppColors.accent : AppColors.surface,
        side: BorderSide(
          color: selected ? AppColors.accent : AppColors.borderStrong,
        ),
        minimumSize: const Size(48, 42),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        textStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: .7,
        ),
      ),
      child: Text(label.toUpperCase()),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects();

  @override
  Widget build(BuildContext context) {
    return const TabletSurface(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 34),
          child: Text(
            'NO PROJECTS IN THIS CATEGORY YET',
            style: TextStyle(
              color: AppColors.textMuted,
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class TabletExperienceSection extends StatelessWidget {
  const TabletExperienceSection({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final heading = content.heading('experience');
    final work = content.experiences
        .where((item) => item.kind == ExperienceKind.practice)
        .toList();
    final milestones = content.experiences
        .where((item) => item.kind == ExperienceKind.milestone)
        .toList();

    return TabletSection(
      background: AppColors.surface,
      ambientAlignment: Alignment.bottomLeft,
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
              final twoColumns = constraints.maxWidth >= 760;
              if (!twoColumns) {
                return Column(
                  children: [
                    _TimelineGroup(
                      title: 'Work history',
                      iconName: 'briefcase',
                      items: work,
                    ),
                    if (milestones.isNotEmpty) ...[
                      const SizedBox(height: 34),
                      _TimelineGroup(
                        title: 'Career milestones',
                        iconName: 'milestone',
                        items: milestones,
                      ),
                    ],
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _TimelineGroup(
                      title: 'Work history',
                      iconName: 'briefcase',
                      items: work,
                    ),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: _TimelineGroup(
                      title: 'Career milestones',
                      iconName: 'milestone',
                      items: milestones,
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

class _TimelineGroup extends StatelessWidget {
  const _TimelineGroup({
    required this.title,
    required this.iconName,
    required this.items,
  });

  final String title;
  final String iconName;
  final List<ExperienceItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: .1),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: .3),
                ),
              ),
              child: Center(
                child: AppIcon(iconName, size: 20, color: AppColors.accent),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (items.isEmpty)
          const Text(
            'No entries published yet.',
            style: TextStyle(color: AppColors.textMuted),
          )
        else
          Container(
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: AppColors.accent.withValues(alpha: .35),
                ),
              ),
            ),
            child: Column(
              children: [
                for (final entry in items.indexed) ...[
                  _ExperienceCard(item: entry.$2),
                  if (entry.$1 != items.length - 1) const SizedBox(height: 16),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.item});

  final ExperienceItem item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -27,
          top: 22,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 2),
            ),
          ),
        ),
        TabletSurface(
          padding: const EdgeInsets.all(18),
          color: AppColors.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.period.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontFamily: 'monospace',
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                item.context,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.description,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 11.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TabletTestimonialsSection extends StatefulWidget {
  const TabletTestimonialsSection({required this.content, super.key});

  final PortfolioDataState content;

  @override
  State<TabletTestimonialsSection> createState() =>
      _TabletTestimonialsSectionState();
}

class _TabletTestimonialsSectionState extends State<TabletTestimonialsSection> {
  int _index = 0;

  void _move(int delta) {
    final length = widget.content.testimonials.length;
    if (length < 2) return;
    setState(() {
      _index = (_index + delta) % length;
      if (_index < 0) _index = length - 1;
    });
  }

  @override
  void didUpdateWidget(covariant TabletTestimonialsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_index >= widget.content.testimonials.length) _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    final testimonials = widget.content.testimonials;
    final heading = widget.content.heading('testimonials');

    return TabletSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabletSectionHeader(
            eyebrow: heading.eyebrow,
            title: heading.title,
            accentTitle: heading.accentTitle,
          ),
          const SizedBox(height: 42),
          if (testimonials.isEmpty)
            const _EmptyTestimonials()
          else ...[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(.03, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: _TestimonialCard(
                key: ValueKey(_index),
                testimonial: testimonials[_index],
              ),
            ),
            if (testimonials.length > 1) ...[
              const SizedBox(height: 22),
              Row(
                children: [
                  AppButton(
                    label: 'Previous',
                    compact: true,
                    variant: AppButtonVariant.ghost,
                    onPressed: () => _move(-1),
                  ),
                  const SizedBox(width: 8),
                  AppButton(
                    label: 'Next',
                    compact: true,
                    variant: AppButtonVariant.outline,
                    onPressed: () => _move(1),
                  ),
                  const Spacer(),
                  Text(
                    '${(_index + 1).toString().padLeft(2, '0')} / ${testimonials.length.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({required this.testimonial, super.key});

  final TestimonialItem testimonial;

  @override
  Widget build(BuildContext context) {
    return TabletSurface(
      padding: const EdgeInsets.all(28),
      accent: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var index = 0; index < 5; index++)
                Icon(
                  index < testimonial.rating
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: AppColors.accent,
                  size: 18,
                ),
              const Spacer(),
              const Opacity(
                opacity: .16,
                child: AppIcon('quote', size: 42, color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '“${testimonial.content}”',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            testimonial.name,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 3),
          Text(
            [
              testimonial.role,
              testimonial.company,
            ].where((value) => value.trim().isNotEmpty).join(' • '),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTestimonials extends StatelessWidget {
  const _EmptyTestimonials();

  @override
  Widget build(BuildContext context) {
    return const TabletSurface(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'TESTIMONIALS ARE COMING SOON',
            style: TextStyle(
              color: AppColors.textMuted,
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
