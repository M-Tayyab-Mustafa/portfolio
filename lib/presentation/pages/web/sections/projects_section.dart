import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/blocs/projects/projects_cubit.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/hover_surface.dart';
import 'package:portfolio/shared/widgets/portfolio_image.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_container.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_header.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({
    required this.content,
    super.key,
    this.showAllProjects = false,
  });

  final PortfolioContent content;
  final bool showAllProjects;

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  static const _initialProjectLimit = 6;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsCubit, ProjectsState>(
      builder: (context, state) {
        final projects = widget.showAllProjects
            ? state.visibleProjects
            : state.visibleProjects.take(_initialProjectLimit).toList();
        final hasMoreProjects =
            state.visibleProjects.length > _initialProjectLimit;
        return SectionContainer(
          ambientAlignment: Alignment.bottomCenter,
          ambientOpacity: .06,
          child: Column(
            children: [
              RevealOnScroll(
                child: SectionHeader(
                  eyebrow: widget.showAllProjects
                      ? 'COMPLETE DIGITAL ARCHIVE'
                      : widget.content.heading('projects').eyebrow,
                  title: widget.showAllProjects
                      ? 'All'
                      : widget.content.heading('projects').title,
                  accentTitle: widget.showAllProjects
                      ? 'Projects Gallery'
                      : widget.content.heading('projects').accentTitle,
                ),
              ),
              if (widget.showAllProjects) ...[
                const SizedBox(height: 18),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: const Text(
                    'Explore the complete showcase of production applications, packages, integrations, and UI engineering built with Flutter.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                _ProjectArchiveControls(
                  content: widget.content,
                  state: state,
                  searchController: _searchController,
                ),
              ] else ...[
                const SizedBox(height: 48),
                RevealOnScroll(
                  child: _ProjectFilters(content: widget.content, state: state),
                ),
              ],
              const SizedBox(height: 54),
              if (state.visibleProjects.isEmpty)
                widget.showAllProjects
                    ? _EmptyProjectArchive(
                        searchController: _searchController,
                        searchQuery: state.searchQuery,
                      )
                    : Padding(
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
                          for (final entry in projects.indexed)
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
                                  content: widget.content,
                                  project: entry.$2,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              if (!widget.showAllProjects && hasMoreProjects) ...[
                const SizedBox(height: 64),
                RevealOnScroll(
                  child: _ViewAllProjectsButton(
                    projectCount: state.allProjects.length,
                    onPressed: () => context.push(PortfolioRoute.projectsPath),
                  ),
                ),
              ],
              if (widget.showAllProjects) ...[
                const SizedBox(height: 80),
                const _ProjectsCallToAction(),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ViewAllProjectsButton extends StatefulWidget {
  const _ViewAllProjectsButton({
    required this.projectCount,
    required this.onPressed,
  });

  final int projectCount;
  final VoidCallback onPressed;

  @override
  State<_ViewAllProjectsButton> createState() => _ViewAllProjectsButtonState();
}

class _ViewAllProjectsButtonState extends State<_ViewAllProjectsButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accent : AppColors.surface,
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.borderStrong,
            ),
            borderRadius: BorderRadius.circular(AppLayout.radius),
            boxShadow: const [
              BoxShadow(
                color: Color(0xCC000000),
                blurRadius: 28,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: TextButton(
            onPressed: widget.onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              backgroundColor: AppColors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              minimumSize: const Size(48, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppLayout.radius),
              ),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.35,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('VIEW ALL PROJECTS (${widget.projectCount})'),
                const SizedBox(width: 12),
                AnimatedSlide(
                  offset: _hovered ? const Offset(.38, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  child: AppIcon(
                    'arrowLongRight',
                    size: 16,
                    color: _hovered ? AppColors.textPrimary : AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyProjectArchive extends StatelessWidget {
  const _EmptyProjectArchive({
    required this.searchController,
    required this.searchQuery,
  });

  final TextEditingController searchController;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppLayout.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          children: [
            const Icon(
              Icons.filter_alt_off_outlined,
              color: AppColors.accent,
              size: 44,
            ),
            const SizedBox(height: 18),
            const Text(
              'NO PROJECTS FOUND',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              searchQuery.trim().isEmpty
                  ? 'No projects match the selected category.'
                  : 'No projects match “${searchQuery.trim()}”. Try another search or category.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Reset all filters',
              compact: true,
              onPressed: () {
                searchController.clear();
                final cubit = context.read<ProjectsCubit>();
                cubit.search('');
                cubit.selectCategory(ProjectCategory.all);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectFilters extends StatelessWidget {
  const _ProjectFilters({required this.content, required this.state});

  final PortfolioContent content;
  final ProjectsState state;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in ProjectCategory.values)
          if (category == ProjectCategory.all ||
              state.allProjects.any((project) => project.category == category))
            _FilterButton(
              label: content.categoryLabel(category),
              selected: category == state.selectedCategory,
              onPressed: () =>
                  context.read<ProjectsCubit>().selectCategory(category),
            ),
      ],
    );
  }
}

class _ProjectArchiveControls extends StatelessWidget {
  const _ProjectArchiveControls({
    required this.content,
    required this.state,
    required this.searchController,
  });

  final PortfolioContent content;
  final ProjectsState state;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppLayout.radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 390,
                  child: TextField(
                    controller: searchController,
                    onChanged: context.read<ProjectsCubit>().search,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Search projects by name, technology, tag...',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      suffixIcon: state.searchQuery.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: () {
                                searchController.clear();
                                context.read<ProjectsCubit>().search('');
                              },
                              icon: const Icon(Icons.close, size: 17),
                            ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.borderStrong),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const AppIcon('layers', size: 16, color: AppColors.accent),
                const SizedBox(width: 8),
                Text(
                  'Showing ${state.visibleProjects.length} of ${state.allProjects.length} Projects',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Divider(height: 1),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 13, right: 14),
                  child: Text(
                    'FILTER:',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Expanded(
                  child: Wrap(
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
                            count: category == ProjectCategory.all
                                ? state.allProjects.length
                                : state.allProjects
                                      .where(
                                        (project) =>
                                            project.category == category,
                                      )
                                      .length,
                            selected: category == state.selectedCategory,
                            onPressed: () => context
                                .read<ProjectsCubit>()
                                .selectCategory(category),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectsCallToAction extends StatelessWidget {
  const _ProjectsCallToAction();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppLayout.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HAVE A PROJECT IN MIND?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Let's collaborate to bring your digital vision to life.",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            AppButton(
              label: 'Back to portfolio',
              variant: AppButtonVariant.outline,
              compact: true,
              onPressed: () => context.go(PortfolioSection.projects.path),
            ),
            const SizedBox(width: 12),
            AppButton(
              label: 'Get in touch',
              compact: true,
              onPressed: () => context.go(PortfolioSection.contact.path),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onPressed,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final int? count;

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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.05,
            ),
          ),
          if (count case final value?) ...[
            const SizedBox(width: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.background.withValues(alpha: .3)
                    : AppColors.elevatedSurface,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  '$value',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 9),
                ),
              ),
            ),
          ],
        ],
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
    final primaryAction = _primaryActionFor(project);
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
                          OutlinedButton.icon(
                            onPressed: () => context
                                .read<PortfolioNavigationCubit>()
                                .openCaseStudy(project.slug),
                            icon: const AppIcon('external', size: 15),
                            label: const Text('CASE STUDY'),
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
                          const Spacer(),
                          if (primaryAction != null)
                            TextButton.icon(
                              onPressed: () =>
                                  context.read<ExternalLinkCubit>().open(
                                    url: primaryAction.$2,
                                    label: primaryAction.$1,
                                    failureTemplate:
                                        '{label} could not be opened.',
                                  ),
                              icon: const AppIcon('external', size: 15),
                              label: Text(primaryAction.$1.toUpperCase()),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 8,
                                ),
                                minimumSize: const Size(48, 40),
                                textStyle: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .7,
                                ),
                              ),
                            ),
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

  (String, String)? _primaryActionFor(PortfolioProject project) {
    (String, String)? action(String label, String? url) {
      final value = url?.trim() ?? '';
      return value.isEmpty ? null : (label, value);
    }

    return action('Play Store', project.playStoreUrl) ??
        action('App Store', project.appStoreUrl) ??
        action('pub.dev', project.pubDevUrl) ??
        action('View Repo', project.sourceUrl);
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
                    semanticLabel: '${project.title} project thumbnail',
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
                      (project.projectType.trim().isNotEmpty &&
                                  project.projectType != 'Application'
                              ? project.projectType
                              : categoryLabel)
                          .toUpperCase(),
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
