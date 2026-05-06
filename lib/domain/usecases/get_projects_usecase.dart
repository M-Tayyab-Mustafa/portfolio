import 'package:portfolio/domain/domain_exports.dart';

class GetFeaturedProjectsUseCase {
  const GetFeaturedProjectsUseCase(this._repository);
  final PortfolioRepository _repository;
  Future<List<ProjectEntity>> call() => _repository.getFeaturedProjects();
}

class GetAllProjectsUseCase {
  const GetAllProjectsUseCase(this._repository);
  final PortfolioRepository _repository;
  Future<List<ProjectEntity>> call() => _repository.getAllProjects();
}
