import 'package:portfolio/core/constants/portfolio_enums.dart';

export 'package:portfolio/core/constants/portfolio_enums.dart';

class PersonalProfile {
  const PersonalProfile({
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.subtitle,
    required this.aboutBrief,
    required this.aboutLong,
    required this.email,
    required this.portraitAsset,
    required this.logoAsset,
    required this.roles,
    required this.coreFocus,
  });

  factory PersonalProfile.fromMap(Map<String, dynamic> map) {
    return PersonalProfile(
      firstName: _string(map['firstName']),
      lastName: _string(map['lastName']),
      title: _string(map['title']),
      subtitle: _string(map['subtitle']),
      aboutBrief: _string(map['aboutBrief']),
      aboutLong: _string(map['aboutLong']),
      email: _string(map['email']),
      portraitAsset: _string(map['portraitAsset']),
      logoAsset: _string(map['logoAsset']),
      roles: _strings(map['roles']),
      coreFocus: _strings(map['coreFocus']),
    );
  }

  final String firstName;
  final String lastName;
  final String title;
  final String subtitle;
  final String aboutBrief;
  final String aboutLong;
  final String email;
  final String portraitAsset;
  final String logoAsset;
  final List<String> roles;
  final List<String> coreFocus;

  String get fullName => '$firstName $lastName'.trim();

  Map<String, dynamic> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'title': title,
    'subtitle': subtitle,
    'aboutBrief': aboutBrief,
    'aboutLong': aboutLong,
    'email': email,
    'portraitAsset': portraitAsset,
    'logoAsset': logoAsset,
    'roles': roles,
    'coreFocus': coreFocus,
  };
}

class StatItem {
  const StatItem({
    required this.value,
    required this.label,
    required this.iconName,
    required this.order,
    this.enabled = true,
  });

  factory StatItem.fromMap(Map<String, dynamic> map) => StatItem(
    value: _string(map['value']),
    label: _string(map['label']),
    iconName: _string(map['iconName']),
    order: _integer(map['order']),
    enabled: _boolean(map['enabled']),
  );

  final String value;
  final String label;
  final String iconName;
  final int order;
  final bool enabled;

  Map<String, dynamic> toMap() => {
    'value': value,
    'label': label,
    'iconName': iconName,
    'order': order,
    'enabled': enabled,
  };
}

class SocialLink {
  const SocialLink({
    required this.label,
    required this.url,
    required this.iconName,
    required this.order,
    this.enabled = true,
  });

  factory SocialLink.fromMap(Map<String, dynamic> map) => SocialLink(
    label: _string(map['label']),
    url: _string(map['url']),
    iconName: _string(map['iconName']),
    order: _integer(map['order']),
    enabled: _boolean(map['enabled']),
  );

  final String label;
  final String url;
  final String iconName;
  final int order;
  final bool enabled;

  Map<String, dynamic> toMap() => {
    'label': label,
    'url': url,
    'iconName': iconName,
    'order': order,
    'enabled': enabled,
  };
}

class SkillItem {
  const SkillItem({required this.name, required this.iconName});

  factory SkillItem.fromMap(Map<String, dynamic> map) =>
      SkillItem(name: _string(map['name']), iconName: _string(map['iconName']));

  final String name;
  final String iconName;

  Map<String, dynamic> toMap() => {'name': name, 'iconName': iconName};
}

class SkillGroup {
  const SkillGroup({
    required this.title,
    required this.iconName,
    required this.skills,
    required this.order,
    this.enabled = true,
  });

  factory SkillGroup.fromMap(Map<String, dynamic> map) => SkillGroup(
    title: _string(map['title']),
    iconName: _string(map['iconName']),
    skills: _maps(map['skills']).map(SkillItem.fromMap).toList(growable: false),
    order: _integer(map['order']),
    enabled: _boolean(map['enabled']),
  );

  final String title;
  final String iconName;
  final List<SkillItem> skills;
  final int order;
  final bool enabled;

  Map<String, dynamic> toMap() => {
    'title': title,
    'iconName': iconName,
    'skills': skills.map((skill) => skill.toMap()).toList(growable: false),
    'order': order,
    'enabled': enabled,
  };
}

class ServiceItem {
  const ServiceItem({
    required this.title,
    required this.description,
    required this.iconName,
    required this.order,
    this.enabled = true,
  });

  factory ServiceItem.fromMap(Map<String, dynamic> map) => ServiceItem(
    title: _string(map['title']),
    description: _string(map['description']),
    iconName: _string(map['iconName']),
    order: _integer(map['order']),
    enabled: _boolean(map['enabled']),
  );

