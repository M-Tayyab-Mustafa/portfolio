import 'package:portfolio/domain/domain_exports.dart';

abstract class PortfolioRepository {
  Future<AboutEntity> getAbout();
  Future<List<SkillAnalyticEntity>> getSkillAnalytics();
  Future<List<TechnicalSkillEntity>> getTechnicalSkills();
  Future<List<ExperienceEntity>> getExperiences();
  Future<List<ProjectEntity>> getFeaturedProjects();
  Future<List<ProjectEntity>> getAllProjects();
}
