abstract final class PortfolioLocalContent {
  static const schemaVersion = 3;
  static const logoAsset = 'assets/images/logo.png';

  static const navigationLabels = <String, String>{
    'home': 'Home',
    'about': 'About',
    'skills': 'Skills',
    'services': 'Services',
    'projects': 'Projects',
    'experience': 'Experience',
    'contact': 'Contact',
  };

  static const sectionHeadings = <String, Map<String, String>>{
    'about': {
      'eyebrow': '01 . Get to know me',
      'title': 'About',
      'accentTitle': 'Me',
    },
    'skills': {
      'eyebrow': '02 . My superpowers',
      'title': 'Skills &',
      'accentTitle': 'Capabilities',
    },
    'services': {
      'eyebrow': '03 . What I can do for you',
      'title': 'Specialized',
      'accentTitle': 'Services',
    },
    'projects': {
      'eyebrow': '04 . Portfolio showcase',
      'title': 'Featured',
      'accentTitle': 'Projects',
    },
    'experience': {
      'eyebrow': '05 . My professional pathway',
      'title': 'Experience &',
      'accentTitle': 'Education',
    },
    'testimonials': {
      'eyebrow': '06 . Word on the street',
      'title': 'Client',
      'accentTitle': 'Testimonials',
    },
    'contact': {
      'eyebrow': '07 . Let’s start a conversation',
      'title': 'Contact',
      'accentTitle': 'Me',
    },
  };

  static List<Map<String, dynamic>> socials({
    required Map<String, dynamic> links,
    required String email,
  }) {
    return [
      {
        'label': 'GitHub',
        'url': links['github']?.toString() ?? '',
        'iconName': 'github',
        'order': 0,
        'enabled': true,
      },
      {
        'label': 'LinkedIn',
        'url': links['linkedin']?.toString() ?? '',
        'iconName': 'linkedin',
        'order': 1,
        'enabled': true,
      },
      {
        'label': 'pub.dev',
        'url': links['pubDev']?.toString() ?? '',
        'iconName': 'package',
        'order': 2,
        'enabled': true,
      },
      {
        'label': 'Email',
        'url': email.isEmpty ? '' : 'mailto:$email',
        'iconName': 'email',
        'order': 3,
        'enabled': true,
      },
    ];
  }
}