  final String title;
  final String description;
  final String iconName;
  final int order;
  final bool enabled;

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'iconName': iconName,
    'order': order,
    'enabled': enabled,
  };
}

class CaseStudyResult {
  const CaseStudyResult({
    required this.metric,
    required this.label,
    required this.order,
    this.enabled = true,
  });

  factory CaseStudyResult.fromMap(Map<String, dynamic> map) {
    return CaseStudyResult(
      metric: _string(map['metric']),
      label: _string(map['label']),
      order: _integer(map['order']),
      enabled: _boolean(map['enabled']),
    );
  }

  final String metric;
  final String label;
  final int order;
  final bool enabled;

  Map<String, dynamic> toMap() => {
    'metric': metric,
    'label': label,
    'order': order,
    'enabled': enabled,
  };
}

class ProjectCaseStudy {
  const ProjectCaseStudy({
    required this.role,
    required this.timeline,
    required this.challenge,
    required this.solution,
    required this.results,
    required this.architecture,
    this.enabled = true,
  });

  factory ProjectCaseStudy.fromMap(Map<String, dynamic> map) {
    final results =
        _maps(map['results'])
            .map(CaseStudyResult.fromMap)
            .where((result) => result.enabled)
            .toList(growable: false)
          ..sort((a, b) => a.order.compareTo(b.order));
    return ProjectCaseStudy(
      role: _string(map['role']),
      timeline: _string(map['timeline']),
      challenge: _string(map['challenge']),
      solution: _string(map['solution']),
      results: results,
      architecture: _strings(map['architecture']),
      enabled: _boolean(map['enabled'], fallback: false),
    );
  }

  static const empty = ProjectCaseStudy(
    role: '',
    timeline: '',
    challenge: '',
    solution: '',
    results: [],
    architecture: [],
    enabled: false,
  );

  final String role;
  final String timeline;
  final String challenge;
  final String solution;
  final List<CaseStudyResult> results;
  final List<String> architecture;
  final bool enabled;

  bool get isAvailable =>
      enabled &&
      (challenge.isNotEmpty ||
          solution.isNotEmpty ||
          results.isNotEmpty ||
          architecture.isNotEmpty);

  Map<String, dynamic> toMap() => {
    'role': role,
    'timeline': timeline,
    'challenge': challenge,
    'solution': solution,
    'results': results.map((result) => result.toMap()).toList(growable: false),
    'architecture': architecture,
    'enabled': enabled,
  };
}

class PortfolioProject {
  const PortfolioProject({
    required this.slug,
    required this.title,
    required this.description,
    required this.details,
    required this.tags,
    required this.category,
    required this.url,
    required this.destinationLabel,
    required this.iconName,
    required this.code,
    required this.imageUrl,
    required this.appStoreUrl,
    required this.playStoreUrl,
    required this.pubDevUrl,
    required this.liveUrl,
    required this.projectType,
    required this.sourceUrl,
    required this.caseStudy,
    required this.featured,
    required this.order,
    this.enabled = true,
  });

  factory PortfolioProject.fromMap(Map<String, dynamic> map) {
    final title = _string(map['title']);
    final configuredSlug = _string(map['slug']);
    return PortfolioProject(
      slug: configuredSlug.isEmpty ? _slugify(title) : configuredSlug,
      title: title,
      description: _string(map['description']),
      details: _string(map['details']),
      tags: _strings(map['tags']),
      category: ProjectCategory.fromName(_string(map['category'])),
      url: _string(map['url']),
      destinationLabel: _string(map['destinationLabel']),
      iconName: _string(map['iconName']),
      code: _string(map['code']),
      imageUrl: _string(map['imageUrl']),
      appStoreUrl: _nullableString(map['appStoreUrl']),
      playStoreUrl: _nullableString(map['playStoreUrl']),
      pubDevUrl: _nullableString(map['pubDevUrl']),
      liveUrl: _nullableString(map['liveUrl']),
      projectType: _string(map['projectType']),
      sourceUrl: _nullableString(map['sourceUrl']),
      caseStudy: _map(map['caseStudy']).isEmpty
          ? ProjectCaseStudy.empty
          : ProjectCaseStudy.fromMap(_map(map['caseStudy'])),
      featured: _boolean(map['featured']),
      order: _integer(map['order']),
      enabled: _boolean(map['enabled']),
    );
  }

  final String slug;
  final String title;
  final String description;
  final String details;
  final List<String> tags;
  final ProjectCategory category;
  final String url;
  final String destinationLabel;
  final String iconName;
  final String code;
  final String imageUrl;
  final String? appStoreUrl;
  final String? playStoreUrl;
  final String? pubDevUrl;
  final String? liveUrl;
  final String projectType;
  final String? sourceUrl;
  final ProjectCaseStudy caseStudy;
  final bool featured;
  final int order;
  final bool enabled;

