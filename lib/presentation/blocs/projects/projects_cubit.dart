import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';

class ProjectsState {
  const ProjectsState({
    required this.selectedCategory,
    required this.allProjects,
    required this.visibleProjects,
    this.searchQuery = '',
  });

  final ProjectCategory selectedCategory;
  final List<PortfolioProject> allProjects;
  final List<PortfolioProject> visibleProjects;
  final String searchQuery;
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
    emit(_buildState(category, state.allProjects, state.searchQuery));
  }

  void search(String query) {
    emit(_buildState(state.selectedCategory, state.allProjects, query));
  }

  void replaceProjects(List<PortfolioProject> projects) {
    emit(_buildState(state.selectedCategory, projects, state.searchQuery));
  }

  ProjectsState _buildState(
    ProjectCategory category,
    List<PortfolioProject> projects, [
    String searchQuery = '',
  ]) {
    final categoryProjects = category == ProjectCategory.all
        ? projects
        : projects
              .where((project) => project.category == category)
              .toList(growable: false);
    final query = searchQuery.trim().toLowerCase();
    final visible = query.isEmpty
        ? categoryProjects
        : categoryProjects
              .where((project) {
                return project.title.toLowerCase().contains(query) ||
                    project.description.toLowerCase().contains(query) ||
                    project.projectType.toLowerCase().contains(query) ||
                    project.tags.any(
                      (tag) => tag.toLowerCase().contains(query),
                    );
              })
              .toList(growable: false);
    return ProjectsState(
      selectedCategory: category,
      allProjects: projects,
      visibleProjects: visible,
      searchQuery: searchQuery,
    );
  }
}
