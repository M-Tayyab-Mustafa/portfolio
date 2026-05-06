import 'package:portfolio/domain/domain_exports.dart';

class GetSkillAnalyticsUseCase {
  const GetSkillAnalyticsUseCase(this._repository);
  final PortfolioRepository _repository;
  Future<List<SkillAnalyticEntity>> call() => _repository.getSkillAnalytics();
}

class GetTechnicalSkillsUseCase {
  const GetTechnicalSkillsUseCase(this._repository);
  final PortfolioRepository _repository;
  Future<List<TechnicalSkillEntity>> call() => _repository.getTechnicalSkills();
}