  Map<String, dynamic> toMap() => {
    'slug': slug,
    'title': title,
    'description': description,
    'details': details,
    'tags': tags,
    'category': category.name,
    'url': url,
    'destinationLabel': destinationLabel,
    'iconName': iconName,
    'code': code,
    'imageUrl': imageUrl,
    'appStoreUrl': appStoreUrl,
    'playStoreUrl': playStoreUrl,
    'pubDevUrl': pubDevUrl,
    'liveUrl': liveUrl,
    'projectType': projectType,
    'sourceUrl': sourceUrl,
    'caseStudy': caseStudy.toMap(),
    'featured': featured,
    'order': order,
    'enabled': enabled,
  };
}

class ExperienceItem {
  const ExperienceItem({
    required this.period,
    required this.title,
    required this.context,
    required this.description,
    required this.highlights,
    required this.kind,
    required this.order,
    this.enabled = true,
  });

  factory ExperienceItem.fromMap(Map<String, dynamic> map) => ExperienceItem(
    period: _string(map['period']),
    title: _string(map['title']),
    context: _string(map['context']),
    description: _string(map['description']),
    highlights: _strings(map['highlights']),
    kind: ExperienceKind.fromName(_string(map['kind'])),
    order: _integer(map['order']),
    enabled: _boolean(map['enabled']),
  );

  final String period;
  final String title;
  final String context;
  final String description;
  final List<String> highlights;
  final ExperienceKind kind;
  final int order;
  final bool enabled;

  Map<String, dynamic> toMap() => {
    'period': period,
    'title': title,
    'context': context,
    'description': description,
    'highlights': highlights,
    'kind': kind.name,
    'order': order,
    'enabled': enabled,
  };
}

class TestimonialItem {
  const TestimonialItem({
    required this.name,
    required this.role,
    required this.company,
    required this.content,
    required this.rating,
    required this.avatar,
    required this.order,
    this.enabled = true,
  });

  factory TestimonialItem.fromMap(Map<String, dynamic> map) {
    final name = _string(map['name']);
    final configuredAvatar = _string(map['avatar']);
    return TestimonialItem(
      name: name,
      role: _string(map['role']),
      company: _string(map['company']),
      content: _string(map['content']),
      rating: _integer(map['rating'], fallback: 5).clamp(1, 5),
      avatar: configuredAvatar.isEmpty ? _initials(name) : configuredAvatar,
      order: _integer(map['order']),
      enabled: _boolean(map['enabled']),
    );
  }

  final String name;
  final String role;
  final String company;
  final String content;
  final int rating;
  final String avatar;
  final int order;
  final bool enabled;

  Map<String, dynamic> toMap() => {
    'name': name,
    'role': role,
    'company': company,
    'content': content,
    'rating': rating,
    'avatar': avatar,
    'order': order,
    'enabled': enabled,
  };
}

class ContactChannel {
  const ContactChannel({
    required this.label,
    required this.value,
    required this.url,
    required this.iconName,
    required this.order,
    this.enabled = true,
  });

  factory ContactChannel.fromMap(Map<String, dynamic> map) => ContactChannel(
    label: _string(map['label']),
    value: _string(map['value']),
    url: _string(map['url']),
    iconName: _string(map['iconName']),
    order: _integer(map['order']),
    enabled: _boolean(map['enabled']),
  );

  final String label;
  final String value;
  final String url;
  final String iconName;
  final int order;
  final bool enabled;

  Map<String, dynamic> toMap() => {
    'label': label,
    'value': value,
    'url': url,
    'iconName': iconName,
    'order': order,
    'enabled': enabled,
  };
}

class EmailJsConfiguration {
  const EmailJsConfiguration({
    required this.serviceId,
    required this.templateId,
    required this.publicKey,
    required this.nameParameter,
    required this.emailParameter,
    required this.subjectParameter,
    required this.messageParameter,
  });

  factory EmailJsConfiguration.fromMap(Map<String, dynamic> map) {
    return EmailJsConfiguration(
      serviceId: _string(map['serviceId']),
      templateId: _string(map['templateId']),
      publicKey: _string(map['publicKey']),
      nameParameter: _string(map['nameParameter']),
      emailParameter: _string(map['emailParameter']),
      subjectParameter: _string(map['subjectParameter']),
      messageParameter: _string(map['messageParameter']),
    );
  }

  final String serviceId;
  final String templateId;
  final String publicKey;
  final String nameParameter;
  final String emailParameter;
  final String subjectParameter;
  final String messageParameter;

