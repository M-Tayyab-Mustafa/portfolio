import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/presentation/pages/mobile/pages/mobile_case_study_page.dart';
import 'package:portfolio/presentation/pages/mobile/pages/mobile_portfolio_page.dart';
import 'package:portfolio/presentation/pages/mobile/pages/mobile_projects_page.dart';
import 'package:portfolio/presentation/pages/mobile/pages/mobile_testimonial_submission_page.dart';
import 'package:portfolio/presentation/pages/tablet/pages/tablet_case_study_page.dart';
import 'package:portfolio/presentation/pages/tablet/pages/tablet_portfolio_page.dart';
import 'package:portfolio/presentation/pages/tablet/pages/tablet_projects_page.dart';
import 'package:portfolio/presentation/pages/tablet/pages/tablet_testimonial_submission_page.dart';
import 'package:portfolio/presentation/pages/web/pages/case_study_page.dart';
import 'package:portfolio/presentation/pages/web/pages/not_found_page.dart';
import 'package:portfolio/presentation/pages/web/pages/projects_page.dart';
import 'package:portfolio/presentation/pages/web/pages/testimonial_submission_page.dart';
import 'package:portfolio/presentation/pages/web/pages/web_portfolio_page.dart';
import 'package:responsive_framework/responsive_framework.dart';

GoRouter? _appRouter;

// Called from main after the path URL strategy is configured and before the
// temporary startup MaterialApp can replace a browser deep link with `/`.
void initializeAppRouter() {
  _appRouter ??= _createAppRouter();
}

GoRouter get appRouter => _appRouter ??= _createAppRouter();

GoRouter _createAppRouter() {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  final browserLocation = urlStrategy?.getPath();

  return GoRouter(
    initialLocation: browserLocation ?? PortfolioSection.home.path,
    overridePlatformDefaultLocation: browserLocation != null,
    redirect: (context, state) {
      final path = state.uri.path;
      if (path.length <= 1 || !path.endsWith('/')) return null;

      return state.uri
          .replace(path: path.substring(0, path.length - 1))
          .toString();
    },
    routes: [
      for (final section in PortfolioSection.values)
        GoRoute(
          path: section.path,
          name: section.name,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: const ValueKey('portfolio-page'),
            child: _portfolioPageFor(context, section),
          ),
        ),
      GoRoute(
        path: PortfolioRoute.projectsPath,
        name: PortfolioRoute.projectsName,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          child: _projectsPageFor(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(.04, 0),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: PortfolioRoute.caseStudyPath,
        name: PortfolioRoute.caseStudyName,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 520),
          reverseTransitionDuration: const Duration(milliseconds: 360),
          child: _caseStudyPageFor(context, state.pathParameters['slug'] ?? ''),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(.08, 0),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: PortfolioRoute.testimonialSubmissionPath,
        name: PortfolioRoute.testimonialSubmissionName,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 480),
          reverseTransitionDuration: const Duration(milliseconds: 340),
          child: _testimonialPageFor(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, .035),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      ),
    ],
    errorPageBuilder: (context, state) => NoTransitionPage<void>(
      key: state.pageKey,
      child: NotFoundPage(path: state.uri.path),
    ),
  );
}

Widget _portfolioPageFor(BuildContext context, PortfolioSection section) {
  final breakpoint = ResponsiveBreakpoints.of(context);
  if (breakpoint.isMobile) {
    return MobilePortfolioPage(initialSection: section);
  }
  if (breakpoint.isTablet) {
    return TabletPortfolioPage(initialSection: section);
  }
  return WebPortfolioPage(initialSection: section);
}

Widget _projectsPageFor(BuildContext context) {
  final breakpoint = ResponsiveBreakpoints.of(context);
  if (breakpoint.isMobile) return const MobileProjectsPage();
  if (breakpoint.isTablet) return const TabletProjectsPage();
  return const WebProjectsPage();
}

Widget _caseStudyPageFor(BuildContext context, String slug) {
  final breakpoint = ResponsiveBreakpoints.of(context);
  if (breakpoint.isMobile) return MobileCaseStudyPage(slug: slug);
  if (breakpoint.isTablet) return TabletCaseStudyPage(slug: slug);
  return WebCaseStudyPage(slug: slug);
}

Widget _testimonialPageFor(BuildContext context) {
  final breakpoint = ResponsiveBreakpoints.of(context);
  if (breakpoint.isMobile) {
    return const MobileTestimonialSubmissionPage();
  }
  if (breakpoint.isTablet) {
    return const TabletTestimonialSubmissionPage();
  }
  return const WebTestimonialSubmissionPage();
}
