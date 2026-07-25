import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/data/services/email_js_contact_message_sender.dart';
import 'package:portfolio/presentation/blocs/contact/contact_bloc.dart';
import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/blocs/projects/projects_cubit.dart';
import 'package:portfolio/presentation/blocs/typewriter/typewriter_cubit.dart';
import 'package:portfolio/presentation/pages/web/sections/about_section.dart';
import 'package:portfolio/presentation/pages/web/sections/contact_section.dart';
import 'package:portfolio/presentation/pages/web/sections/experience_section.dart';
import 'package:portfolio/presentation/pages/web/sections/hero_section.dart';
import 'package:portfolio/presentation/pages/web/sections/projects_section.dart';
import 'package:portfolio/presentation/pages/web/sections/services_section.dart';
import 'package:portfolio/presentation/pages/web/sections/skills_section.dart';
import 'package:portfolio/presentation/pages/web/sections/testimonials_section.dart';
import 'package:portfolio/presentation/pages/web/widgets/desktop_only_fallback.dart';
import 'package:portfolio/presentation/pages/web/widgets/portfolio_footer.dart';
import 'package:portfolio/presentation/pages/web/widgets/portfolio_navbar.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';
import 'package:portfolio/presentation/widgets/app_toast.dart';
import 'package:portfolio/presentation/widgets/brand_loader.dart';
import 'package:portfolio/presentation/widgets/persistent_resume_button.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({required this.initialSection, super.key});

  final PortfolioSection initialSection;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioDataBloc, PortfolioDataState>(
      builder: (context, state) {
        if (state.isReady) {
          return _PortfolioProviders(
            initialSection: initialSection,
            content: state,
          );
        }
        if (state.status == PortfolioDataStatus.failure) {
          return _ContentFailure(message: state.errorMessage);
        }
        return const _ContentLoading();
      },
    );
  }
}

class _PortfolioProviders extends StatelessWidget {
  const _PortfolioProviders({
    required this.initialSection,
    required this.content,
  });

  final PortfolioSection initialSection;
  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PortfolioNavigationCubit(
            initialSection: initialSection,
            router: appRouter,
          ),
        ),
        BlocProvider(create: (_) => ProjectsCubit(content.projects)),
        BlocProvider(
          create: (_) => TypewriterCubit(
            content.profile.roles,
            reducedMotion: reducedMotion,
          ),
        ),
        BlocProvider(
          create: (_) => ContactBloc(
            ContactConfiguration.fromData(content),
            messageSender: EmailJsContactMessageSender(),
          ),
        ),
        BlocProvider(create: (_) => ExternalLinkCubit()),
      ],
      child: _TypewriterReducedMotionSync(
        reducedMotion: reducedMotion,
        child: MultiBlocListener(
          listeners: [
            BlocListener<PortfolioDataBloc, PortfolioDataState>(
              listenWhen: (previous, current) =>
                  current.isReady &&
                  (!previous.isReady ||
                      previous.projects != current.projects ||
                      previous.profile != current.profile ||
                      previous.emailJs != current.emailJs),
              listener: (context, state) {
                context.read<ProjectsCubit>().replaceProjects(state.projects);
                context.read<TypewriterCubit>().replaceRoles(
                  state.profile.roles,
                );
                context.read<ContactBloc>().add(
                  ContactConfigurationChanged(
                    ContactConfiguration.fromData(state),
                  ),
                );
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
            BlocListener<ContactBloc, ContactState>(
              listenWhen: (previous, current) =>
                  previous.feedbackId != current.feedbackId,
              listener: (context, state) {
                final message = state.feedbackMessage;
                if (message == null || message.isEmpty) return;
                AppToast.show(
                  context,
                  message: message,
                  type: state.status == ContactSubmissionStatus.success
                      ? AppToastType.success
                      : AppToastType.error,
                );
              },
            ),
          ],
          child: _PortfolioView(
            initialSection: initialSection,
            content: content,
          ),
        ),
      ),
    );
  }
}

class _TypewriterReducedMotionSync extends StatefulWidget {
  const _TypewriterReducedMotionSync({
    required this.reducedMotion,
    required this.child,
  });