  bool get isConfigured =>
      serviceId.isNotEmpty &&
      templateId.isNotEmpty &&
      publicKey.isNotEmpty &&
      nameParameter.isNotEmpty &&
      emailParameter.isNotEmpty &&
      subjectParameter.isNotEmpty &&
      messageParameter.isNotEmpty;

  Map<String, dynamic> toMap() => {
    'serviceId': serviceId,
    'templateId': templateId,
    'publicKey': publicKey,
    'nameParameter': nameParameter,
    'emailParameter': emailParameter,
    'subjectParameter': subjectParameter,
    'messageParameter': messageParameter,
  };
}

class SectionHeading {
  const SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.accentTitle,
  });

  factory SectionHeading.fromMap(Map<String, dynamic> map) => SectionHeading(
    eyebrow: _string(map['eyebrow']),
    title: _string(map['title']),
    accentTitle: _string(map['accentTitle']),
  );

  final String eyebrow;
  final String title;
  final String accentTitle;

  Map<String, dynamic> toMap() => {
    'eyebrow': eyebrow,
    'title': title,
    'accentTitle': accentTitle,
  };
}

class PortfolioContent {
  const PortfolioContent({
    required this.schemaVersion,
    required this.profile,
    required this.emailJs,
    required this.links,
    required this.navigationLabels,
    required this.sectionHeadings,
    required this.stats,
    required this.socials,
    required this.skillGroups,
    required this.services,
    required this.projects,
    required this.experiences,
    required this.testimonials,
    required this.contactChannels,
  });

