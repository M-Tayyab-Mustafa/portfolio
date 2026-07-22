import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/content/portfolio_content_bloc.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/blocs/projects/projects_cubit.dart';
import 'package:portfolio/presentation/pages/web/sections/projects_section.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/app_toast.dart';
import 'package:portfolio/shared/widgets/brand_loader.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioContentBloc, PortfolioContentState>(
      builder: (context, state) {
        final content = state.content;
        if (content == null) return const BrandLoader();
        return _ProjectsPageProviders(content: content);
      },
    );
  }
}

class _ProjectsPageProviders extends StatelessWidget {
  const _ProjectsPageProviders({required this.content});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProjectsCubit(content.projects)),
        BlocProvider(create: (_) => ExternalLinkCubit()),
        BlocProvider(
          create: (_) => PortfolioNavigationCubit(
            initialSection: PortfolioSection.projects,
            router: appRouter,
          ),
        ),
      ],
      child: BlocListener<ExternalLinkCubit, ExternalLinkState>(
        listenWhen: (previous, current) =>
            previous.feedbackId != current.feedbackId,
        listener: (context, state) {
          final message = state.failureMessage;
          if (message == null || message.isEmpty) return;
          AppToast.show(context, message: message, type: AppToastType.error);
        },
        child: _ProjectsPageView(content: content),
      ),
    );
  }
}

class _ProjectsPageView extends StatelessWidget {
  const _ProjectsPageView({required this.content});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _ProjectsHeader(content: content),
      ),
      body: SelectionArea(
        child: Stack(
          children: [
            Positioned(
              top: -220,
              left: MediaQuery.sizeOf(context).width / 2 - 400,
              child: IgnorePointer(
                child: Container(
                  width: 800,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: .1),
                        AppColors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: ProjectsSection(content: content, showAllProjects: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectsHeader extends StatelessWidget {
  const _ProjectsHeader({required this.content});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: .94),
        border: const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.contentMaxWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppLayout.horizontalPadding(width),
              vertical: 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _ArchiveBackButton(onPressed: () => context.pop()),
                  ),
                ),
                _ArchiveBrandLogo(
                  firstName: content.profile.firstName,
                  lastName: content.profile.lastName,
                  onPressed: () => context.go(PortfolioSection.home.path),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withValues(alpha: .05),
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppLayout.radius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppIcon(
                              'layers',
                              size: 14,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 7),
                            Text.rich(
                              TextSpan(
                                text: 'Total Projects: ',
                                children: [
                                  TextSpan(
                                    text: '${content.projects.length}',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontFamily: 'monospace',
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class _ArchiveBackButton extends StatefulWidget {
  const _ArchiveBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_ArchiveBackButton> createState() => _ArchiveBackButtonState();
}

class _ArchiveBackButtonState extends State<_ArchiveBackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(
            color: _hovered ? AppColors.accent : AppColors.borderStrong,
          ),
          borderRadius: BorderRadius.circular(AppLayout.radius),
        ),
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            foregroundColor: _hovered
                ? AppColors.textPrimary
                : AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            minimumSize: const Size(48, 40),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSlide(
                offset: _hovered ? const Offset(-.25, 0) : Offset.zero,
                duration: const Duration(milliseconds: 300),
                child: const AppIcon(
                  'arrowLeft',
                  size: 15,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'BACK TO PORTFOLIO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArchiveBrandLogo extends StatefulWidget {
  const _ArchiveBrandLogo({
    required this.firstName,
    required this.lastName,
    required this.onPressed,
  });

  final String firstName;
  final String lastName;
  final VoidCallback onPressed;

  @override
  State<_ArchiveBrandLogo> createState() => _ArchiveBrandLogoState();
}

class _ArchiveBrandLogoState extends State<_ArchiveBrandLogo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(48, 48),
          foregroundColor: AppColors.textPrimary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF0C0C0C),
                border: Border.all(
                  color: _hovered ? AppColors.accent : AppColors.borderStrong,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 6,
                    right: 6,
                    top: 6,
                    child: Container(
                      height: 1.5,
                      color: AppColors.borderStrong,
                    ),
                  ),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'M',
                        children: [
                          TextSpan(
                            text: '//',
                            style: TextStyle(
                              color: _hovered
                                  ? AppColors.textPrimary
                                  : AppColors.accent,
                            ),
                          ),
                          const TextSpan(text: 'T'),
                        ],
                      ),
                      style: TextStyle(
                        color: _hovered
                            ? AppColors.accent
                            : AppColors.textPrimary,
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 4,
                    bottom: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox.square(dimension: 4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.firstName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.lastName.toUpperCase(),
                  style: TextStyle(
                    color: _hovered ? AppColors.textPrimary : AppColors.accent,
                    fontFamily: 'monospace',
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    height: 1,
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
