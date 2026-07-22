import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/presentation/pages/web/pages/case_study_page.dart';
import 'package:portfolio/presentation/pages/web/pages/not_found_page.dart';
import 'package:portfolio/presentation/pages/web/pages/portfolio_page.dart';
import 'package:portfolio/presentation/pages/web/pages/projects_page.dart';
import 'package:portfolio/presentation/pages/web/pages/testimonial_submission_page.dart';

final GoRouter appRouter = _createAppRouter();

GoRouter _createAppRouter() {
  // GoRouter does not reflect imperative `push` calls in the browser URL by
  // default. Full pages use push so that browser Back returns to the section
  // the visitor came from.
  GoRouter.optionURLReflectsImperativeAPIs = true;

  return GoRouter(
    initialLocation: PortfolioSection.home.path,
    routes: [
      for (final section in PortfolioSection.values)
        GoRoute(
          path: section.path,
          name: section.name,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: const ValueKey('portfolio-page'),
            child: PortfolioPage(initialSection: section),
          ),
        ),
      GoRoute(
        path: PortfolioRoute.projectsPath,
        name: PortfolioRoute.projectsName,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          child: const ProjectsPage(),
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
          child: CaseStudyPage(slug: state.pathParameters['slug'] ?? ''),
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
          child: const TestimonialSubmissionPage(),
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
