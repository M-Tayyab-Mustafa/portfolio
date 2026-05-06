import 'package:portfolio/domain/domain_exports.dart';

class GetExperiencesUseCase {
  const GetExperiencesUseCase(this._repository);
  final PortfolioRepository _repository;
  Future<List<ExperienceEntity>> call() => _repository.getExperiences();
}
