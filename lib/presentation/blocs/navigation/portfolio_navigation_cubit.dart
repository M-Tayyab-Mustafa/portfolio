import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

class PortfolioNavigationState {
  const PortfolioNavigationState({
    required this.activeSection,
    required this.requestedSection,
    required this.scrollRequest,
    required this.scrollProgress,
    required this.isScrolled,
    required this.showBackToTop,
  });

  final PortfolioSection activeSection;
  final PortfolioSection requestedSection;
  final int scrollRequest;
  final double scrollProgress;
  final bool isScrolled;
  final bool showBackToTop;
}

class PortfolioNavigationCubit extends Cubit<PortfolioNavigationState> {
  PortfolioNavigationCubit({
    required PortfolioSection initialSection,
    required GoRouter router,
  }) : _router = router,
       super(
         PortfolioNavigationState(
           activeSection: initialSection,
           requestedSection: initialSection,
           scrollRequest: 0,
           scrollProgress: 0,
           isScrolled: false,
           showBackToTop: false,
         ),
       );

  final GoRouter _router;

  void navigateTo(PortfolioSection section) {
    _request(section);
    final currentPath = _router.routeInformationProvider.value.uri.path;
    if (currentPath != section.path) _router.go(section.path);
  }

  void openCaseStudy(String slug) {
    if (slug.isEmpty) return;
    _router.push(PortfolioRoute.caseStudyLocation(slug));
  }

  void routeChanged(PortfolioSection section) {
    if (state.scrollRequest > 0 && section == state.activeSection) return;
    _request(section);
  }

  void replaceRouteForScroll(PortfolioSection section) {
    final currentPath = _router.routeInformationProvider.value.uri.path;
    if (currentPath == section.path) return;
    _router.replace<void>(section.path);
  }

  void _request(PortfolioSection section) {
    emit(
      PortfolioNavigationState(
        activeSection: section,
        requestedSection: section,
        scrollRequest: state.scrollRequest + 1,
        scrollProgress: state.scrollProgress,
        isScrolled: state.isScrolled,
        showBackToTop: state.showBackToTop,
      ),
    );
  }

  void updateScroll({
    required double offset,
    required double maxScrollExtent,
    required double viewportHeight,
    required Map<PortfolioSection, double> sectionTopOffsets,
  }) {
    final safeMax = maxScrollExtent < 0 ? 0.0 : maxScrollExtent;
    final safeOffset = offset.clamp(0.0, safeMax).toDouble();
    var active = PortfolioSection.home;
    final marker = AppLayout.navigationHeight + viewportHeight * .33;
    for (final section in PortfolioSection.values) {
      final top = sectionTopOffsets[section];
      if (top != null && top <= marker) active = section;
    }
    if (safeMax > 0 && safeOffset >= safeMax - 8) {
      active = PortfolioSection.contact;
    }

    emit(
      PortfolioNavigationState(
        activeSection: active,
        requestedSection: state.requestedSection,
        scrollRequest: state.scrollRequest,
        scrollProgress: safeMax == 0 ? 0 : (safeOffset / safeMax).clamp(0, 1),
        isScrolled: safeOffset > 20,
        showBackToTop: safeOffset > 620,
      ),
    );
  }
}
