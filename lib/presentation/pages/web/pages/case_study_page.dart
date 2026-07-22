import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/case_study/case_study_cubit.dart';
import 'package:portfolio/presentation/blocs/content/portfolio_content_bloc.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/app_toast.dart';
import 'package:portfolio/shared/widgets/brand_loader.dart';
import 'package:portfolio/shared/widgets/portfolio_image.dart';

class CaseStudyPage extends StatelessWidget {
  const CaseStudyPage({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioContentBloc, PortfolioContentState>(
      builder: (context, state) {
        final content = state.content;
        if (content != null) {
          return _CaseStudyProviders(content: content, slug: slug);
        }
        if (state.status == PortfolioContentStatus.failure) {
          return _CaseStudyLoadFailure(message: state.errorMessage);
        }
        return const _CaseStudyLoading();
      },
    );
  }
}

class _CaseStudyProviders extends StatelessWidget {
  const _CaseStudyProviders({required this.content, required this.slug});

  final PortfolioContent content;
  final String slug;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CaseStudyCubit(
            content: content,
            slug: slug,
            router: GoRouter.of(context),
          ),
        ),
        BlocProvider(create: (_) => ExternalLinkCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PortfolioContentBloc, PortfolioContentState>(
            listenWhen: (previous, current) =>
                previous.content != current.content && current.content != null,
            listener: (context, state) {
              context.read<CaseStudyCubit>().replaceContent(state.content!);
            },
          ),
          BlocListener<ExternalLinkCubit, ExternalLinkState>(
            listenWhen: (previous, current) =>
                previous.feedbackId != current.feedbackId,
            listener: (context, state) {
              final message = state.failureMessage;
              if (message == null || message.isEmpty) return;
              AppToast.show(
                context,
                message: message,
                type: AppToastType.error,
              );
            },
          ),
        ],
        child: _CaseStudyView(content: content),
      ),
    );
  }
}

class _CaseStudyView extends StatelessWidget {
  const _CaseStudyView({required this.content});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseStudyCubit, CaseStudyState>(
      builder: (context, state) {
        final project = state.project;
        if (project == null || !state.isAvailable) {
          return const _CaseStudyUnavailable();
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              Positioned(
                right: -150,
                top: -170,
                child: IgnorePointer(
                  child: Container(
                    width: 560,
                    height: 560,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: .15),
                          AppColors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _CaseStudyHeader(project: project),
                    Expanded(
                      child: SelectionArea(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 48),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1120),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppLayout.horizontalPadding(
                                    MediaQuery.sizeOf(context).width,
                                  ),
                                  vertical: 40,
                                ),
                                child: _CaseStudyBody(
                                  content: content,
                                  project: project,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CaseStudyHeader extends StatelessWidget {
  const _CaseStudyHeader({required this.project});

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: .96),
        border: const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppLayout.horizontalPadding(
                MediaQuery.sizeOf(context).width,
              ),
              vertical: 22,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CASE STUDY',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontFamily: 'monospace',
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        project.title.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                AppIconButton(
                  tooltip: 'Close case study',
                  size: 48,
                  onPressed: context.read<CaseStudyCubit>().closeCaseStudy,
                  icon: const AppIcon('close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CaseStudyBody extends StatelessWidget {
  const _CaseStudyBody({required this.content, required this.project});

  final PortfolioContent content;
  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    final caseStudy = project.caseStudy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 860;
            final image = _CaseStudyArtwork(project: project);
            final specs = _ProjectSpecs(project: project);
            if (!wide) {
              return Column(
                children: [image, const SizedBox(height: 24), specs],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 8, child: image),
                const SizedBox(width: 28),
                Expanded(flex: 4, child: specs),
              ],
            );
          },
        ),
        const SizedBox(height: 48),
        _ChallengeSolution(caseStudy: caseStudy),
        if (caseStudy.results.isNotEmpty) ...[
          const SizedBox(height: 48),
          _Outcomes(results: caseStudy.results),
        ],
        if (caseStudy.architecture.isNotEmpty) ...[
          const SizedBox(height: 48),
          _Architecture(architecture: caseStudy.architecture),
        ],
        const SizedBox(height: 52),
        const Divider(height: 1),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: Text(
                '${content.profile.fullName} // Portfolio case study'
                    .toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            TextButton(
              onPressed: context.read<CaseStudyCubit>().closeCaseStudy,
              child: const Text('BACK TO PROJECTS'),
            ),
          ],
        ),
      ],
    );
  }
}

class _CaseStudyArtwork extends StatelessWidget {
  const _CaseStudyArtwork({required this.project});

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (project.imageUrl.trim().isNotEmpty)
                PortfolioImage(
                  source: project.imageUrl,
                  fit: BoxFit.cover,
                  semanticLabel: project.title,
                )
              else
                _ArtworkFallback(project: project),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.transparent, Color(0xB3080808)],
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

