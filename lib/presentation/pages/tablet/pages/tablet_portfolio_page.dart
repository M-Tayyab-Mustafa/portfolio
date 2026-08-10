import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';
import 'package:portfolio/presentation/pages/tablet/sections/tablet_contact_section.dart';
import 'package:portfolio/presentation/pages/tablet/sections/tablet_hero_section.dart';
import 'package:portfolio/presentation/pages/tablet/sections/tablet_profile_sections.dart';
import 'package:portfolio/presentation/pages/tablet/sections/tablet_work_sections.dart';
import 'package:portfolio/presentation/pages/tablet/widgets/tablet_navigation_bar.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';
import 'package:portfolio/presentation/widgets/brand_logo.dart';
import 'package:portfolio/presentation/widgets/persistent_resume_button.dart';

class TabletPortfolioPage extends StatefulWidget {
  const TabletPortfolioPage({
    required this.initialSection,
    required this.content,
    super.key,
  });

  final PortfolioSection initialSection;
  final PortfolioDataState content;

  @override
  State<TabletPortfolioPage> createState() => _TabletPortfolioPageState();
}

class _TabletPortfolioPageState extends State<TabletPortfolioPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _footerKey = GlobalKey(debugLabel: 'tablet-footer');
  final ValueNotifier<double> _floatingBottom = ValueNotifier(22);
  final Map<PortfolioSection, GlobalKey> _sectionKeys = {
    for (final section in PortfolioSection.values)
      section: GlobalKey(debugLabel: 'tablet-${section.name}'),
  };
  final Map<PortfolioSection, double> _sectionOffsets = {};

  bool _isProgrammaticScroll = false;
  bool _reportScheduled = false;
  double _measuredMaxScrollExtent = -1;
  double? _footerOffset;
  double _footerHeight = 0;
  int _scrollRequestId = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_reportScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PortfolioNavigationCubit>().routeChanged(
        widget.initialSection,
      );
      _reportScroll();
    });
  }

  @override
  void didUpdateWidget(covariant TabletPortfolioPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSection != widget.initialSection) {
      context.read<PortfolioNavigationCubit>().routeChanged(
        widget.initialSection,
      );
    }
  }

  Future<void> _handleScrollRequest(PortfolioSection section) async {
    final requestId = ++_scrollRequestId;
    _isProgrammaticScroll = true;
    try {
      if (!_scrollController.hasClients) return;
      if (section == PortfolioSection.home) {
        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 620),
          curve: Curves.easeInOutCubic,
        );
        return;
      }

      var sectionContext = _sectionKeys[section]?.currentContext;
      if (sectionContext == null) {
        await Future<void>.delayed(const Duration(milliseconds: 60));
        if (!mounted) return;
        sectionContext = _sectionKeys[section]?.currentContext;
      }
      if (sectionContext == null || !sectionContext.mounted) return;
      final renderObject = sectionContext.findRenderObject();
      if (renderObject is! RenderBox || !_scrollController.hasClients) return;
      final target =
          (_scrollController.offset +
                  renderObject.localToGlobal(Offset.zero).dy -
                  AppLayout.tabletNavigationHeight +
                  1)
              .clamp(0.0, _scrollController.position.maxScrollExtent)
              .toDouble();
      await _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    } finally {
      if (requestId == _scrollRequestId) {
        _isProgrammaticScroll = false;
        if (mounted) _reportScroll();
      }
    }
  }

  void _reportScroll() {
    if (!_scrollController.hasClients || !mounted || _reportScheduled) return;
    _reportScheduled = true;
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      _reportScheduled = false;
      _flushScrollReport();
    });
  }

  void _measureLayout(ScrollPosition position) {
    _sectionOffsets.clear();
    for (final entry in _sectionKeys.entries) {
      final renderObject = entry.value.currentContext?.findRenderObject();
      if (renderObject is RenderBox) {
        _sectionOffsets[entry.key] =
            position.pixels + renderObject.localToGlobal(Offset.zero).dy;
      }
    }
    final footer = _footerKey.currentContext?.findRenderObject();
    if (footer is RenderBox) {
      _footerOffset = position.pixels + footer.localToGlobal(Offset.zero).dy;
      _footerHeight = footer.size.height;
    }
    _measuredMaxScrollExtent = position.maxScrollExtent;
  }

  void _flushScrollReport() {
    if (!_scrollController.hasClients || !mounted) return;
    final position = _scrollController.position;
    if (_sectionOffsets.length != PortfolioSection.values.length ||
        (position.maxScrollExtent - _measuredMaxScrollExtent).abs() > .5) {
      _measureLayout(position);
    }

    final viewportHeight = MediaQuery.sizeOf(context).height;
    final tops = <PortfolioSection, double>{
      for (final entry in _sectionOffsets.entries)
        entry.key: entry.value - position.pixels,
    };
    final footerOffset = _footerOffset;
    if (footerOffset != null) {
      final footerTop = footerOffset - position.pixels;
      final visibleHeight = (viewportHeight - footerTop).clamp(
        0.0,
        _footerHeight,
      );
      final bottom = 22 + visibleHeight;
      if ((bottom - _floatingBottom.value).abs() > .5) {
        _floatingBottom.value = bottom;
      }
    }

    final navigation = context.read<PortfolioNavigationCubit>();
    final previous = navigation.state.activeSection;
    navigation.updateScroll(
      offset: position.pixels,
      maxScrollExtent: position.maxScrollExtent,
      viewportHeight: viewportHeight,
      sectionTopOffsets: tops,
    );
    final active = navigation.state.activeSection;
    if (!_isProgrammaticScroll && active != previous) {
      navigation.replaceRouteForScroll(active);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_reportScroll)
      ..dispose();
    _floatingBottom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;

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
              child: SingleChildScrollView(
                controller: _scrollController,
                primary: false,
                child: Column(
                  children: [
                    KeyedSubtree(
                      key: _sectionKeys[PortfolioSection.home],
                      child: TabletHeroSection(content: content),
                    ),
                    KeyedSubtree(
                      key: _sectionKeys[PortfolioSection.about],
                      child: _DeferredTabletSection(
                        loaded: content.hasStats,
                        child: TabletAboutSection(content: content),
                      ),
                    ),
                    KeyedSubtree(
                      key: _sectionKeys[PortfolioSection.skills],
                      child: _DeferredTabletSection(
                        loaded: content.hasSkillGroups,
                        child: TabletSkillsSection(content: content),
                      ),
                    ),
                    KeyedSubtree(
                      key: _sectionKeys[PortfolioSection.services],
                      child: _DeferredTabletSection(
                        loaded: content.hasServices,
                        child: TabletServicesSection(content: content),
                      ),
                    ),
                    KeyedSubtree(
                      key: _sectionKeys[PortfolioSection.projects],
                      child: _DeferredTabletSection(
                        loaded: content.hasProjects,
                        child: TabletProjectsSection(content: content),
                      ),
                    ),
                    KeyedSubtree(
                      key: _sectionKeys[PortfolioSection.experience],
                      child: _DeferredTabletSection(
                        loaded: content.hasExperiences,
                        child: TabletExperienceSection(content: content),
                      ),
                    ),
                    _DeferredTabletSection(
                      loaded: content.hasTestimonials,
                      child: TabletTestimonialsSection(content: content),
                    ),
                    KeyedSubtree(
                      key: _sectionKeys[PortfolioSection.contact],
                      child: _DeferredTabletSection(
                        loaded:
                            content.hasContactChannels && content.hasEmailJs,
                        child: TabletContactSection(content: content),
                      ),
                    ),
                    _TabletFooter(key: _footerKey, content: content),
                  ],
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
                    builder: (context, state) => TabletNavigationBar(
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
            ValueListenableBuilder<double>(
              valueListenable: _floatingBottom,
              builder: (context, bottom, child) =>
                  Positioned(right: 20, bottom: bottom, child: child!),
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
                        duration: const Duration(milliseconds: 220),
                        child: AppIconButton(
                          size: 46,
                          tooltip: 'Back to top',
                          onPressed: () => context
                              .read<PortfolioNavigationCubit>()
                              .navigateTo(PortfolioSection.home),
                          icon: const AppIcon('arrowUp', size: 18),
                        ),
                      ),
                    ),
                  ),
            ),
            ValueListenableBuilder<double>(
              valueListenable: _floatingBottom,
              builder: (context, bottom, child) =>
                  Positioned(left: 20, bottom: bottom, child: child!),
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

class _DeferredTabletSection extends StatelessWidget {
  const _DeferredTabletSection({required this.loaded, required this.child});

  final bool loaded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (loaded) return child;
    return const SizedBox(height: 420);
  }
}

class _TabletFooter extends StatelessWidget {
  const _TabletFooter({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.tabletContentMaxWidth,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppLayout.tabletHorizontalPadding(width),
              24,
              AppLayout.tabletHorizontalPadding(width),
              26,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BrandLogo(
                        profile: content.profile,
                        semanticLabel: content.profile.fullName,
                        compact: true,
                      ),
                      const SizedBox(height: 9),
                      Text(
                        '© ${DateTime.now().year} ${content.profile.fullName}. Built with Flutter.',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontFamily: 'monospace',
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final social in content.socials.take(3))
                      AppIconButton(
                        size: 36,
                        tooltip: social.label,
                        onPressed: () => context.read<ExternalLinkCubit>().open(
                          url: social.url,
                          label: social.label,
                          failureTemplate: '{label} could not be opened.',
                        ),
                        icon: AppIcon(social.iconName, size: 15),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
