import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/blocs/projects/projects_cubit.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/hover_surface.dart';
import 'package:portfolio/shared/widgets/portfolio_image.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_container.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_header.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({required this.content, super.key});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsCubit, ProjectsState>(
      builder: (context, state) {
        return SectionContainer(
          ambientAlignment: Alignment.bottomCenter,
          ambientOpacity: .06,
          child: Column(
            children: [
              RevealOnScroll(
                child: SectionHeader(
                  eyebrow: content.heading('projects').eyebrow,
                  title: content.heading('projects').title,
                  accentTitle: content.heading('projects').accentTitle,
                ),
              ),
              const SizedBox(height: 48),
              RevealOnScroll(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final category in ProjectCategory.values)
                      if (category == ProjectCategory.all ||
                          state.allProjects.any(
                            (project) => project.category == category,
                          ))
                        _FilterButton(
                          label: content.categoryLabel(category),
                          selected: category == state.selectedCategory,
                          onPressed: () => context
                              .read<ProjectsCubit>()
                              .selectCategory(category),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 54),
              if (state.visibleProjects.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 70),
                  child: Text(
                    'No projects are currently published in this category.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth < 700
                        ? 1
                        : constraints.maxWidth < 1080
                        ? 2
                        : 3;
                    const gap = 24.0;
                    final cardWidth =
                        (constraints.maxWidth - gap * (columns - 1)) / columns;
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 420),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: .97,
                              end: 1,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Wrap(
                        key: ValueKey(state.selectedCategory),
                        spacing: gap,
                        runSpacing: gap,
                        children: [
                          for (final entry in state.visibleProjects.indexed)
                            SizedBox(
                              width: cardWidth,
                              child: RevealOnScroll(
                                key: ValueKey(
                                  '${state.selectedCategory.name}-${entry.$2.title}',
                                ),
                                delay: Duration(
                                  milliseconds: (entry.$1 % columns) * 70,
                                ),
                                child: _ProjectCard(
                                  content: content,
                                  project: entry.$2,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
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
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(48, 44)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.radius),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (selected) return AppColors.accent;
          if (states.contains(WidgetState.hovered)) {
            return AppColors.elevatedSurface;
          }
          return AppColors.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (selected || states.contains(WidgetState.hovered)) {
            return AppColors.textPrimary;
          }
          return AppColors.textSecondary;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const BorderSide(color: AppColors.textPrimary, width: 2);
          }
          if (selected) return BorderSide.none;
          return BorderSide(
            color: states.contains(WidgetState.hovered)
                ? AppColors.accent.withValues(alpha: .45)
                : AppColors.border,
          );
        }),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.05,
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.content, required this.project});

  final PortfolioContent content;
  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    return HoverSurface(
      padding: EdgeInsets.zero,
      builder: (context, hovered) => Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProjectArtwork(
                project: project,
                categoryLabel: content.categoryLabel(project.category),
                hovered: hovered,
              ),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(26, 24, 26, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: [
                          for (final tag in project.tags)
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(
                                  AppLayout.radius,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                child: Text(
                                  tag.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: .55,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 260),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 19,
                          color: hovered
                              ? AppColors.accent
                              : AppColors.textPrimary,
                        ),
                        child: Text(project.title),
                      ),
                      const SizedBox(height: 9),
                      Expanded(
                        child: Text(
                          project.description,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                        ),
                      ),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () =>
                                    context.read<ExternalLinkCubit>().open(
                                      url: project.url,
                                      label: project.destinationLabel,
                                      failureTemplate:
                                          '{label} could not be opened.',
                                    ),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.textPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  minimumSize: const Size(48, 42),
                                  alignment: Alignment.centerLeft,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const AppIcon('external', size: 16),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        project.destinationLabel.toUpperCase(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (project.caseStudy.isAvailable) ...[
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () => context
                                  .read<PortfolioNavigationCubit>()
                                  .openCaseStudy(project.slug),
                              icon: const AppIcon('external', size: 15),
                              label: Text('CASE STUDY'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.textSecondary,
                                side: BorderSide(
                                  color: hovered
                                      ? AppColors.accent.withValues(alpha: .45)
                                      : AppColors.borderStrong,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 10,
                                ),
                                minimumSize: const Size(48, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppLayout.radius,
                                  ),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .9,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 430),
              width: 2,
              color: hovered ? AppColors.accent : AppColors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectArtwork extends StatelessWidget {
  const _ProjectArtwork({
    required this.project,
    required this.categoryLabel,
    required this.hovered,
  });

  final PortfolioProject project;
  final String categoryLabel;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRect(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (project.imageUrl.trim().isNotEmpty)
                AnimatedScale(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  scale: hovered ? 1.08 : 1,
                  child: PortfolioImage(
                    source: project.imageUrl,
                    fit: BoxFit.cover,
                    semanticLabel: project.title,
                  ),
                )
              else
                _ProjectArtworkFallback(project: project, hovered: hovered),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: AppColors.accent.withValues(alpha: hovered ? .1 : 0),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: .82),
                    border: Border.all(color: AppColors.borderStrong),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    child: Text(
                      categoryLabel.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .8,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectArtworkFallback extends StatelessWidget {
  const _ProjectArtworkFallback({required this.project, required this.hovered});

  final PortfolioProject project;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF080808), Color(0xFF1B090A), Color(0xFF120405)],
        ),
      ),
      child: Center(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOutCubic,
          scale: hovered ? 1.08 : 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(project.iconName, size: 42, color: AppColors.accent),
              const SizedBox(height: 9),
              Text(
                project.code,
                style: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: .82),
                  fontFamily: 'monospace',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
