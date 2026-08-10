import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/blocs/projects/projects_cubit.dart';
import 'package:portfolio/presentation/pages/mobile/sections/mobile_projects_archive_section.dart';
import 'package:portfolio/presentation/widgets/portfolio_back_button.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';
import 'package:portfolio/presentation/widgets/app_toast.dart';
import 'package:portfolio/presentation/widgets/brand_logo.dart';
import 'package:portfolio/presentation/widgets/brand_loader.dart';
import 'package:portfolio/presentation/widgets/persistent_resume_button.dart';

class MobileProjectsPage extends StatelessWidget {
  const MobileProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioDataBloc, PortfolioDataState>(
      builder: (context, state) {
        if (!state.isReady || !state.hasProjects) return const BrandLoader();
        return _ProjectsPageProviders(content: state);
      },
    );
  }
}

class _ProjectsPageProviders extends StatelessWidget {
  const _ProjectsPageProviders({required this.content});

  final PortfolioDataState content;

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

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final mobile = AppLayout.isMobile(MediaQuery.sizeOf(context).width);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(mobile ? 64 : 72),
        child: _ProjectsHeader(content: content),
      ),
      body: Stack(
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
            child: MobileProjectsArchiveSection(
              content: content,
              showAllProjects: true,
            ),
          ),
          Positioned(
            left: mobile ? 16 : 28,
            bottom: mobile ? 16 : 28,
            child: PersistentResumeButton(
              resumeUrl: content.link(PortfolioLinkKey.resumeUrl),
              ownerName: content.profile.fullName,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectsHeader extends StatelessWidget {
  const _ProjectsHeader({required this.content});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = AppLayout.isMobile(width);
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
              vertical: mobile ? 10 : 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: PortfolioBackButton(onPressed: () => context.pop()),
                  ),
                ),
                BrandLogo(
                  profile: content.profile,
                  semanticLabel: content.profile.fullName,
                  compact: true,
                  showWordmark: width >= 390,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: mobile
                        ? const SizedBox(width: 44)
                        : DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.textPrimary.withValues(
                                alpha: .05,
                              ),
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(
                                AppLayout.radius,
                              ),
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