class _ArtworkFallback extends StatelessWidget {
  const _ArtworkFallback({required this.project});

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF080808), Color(0xFF22090B), Color(0xFF120405)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(project.iconName, size: 48, color: AppColors.accent),
            const SizedBox(height: 12),
            Text(
              project.code,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'monospace',
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectSpecs extends StatelessWidget {
  const _ProjectSpecs({required this.project});

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    final caseStudy = project.caseStudy;
    final actions = _actionsFor(project);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROJECT SPECS',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 20),
          _SpecRow(iconName: 'person', label: 'My role', value: caseStudy.role),
          const SizedBox(height: 20),
          _SpecRow(
            iconName: 'calendar',
            label: 'Timeline',
            value: caseStudy.timeline,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppIcon('layers', size: 17, color: AppColors.accent),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SpecLabel('Technologies'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tag in project.tags)
                          _TechnologyTag(tag: tag),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 18),
            for (var index = 0; index < actions.length; index++) ...[
              _ExternalAction(
                label: actions[index].$1,
                url: actions[index].$2,
                iconName: actions[index].$3,
                primary: index == 0,
              ),
              if (index < actions.length - 1) const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }

  List<(String, String, String)> _actionsFor(PortfolioProject project) {
    final actions = <(String, String, String)>[];
    void add(String label, String? url, String iconName) {
      final value = url?.trim() ?? '';
      if (value.isNotEmpty && !actions.any((action) => action.$2 == value)) {
        actions.add((label, value, iconName));
      }
    }

    add('View repository', project.sourceUrl, 'github');
    add('View on Play Store', project.playStoreUrl, 'external');
    add('View on App Store', project.appStoreUrl, 'external');
    add('View on pub.dev', project.pubDevUrl, 'external');
    return actions;
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.iconName,
    required this.label,
    required this.value,
  });

  final String iconName;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIcon(iconName, size: 17, color: AppColors.accent),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SpecLabel(label),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpecLabel extends StatelessWidget {
  const _SpecLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: AppColors.textMuted,
        fontFamily: 'monospace',
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: .9,
      ),
    );
  }
}

class _TechnologyTag extends StatelessWidget {
  const _TechnologyTag({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(AppLayout.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text(
          tag.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'monospace',
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: .55,
          ),
        ),
      ),
    );
  }
}

class _ExternalAction extends StatelessWidget {
  const _ExternalAction({
    required this.label,
    required this.url,
    required this.iconName,
    required this.primary,
  });

  final String label;
  final String url;
  final String iconName;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      compact: true,
      expanded: true,
      variant: primary ? AppButtonVariant.primary : AppButtonVariant.outline,
      icon: AppIcon(iconName, size: 15, color: AppColors.textPrimary),
      onPressed: () => context.read<ExternalLinkCubit>().open(
        url: url,
        label: label,
        failureTemplate: '{label} could not be opened.',
      ),
    );
  }
}

class _ChallengeSolution extends StatelessWidget {
  const _ChallengeSolution({required this.caseStudy});

  final ProjectCaseStudy caseStudy;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final challenge = _NarrativeCard(
          title: 'The challenge',
          body: caseStudy.challenge,
          accent: false,
        );
        final solution = _NarrativeCard(
          title: 'The solution',
          body: caseStudy.solution,
          accent: true,
        );
        if (!wide) {
          return Column(
            children: [challenge, const SizedBox(height: 20), solution],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: challenge),
            const SizedBox(width: 24),
            Expanded(child: solution),
          ],
        );
      },
    );
  }
}

class _NarrativeCard extends StatelessWidget {
  const _NarrativeCard({
    required this.title,
    required this.body,
    required this.accent,
  });

  final String title;
  final String body;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: accent
            ? AppColors.surface
            : AppColors.surface.withValues(alpha: .5),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: -28,
            child: Container(
              width: 64,
              height: 3,
              color: accent ? AppColors.accent : AppColors.textMuted,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: accent ? AppColors.accent : AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.65,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Outcomes extends StatelessWidget {
  const _Outcomes({required this.results});

  final List<CaseStudyResult> results;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SubsectionTitle(title: 'Key outcomes'),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 760 ? 3 : 1;
            const gap = 18.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final result in results)
                  SizedBox(
                    width: width,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 148),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.metric.toUpperCase(),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            result.label.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              letterSpacing: .65,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Architecture extends StatelessWidget {
  const _Architecture({required this.architecture});

  final List<String> architecture;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 24),
        const _SubsectionTitle(title: 'Technical architecture'),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final item in architecture)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppLayout.radius),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        item.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SubsectionTitle extends StatelessWidget {
  const _SubsectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.accent,
            fontFamily: 'monospace',
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(child: Divider(height: 1)),
      ],
    );
  }
}

class _CaseStudyUnavailable extends StatelessWidget {
  const _CaseStudyUnavailable();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppIcon('repository', size: 44, color: AppColors.accent),
                const SizedBox(height: 20),
                Text(
                  'CASE STUDY NOT FOUND',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'This project case study is unavailable or has been unpublished.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 26),
                AppButton(
                  label: 'Back to projects',
                  onPressed: context.read<CaseStudyCubit>().closeCaseStudy,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CaseStudyLoading extends StatelessWidget {
  const _CaseStudyLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: BrandLoader(),
    );
  }
}

class _CaseStudyLoadFailure extends StatelessWidget {
  const _CaseStudyLoadFailure({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            message ?? 'The case study could not be loaded from Firestore.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
