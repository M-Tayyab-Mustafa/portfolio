import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';

class ProjectsState {
  const ProjectsState({
    required this.selectedCategory,
    required this.allProjects,
    required this.visibleProjects,
  });

  final ProjectCategory selectedCategory;
  final List<PortfolioProject> allProjects;
  final List<PortfolioProject> visibleProjects;
}

class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit(List<PortfolioProject> projects)
    : super(
        ProjectsState(
          selectedCategory: ProjectCategory.all,
          allProjects: projects,
          visibleProjects: projects,
        ),
      );

  void selectCategory(ProjectCategory category) {
    emit(_buildState(category, state.allProjects));
  }

  void replaceProjects(List<PortfolioProject> projects) {
    emit(_buildState(state.selectedCategory, projects));
  }

  ProjectsState _buildState(
    ProjectCategory category,
    List<PortfolioProject> projects,
  ) {
    final visible = category == ProjectCategory.all
        ? projects
        : projects
              .where((project) => project.category == category)
              .toList(growable: false);
    return ProjectsState(
      selectedCategory: category,
      allProjects: projects,
      visibleProjects: visible,
    );
  }
}
