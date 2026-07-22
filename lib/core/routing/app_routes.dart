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
  // `/portfolio` is supplied by the GitHub Pages base href at build time.
  static const projectsPath = '/projects/all-projects';
  static const caseStudyName = 'caseStudy';
  static const caseStudyPath = '/projects/:slug';
  static const testimonialSubmissionName = 'testimonialSubmission';
  static const testimonialSubmissionPath = '/testimonials/submit-testimonial';

  static String caseStudyLocation(String slug) {
    return '/projects/${Uri.encodeComponent(slug)}';
  }
}
