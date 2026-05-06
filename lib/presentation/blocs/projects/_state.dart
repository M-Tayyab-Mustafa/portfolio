part of '_bloc.dart';

class ProjectsState {
  final List<ProjectEntity> featuredProjects;
  final List<ProjectEntity> allProjects;
  final bool isLoading;
  final bool isLoadingAll;

  const ProjectsState({
    this.featuredProjects = const [],
    this.allProjects = const [],
    this.isLoading = false,
    this.isLoadingAll = false,
  });

  ProjectsState copyWith({
    List<ProjectEntity>? featuredProjects,
    List<ProjectEntity>? allProjects,
    bool? isLoading,
    bool? isLoadingAll,
  }) => ProjectsState(
    featuredProjects: featuredProjects ?? this.featuredProjects,
    allProjects: allProjects ?? this.allProjects,
    isLoading: isLoading ?? this.isLoading,
    isLoadingAll: isLoadingAll ?? this.isLoadingAll,
  );
}
