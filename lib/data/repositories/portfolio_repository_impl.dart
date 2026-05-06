import 'package:portfolio/data/source/remote/firebase_remote_data_source_impl.dart';
import 'package:portfolio/utils/utils_exports.dart';
import 'package:portfolio/domain/domain_exports.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  PortfolioRepositoryImpl({required PortfolioRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final PortfolioRemoteDataSource _remote;

  @override
  Future<AboutEntity> getAbout() async {
    try {
      return (await _remote.fetchAbout()).toEntity();
    } catch (e) {
      Logger.log('getAbout → local fallback: $e');
      rethrow;
    }
  }

  @override
  Future<List<SkillAnalyticEntity>> getSkillAnalytics() async {
    try {
      final list = await _remote.fetchSkillAnalytics();
      return list.map((m) => m.toEntity()).toList();
    } catch (e) {
      Logger.log('getSkillAnalytics → local fallback: $e');
      rethrow;
    }
  }

  @override
  Future<List<TechnicalSkillEntity>> getTechnicalSkills() async {
    try {
      final list = await _remote.fetchTechnicalSkills();
      return list.map((m) => m.toEntity()).toList();
    } catch (e) {
      Logger.log('getTechnicalSkills → local fallback: $e');
      rethrow;
    }
  }

  @override
  Future<List<ExperienceEntity>> getExperiences() async {
    try {
      final list = await _remote.fetchExperiences();
      return list.map((m) => m.toEntity()).toList();
    } catch (e) {
      Logger.log('getExperiences → local fallback: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProjectEntity>> getFeaturedProjects() async {
    try {
      final list = await _remote.fetchFeaturedProjects();
      return list.map((m) => m.toEntity()).toList();
    } catch (e) {
      Logger.log('getFeaturedProjects → local fallback: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProjectEntity>> getAllProjects() async {
    try {
      final list = await _remote.fetchAllProjects();
      return list.map((m) => m.toEntity()).toList();
    } catch (e) {
      Logger.log('getAllProjects → local fallback: $e');
      rethrow;
    }
  }
}