  factory PortfolioContent.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty || _map(map['profile']).isEmpty) {
      throw const FormatException('The portfolio content document is empty.');
    }

    final stats =
        _maps(map['stats'])
            .map(StatItem.fromMap)
            .where((item) {
              return item.enabled;
            })
            .toList(growable: false)
          ..sort((a, b) => a.order.compareTo(b.order));
    final socials =
        _maps(map['socials'])
            .map(SocialLink.fromMap)
            .where((item) => item.enabled)
            .toList(growable: false)
          ..sort((a, b) => a.order.compareTo(b.order));
    final skillGroups =
        _maps(map['skillGroups'])
            .map(SkillGroup.fromMap)
            .where((item) => item.enabled)
            .toList(growable: false)
          ..sort((a, b) => a.order.compareTo(b.order));
    final services =
        _maps(map['services'])
            .map(ServiceItem.fromMap)
            .where((item) => item.enabled)
            .toList(growable: false)
          ..sort((a, b) => a.order.compareTo(b.order));
    final projects =
        _maps(map['projects'])
            .map(PortfolioProject.fromMap)
            .where((item) => item.enabled)
            .toList(growable: false)
          ..sort((a, b) => a.order.compareTo(b.order));
    final experiences =
        _maps(map['experiences'])
            .map(ExperienceItem.fromMap)
            .where((item) => item.enabled)
            .toList(growable: false)
          ..sort((a, b) => a.order.compareTo(b.order));
    final testimonials =
        _maps(map['testimonials'])
            .map(TestimonialItem.fromMap)
            .where((item) => item.enabled)
            .toList(growable: false)
          ..sort((a, b) => a.order.compareTo(b.order));
    final contactChannels =
        _maps(map['contactChannels'])
            .map(ContactChannel.fromMap)
            .where((item) => item.enabled)
            .toList(growable: false)
          ..sort((a, b) => a.order.compareTo(b.order));
    final headings = _map(
      map['sectionHeadings'],
    ).map((key, value) => MapEntry(key, SectionHeading.fromMap(_map(value))));

    final content = PortfolioContent(
      schemaVersion: _integer(map['schemaVersion'], fallback: 1),
      profile: PersonalProfile.fromMap(_map(map['profile'])),
      emailJs: EmailJsConfiguration.fromMap(_map(map['emailJs'])),
      links: _stringMap(map['links']),
      navigationLabels: _stringMap(map['navigationLabels']),
      sectionHeadings: headings,
      stats: stats,
      socials: socials,
      skillGroups: skillGroups,
      services: services,
      projects: projects,
      experiences: experiences,
      testimonials: testimonials,
      contactChannels: contactChannels,
    );
    content._validate();
    return content;
  }

  final int schemaVersion;
  final PersonalProfile profile;
  final EmailJsConfiguration emailJs;
  final Map<String, String> links;
  final Map<String, String> navigationLabels;
  final Map<String, SectionHeading> sectionHeadings;
  final List<StatItem> stats;
  final List<SocialLink> socials;
  final List<SkillGroup> skillGroups;
  final List<ServiceItem> services;
  final List<PortfolioProject> projects;
  final List<ExperienceItem> experiences;
  final List<TestimonialItem> testimonials;
  final List<ContactChannel> contactChannels;

  String link(String key) => links[key] ?? '';

  String navigationLabel(String sectionName) {
    return navigationLabels[sectionName] ?? sectionName;
  }

  String categoryLabel(ProjectCategory category) {
    return category.label;
  }

  SectionHeading heading(String sectionName) {
    return sectionHeadings[sectionName] ??
        const SectionHeading(eyebrow: '', title: '', accentTitle: '');
  }

  void _validate() {
    if (schemaVersion < 1) {
      throw const FormatException('schemaVersion must be at least 1.');
    }

    final requiredProfileValues = <String, String>{
      'profile.firstName': profile.firstName,
      'profile.lastName': profile.lastName,
      'profile.title': profile.title,
      'profile.subtitle': profile.subtitle,
      'profile.email': profile.email,
      'profile.portraitAsset': profile.portraitAsset,
      'profile.logoAsset': profile.logoAsset,
    };
    _requireNonEmpty(requiredProfileValues);
    if (profile.roles.isEmpty) {
      throw const FormatException('profile.roles must not be empty.');
    }
    if (!emailJs.isConfigured) {
      throw const FormatException('emailJs configuration is incomplete.');
    }

    _requireKeys(navigationLabels, const [
      'home',
      'about',
      'skills',
      'services',
      'projects',
      'experience',
      'contact',
    ], 'navigationLabels');
    _requireKeys(sectionHeadings, const [
      'about',
      'skills',
      'services',
      'projects',
      'experience',
      'testimonials',
      'contact',
    ], 'sectionHeadings');

    final slugs = <String>{};
    for (final project in projects) {
      if (project.slug.isEmpty) {
        throw const FormatException(
          'Every project must have a non-empty slug.',
        );
      }
      if (!slugs.add(project.slug)) {
        throw FormatException('Duplicate project slug: ${project.slug}.');
      }
    }
  }

  Map<String, dynamic> toMap() => {
    'schemaVersion': schemaVersion,
    'profile': profile.toMap(),
    'emailJs': emailJs.toMap(),
    'links': links,
    'navigationLabels': navigationLabels,
    'sectionHeadings': sectionHeadings.map(
      (key, heading) => MapEntry(key, heading.toMap()),
    ),
    'stats': stats.map((item) => item.toMap()).toList(growable: false),
    'socials': socials.map((item) => item.toMap()).toList(growable: false),
    'skillGroups': skillGroups
        .map((item) => item.toMap())
        .toList(growable: false),
    'services': services.map((item) => item.toMap()).toList(growable: false),
    'projects': projects.map((item) => item.toMap()).toList(growable: false),
    'experiences': experiences
        .map((item) => item.toMap())
        .toList(growable: false),
    'testimonials': testimonials
        .map((item) => item.toMap())
        .toList(growable: false),
    'contactChannels': contactChannels
        .map((item) => item.toMap())
        .toList(growable: false),
  };
}

void _requireNonEmpty(Map<String, String> values) {
  for (final entry in values.entries) {
    if (entry.value.trim().isEmpty) {
      throw FormatException('${entry.key} must not be empty.');
    }
  }
}

void _requireKeys<T>(
  Map<String, T> values,
  Iterable<String> keys,
  String path,
) {
  for (final key in keys) {
    final value = values[key];
    if (value == null || (value is String && value.trim().isEmpty)) {
      throw FormatException('$path.$key is required.');
    }
  }
}

abstract final class PortfolioLinkKey {
  static const github = 'github';
  static const linkedin = 'linkedin';
  static const pubDev = 'pubDev';
}

String _string(Object? value) => value?.toString() ?? '';

String? _nullableString(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int _integer(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

bool _boolean(Object? value, {bool fallback = true}) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  return fallback;
}

Map<String, dynamic> _map(Object? value) {
  if (value is Map) return Map<String, dynamic>.from(value);
  return const {};
}

Map<String, String> _stringMap(Object? value) {
  return _map(value).map((key, item) => MapEntry(key, _string(item)));
}

String _slugify(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}

String _initials(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) return 'CL';
  if (parts.length == 1) {
    return parts.first
        .substring(0, parts.first.length.clamp(1, 2))
        .toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

List<String> _strings(Object? value) {
  if (value is! Iterable) return const [];
  return value.map(_string).toList(growable: false);
}

List<Map<String, dynamic>> _maps(Object? value) {
  if (value is! Iterable) return const [];
  return value.map(_map).toList(growable: false);
}
