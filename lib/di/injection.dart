import 'package:portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:portfolio/data/source/remote/firebase_remote_data_source_impl.dart';
import 'package:portfolio/domain/domain_exports.dart';

class Injection {
  Injection._();

  static late final PortfolioRepository _repository;

  static late final GetAboutUseCase getAbout;
  static late final GetSkillAnalyticsUseCase getSkillAnalytics;
  static late final GetTechnicalSkillsUseCase getTechnicalSkills;
  static late final GetExperiencesUseCase getExperiences;
  static late final GetFeaturedProjectsUseCase getFeaturedProjects;
  static late final GetAllProjectsUseCase getAllProjects;

  static void init() {
    _repository = PortfolioRepositoryImpl(
      remoteDataSource: FirebaseRemoteDataSourceImpl(),
    );
    getAbout = GetAboutUseCase(_repository);
    getSkillAnalytics = GetSkillAnalyticsUseCase(_repository);
    getTechnicalSkills = GetTechnicalSkillsUseCase(_repository);
    getExperiences = GetExperiencesUseCase(_repository);
    getFeaturedProjects = GetFeaturedProjectsUseCase(_repository);
    getAllProjects = GetAllProjectsUseCase(_repository);
  }
}
