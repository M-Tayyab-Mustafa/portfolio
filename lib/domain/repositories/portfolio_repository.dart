import 'package:portfolio/data/models/portfolio_models.dart';

abstract interface class PortfolioRepository {
  Stream<PersonalProfile> watchProfile();

  Stream<EmailJsConfiguration> watchEmailJsConfiguration();

  Stream<PortfolioLinks> watchLinks();

  Stream<StatsDocument> watchStats();

  Stream<ContactChannelsDocument> watchContactChannels();

  Stream<List<ExperienceItem>> watchExperiences();

  Stream<List<PortfolioProject>> watchProjects();

  Stream<List<ServiceItem>> watchServices();

  Stream<List<SkillGroup>> watchSkillGroups();

  Stream<List<TestimonialItem>> watchTestimonials();

  Future<void> submitTestimonial(TestimonialItem testimonial);
}

class PortfolioDataNotFoundException implements Exception {
  const PortfolioDataNotFoundException();

  @override
  String toString() => 'PortfolioDataNotFoundException';
}

class PortfolioRepositoryInitializationException implements Exception {
  const PortfolioRepositoryInitializationException(this.message);

  final String message;

  @override
  String toString() => message;
}
