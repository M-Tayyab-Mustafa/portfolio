import 'package:portfolio/data/models/portfolio_models.dart';

abstract final class PortfolioLocalContent {
  static const schemaVersion = 3;
  static const logoAsset = 'assets/images/logo.png';

  static const navigationLabels = NavigationLabels(
    home: 'Home',
    about: 'About',
    skills: 'Skills',
    services: 'Services',
    projects: 'Projects',
    experience: 'Experience',
    contact: 'Contact',
  );

  static const sectionHeadings = PortfolioSectionHeadings(
    about: SectionHeading(
      eyebrow: '01 . Get to know me',
      title: 'About',
      accentTitle: 'Me',
    ),
    skills: SectionHeading(
      eyebrow: '02 . My superpowers',
      title: 'Skills &',
      accentTitle: 'Capabilities',
    ),
    services: SectionHeading(
      eyebrow: '03 . What I can do for you',
      title: 'Specialized',
      accentTitle: 'Services',
    ),
    projects: SectionHeading(
      eyebrow: '04 . Portfolio showcase',
      title: 'Featured',
      accentTitle: 'Projects',
    ),
    experience: SectionHeading(
      eyebrow: '05 . My professional pathway',
      title: 'Experience &',
      accentTitle: 'Education',
    ),
    testimonials: SectionHeading(
      eyebrow: '06 . Word on the street',
      title: 'Client',
      accentTitle: 'Testimonials',
    ),
    contact: SectionHeading(
      eyebrow: '07 . Let’s start a conversation',
      title: 'Contact',
      accentTitle: 'Me',
    ),
  );

  static List<SocialLink> socials({
    required PortfolioLinks links,
    required String email,
  }) {
    return [
      SocialLink(
        label: 'GitHub',
        url: links.github,
        iconName: 'github',
        order: 0,
      ),
      SocialLink(
        label: 'LinkedIn',
        url: links.linkedin,
        iconName: 'linkedin',
        order: 1,
      ),
      SocialLink(
        label: 'pub.dev',
        url: links.pubDev,
        iconName: 'package',
        order: 2,
      ),
      SocialLink(
        label: 'Email',
        url: email.isEmpty ? '' : 'mailto:$email',
        iconName: 'email',
        order: 3,
      ),
    ];
  }
}