  final bool reducedMotion;
  final Widget child;

  @override
  State<_TypewriterReducedMotionSync> createState() =>
      _TypewriterReducedMotionSyncState();
}

class _TypewriterReducedMotionSyncState
    extends State<_TypewriterReducedMotionSync> {
  @override
  void didUpdateWidget(covariant _TypewriterReducedMotionSync oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reducedMotion != widget.reducedMotion) {
      context.read<TypewriterCubit>().setReducedMotion(widget.reducedMotion);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _PortfolioView extends StatefulWidget {
  const _PortfolioView({required this.initialSection, required this.content});

  final PortfolioSection initialSection;
  final PortfolioDataState content;

  @override
  State<_PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<_PortfolioView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _footerKey = GlobalKey(debugLabel: 'portfolio-footer');
  bool _isProgrammaticScroll = false;
  double _resumeButtonBottom = 28;
  int _programmaticScrollId = 0;
  final Map<PortfolioSection, GlobalKey> _sectionKeys = {
    for (final section in PortfolioSection.values)
      section: GlobalKey(debugLabel: section.name),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_reportScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PortfolioNavigationCubit>().routeChanged(
          widget.initialSection,
        );
        _reportScroll();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _PortfolioView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSection != widget.initialSection) {
      context.read<PortfolioNavigationCubit>().routeChanged(
        widget.initialSection,
      );
    }
  }

  Future<void> _scrollToSection(PortfolioSection section) async {
    if (!_scrollController.hasClients) return;
    if (section == PortfolioSection.home) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    var sectionContext = _sectionKeys[section]?.currentContext;
    if (sectionContext == null) {
      await Future<void>.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;
      sectionContext = _sectionKeys[section]?.currentContext;
    }
    if (sectionContext == null || !_scrollController.hasClients) return;
    if (!sectionContext.mounted) return;

    final renderObject = sectionContext.findRenderObject();
    if (renderObject is! RenderBox) return;
    final target =
        (_scrollController.offset +
                renderObject.localToGlobal(Offset.zero).dy -
                AppLayout.navigationHeight +
                1)
            .clamp(0.0, _scrollController.position.maxScrollExtent)
            .toDouble();
    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 760),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _handleScrollRequest(PortfolioSection section) async {
    final scrollId = ++_programmaticScrollId;
    _isProgrammaticScroll = true;
    try {
      await _scrollToSection(section);
    } finally {
      if (scrollId == _programmaticScrollId) {
        _isProgrammaticScroll = false;
        if (mounted) _reportScroll();
      }
    }
  }

  void _reportScroll() {
    if (!_scrollController.hasClients || !mounted) return;
    final tops = <PortfolioSection, double>{};
    for (final entry in _sectionKeys.entries) {
      final renderObject = entry.value.currentContext?.findRenderObject();
      if (renderObject is RenderBox) {
        tops[entry.key] = renderObject.localToGlobal(Offset.zero).dy;
      }
    }
    final position = _scrollController.position;
    final footerRenderObject = _footerKey.currentContext?.findRenderObject();
    if (footerRenderObject is RenderBox) {
      final footerTop = footerRenderObject.localToGlobal(Offset.zero).dy;
      final visibleFooterHeight =
          (MediaQuery.sizeOf(context).height - footerTop).clamp(
            0.0,
            footerRenderObject.size.height,
          );
      final nextResumeButtonBottom = 28 + visibleFooterHeight;
      if ((nextResumeButtonBottom - _resumeButtonBottom).abs() > .5) {
        setState(() => _resumeButtonBottom = nextResumeButtonBottom);
      }
    }
    final navigation = context.read<PortfolioNavigationCubit>();
    final previousSection = navigation.state.activeSection;
    navigation.updateScroll(
      offset: position.pixels,
      maxScrollExtent: position.maxScrollExtent,
      viewportHeight: MediaQuery.sizeOf(context).height,
      sectionTopOffsets: tops,
    );
    final activeSection = navigation.state.activeSection;
    if (!_isProgrammaticScroll && activeSection != previousSection) {
      navigation.replaceRouteForScroll(activeSection);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_reportScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;
    if (MediaQuery.sizeOf(context).width < AppLayout.desktopMinimum) {
      return DesktopOnlyFallback(content: content);
    }

    return BlocListener<PortfolioNavigationCubit, PortfolioNavigationState>(
      listenWhen: (previous, current) =>
          previous.scrollRequest != current.scrollRequest,
      listener: (context, state) =>
          _handleScrollRequest(state.requestedSection),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Scrollbar(
              controller: _scrollController,
              child: RevealScrollScope(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  primary: false,
                  child: Column(
                    children: [
                      KeyedSubtree(
                        key: _sectionKeys[PortfolioSection.home],
                        child: HeroSection(content: content),
                      ),
                      KeyedSubtree(
                        key: _sectionKeys[PortfolioSection.about],
                        child: AboutSection(content: content),
                      ),
                      KeyedSubtree(
                        key: _sectionKeys[PortfolioSection.skills],
                        child: SkillsSection(content: content),
                      ),
                      KeyedSubtree(
                        key: _sectionKeys[PortfolioSection.services],
                        child: ServicesSection(content: content),
                      ),
                      KeyedSubtree(
                        key: _sectionKeys[PortfolioSection.projects],
                        child: ProjectsSection(content: content),
                      ),
                      KeyedSubtree(
                        key: _sectionKeys[PortfolioSection.experience],
                        child: ExperienceSection(content: content),
                      ),
                      TestimonialsSection(content: content),
                      KeyedSubtree(
                        key: _sectionKeys[PortfolioSection.contact],
                        child: ContactSection(content: content),
                      ),
                      PortfolioFooter(key: _footerKey, content: content),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child:
                  BlocBuilder<
                    PortfolioNavigationCubit,
                    PortfolioNavigationState
                  >(
                    buildWhen: (previous, current) =>
                        previous.activeSection != current.activeSection ||
                        previous.isScrolled != current.isScrolled,
                    builder: (context, state) => PortfolioNavbar(
                      content: content,
                      activeSection: state.activeSection,
                      isScrolled: state.isScrolled,
                    ),
                  ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child:
                    BlocSelector<
                      PortfolioNavigationCubit,
                      PortfolioNavigationState,
                      double
                    >(
                      selector: (state) => state.scrollProgress,
                      builder: (context, progress) => FractionallySizedBox(
                        widthFactor: progress,
                        child: const ColoredBox(color: AppColors.accent),
                      ),
                    ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: _resumeButtonBottom,
              child:
                  BlocSelector<
                    PortfolioNavigationCubit,
                    PortfolioNavigationState,
                    bool
                  >(
                    selector: (state) => state.showBackToTop,
                    builder: (context, visible) => IgnorePointer(
                      ignoring: !visible,
                      child: AnimatedOpacity(
                        opacity: visible ? 1 : 0,
                        duration: const Duration(milliseconds: 260),
                        child: AnimatedSlide(
                          offset: visible ? Offset.zero : const Offset(0, .35),
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          child: AppIconButton(
                            tooltip: 'Back to top',
                            size: 48,
                            onPressed: () => context
                                .read<PortfolioNavigationCubit>()
                                .navigateTo(PortfolioSection.home),
                            icon: const AppIcon('arrowUp'),
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
            Positioned(
              left: 28,
              bottom: _resumeButtonBottom,
              child: PersistentResumeButton(
                resumeUrl: content.link(PortfolioLinkKey.resumeUrl),
                ownerName: content.profile.fullName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentLoading extends StatelessWidget {
  const _ContentLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: BrandLoader(),
    );
  }
}

class _ContentFailure extends StatelessWidget {
  const _ContentFailure({this.message});

  final String? message;

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
                const AppIcon('cloud', size: 42, color: AppColors.accent),
                const SizedBox(height: 20),
                Text(
                  'CONTENT UNAVAILABLE',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  message ?? 'The portfolio could not be loaded.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 26),
                AppButton(
                  label: 'Retry Firestore',
                  onPressed: () => context.read<PortfolioDataBloc>().add(
                    const PortfolioDataRetryRequested(),
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
