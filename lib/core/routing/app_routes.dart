enum PortfolioSection {
  home('Home', '/'),
  about('About', '/about'),
  skills('Skills', '/skills'),
  services('Services', '/services'),
  projects('Projects', '/projects'),
  experience('Experience', '/experience'),
  contact('Contact', '/contact');

  const PortfolioSection(this.label, this.path);
  final String label;
  final String path;

  static PortfolioSection fromPath(String path) {
    return values.firstWhere(
      (section) => section.path == path,
      orElse: () => PortfolioSection.home,
    );
  }
}

abstract final class PortfolioRoute {
  static const projectsName = 'allProjects';
  static const projectsPath = '/all-projects';
  static const caseStudyName = 'caseStudy';
  static const caseStudyPath = '/case-study/:slug';
  static const testimonialSubmissionName = 'testimonialSubmission';
  static const testimonialSubmissionPath = '/submit-testimonial';

  static String caseStudyLocation(String slug) {
    return '/case-study/${Uri.encodeComponent(slug)}';
  }
}
