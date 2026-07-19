import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';

class CaseStudyState {
  const CaseStudyState({required this.slug, required this.project});

  final String slug;
  final PortfolioProject? project;

  bool get isAvailable => project?.caseStudy.isAvailable ?? false;
}

class CaseStudyCubit extends Cubit<CaseStudyState> {
  CaseStudyCubit({
    required PortfolioContent content,
    required String slug,
    required GoRouter router,
  }) : _router = router,
       super(CaseStudyState(slug: slug, project: _find(content, slug)));

  final GoRouter _router;

  void replaceContent(PortfolioContent content) {
    emit(CaseStudyState(slug: state.slug, project: _find(content, state.slug)));
  }

  void closeCaseStudy() {
    if (_router.canPop()) {
      _router.pop();
    } else {
      _router.go(PortfolioSection.projects.path);
    }
  }

  static PortfolioProject? _find(PortfolioContent content, String slug) {
    for (final project in content.projects) {
      if (project.slug == slug) return project;
    }
    return null;
  }
}
