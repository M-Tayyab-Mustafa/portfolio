import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

part '_event.dart';
part '_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc({
    required GetFeaturedProjectsUseCase getFeaturedProjects,
    required GetAllProjectsUseCase getAllProjects,
  }) : _getFeatured = getFeaturedProjects,
       _getAll = getAllProjects,
       super(const ProjectsState()) {
    on<ProjectsStarted>(_onStarted);
    on<FetchAllProjects>(_onFetchAll);
    on<ViewAllProjects>(_onViewAll);
  }

  final GetFeaturedProjectsUseCase _getFeatured;
  final GetAllProjectsUseCase _getAll;

  Future<void> _onStarted(
    ProjectsStarted event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final projects = await _getFeatured();
    emit(state.copyWith(featuredProjects: projects, isLoading: false));
  }

  Future<void> _onFetchAll(
    FetchAllProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(state.copyWith(isLoadingAll: true));
    final projects = await _getAll();
    emit(state.copyWith(allProjects: projects, isLoadingAll: false));
  }

  void _onViewAll(ViewAllProjects event, Emitter<ProjectsState> emit) =>
      event.context.go(AppRoutes.allProjects);
}
