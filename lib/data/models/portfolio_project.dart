import 'dart:convert';

import 'package:portfolio/core/constants/portfolio_enums.dart';
import 'package:portfolio/core/utils/model_normalizer.dart';

class CaseStudyResult {
  const CaseStudyResult({
    required this.metric,
    required this.label,
    required this.order,
    this.enabled = true,
  });

  factory CaseStudyResult.fromMap(Map<String, Object?> map) {
    return CaseStudyResult(
      metric: ModelNormalizer.string(map['metric']),
      label: ModelNormalizer.string(map['label']),
      order: ModelNormalizer.integer(map['order']),
      enabled: ModelNormalizer.boolean(map['enabled']),
    );
  }

  factory CaseStudyResult.fromJson(String source) {
    return CaseStudyResult.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String metric;
  final String label;
  final int order;
  final bool enabled;

  Map<String, Object?> toMap() => {
    'metric': metric,
    'label': label,
    'order': order,
    'enabled': enabled,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'CaseStudyResult(${toMap()})';

  @override
  bool operator ==(covariant CaseStudyResult other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
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

  factory ProjectCaseStudy.fromMap(Map<String, Object?> map) {
    final results =
        ModelNormalizer.maps(map['results'])
            .map(CaseStudyResult.fromMap)
            .where((result) => result.enabled)
            .toList(growable: false)
          ..sort((a, b) => a.order.compareTo(b.order));
    return ProjectCaseStudy(
      role: ModelNormalizer.string(map['role']),
      timeline: ModelNormalizer.string(map['timeline']),
      challenge: ModelNormalizer.string(map['challenge']),
      solution: ModelNormalizer.string(map['solution']),
      results: results,
      architecture: ModelNormalizer.strings(map['architecture']),
      enabled: ModelNormalizer.boolean(map['enabled'], fallback: false),
    );
  }

  factory ProjectCaseStudy.fromJson(String source) {
    return ProjectCaseStudy.fromMap(ModelNormalizer.map(json.decode(source)));
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

  factory ProjectCaseStudy.forProject({
    required String title,
    required String description,
    required String details,
    required String projectType,
    required List<String> technologies,
  }) {
    final scope = details.isNotEmpty ? details : description;
    final kind = projectType.isNotEmpty ? projectType : 'Flutter project';
    final technologySummary = technologies.isEmpty
        ? 'Flutter'
        : technologies.join(', ');

    return ProjectCaseStudy(
      role: 'Flutter Developer',
      timeline: 'Project implementation',
      challenge: scope.isNotEmpty
          ? 'The use case for $title: $scope'
          : 'The use case was to deliver $title as a focused $kind experience.',
      solution:
          'The project addresses this use case through maintainable Flutter '
          'flows built with $technologySummary.',
      results: const [],
      architecture: technologies,
    );
  }

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

  Map<String, Object?> toMap() => {
    'role': role,
    'timeline': timeline,
    'challenge': challenge,
    'solution': solution,
    'results': results.map((result) => result.toMap()).toList(growable: false),
    'architecture': architecture,
    'enabled': enabled,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ProjectCaseStudy(${toMap()})';

  @override
  bool operator ==(covariant ProjectCaseStudy other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
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

  factory PortfolioProject.fromMap(Map<String, Object?> map) {
    final title = ModelNormalizer.string(map['title']);
    final configuredSlug = ModelNormalizer.string(map['slug']);
    final description = ModelNormalizer.string(map['description']);
    final details = ModelNormalizer.string(map['details']);
    final tags = ModelNormalizer.strings(map['tags']);
    final projectType = ModelNormalizer.string(map['projectType']);
    final configuredCaseStudy = ModelNormalizer.map(map['caseStudy']);
    final parsedCaseStudy = configuredCaseStudy.isEmpty
        ? ProjectCaseStudy.empty
        : ProjectCaseStudy.fromMap(configuredCaseStudy);
    return PortfolioProject(
      slug: configuredSlug.isEmpty
          ? ModelNormalizer.slugify(title)
          : configuredSlug,
      title: title,
      description: description,
      details: details,
      tags: tags,
      category: ProjectCategory.fromName(
        ModelNormalizer.string(map['category']),
      ),
      url: ModelNormalizer.string(map['url']),
      destinationLabel: ModelNormalizer.string(map['destinationLabel']),
      iconName: ModelNormalizer.string(map['iconName']),
      code: ModelNormalizer.string(map['code']),
      imageUrl: ModelNormalizer.string(map['imageUrl']),
      appStoreUrl: ModelNormalizer.nullableString(map['appStoreUrl']),
      playStoreUrl: ModelNormalizer.nullableString(map['playStoreUrl']),
      pubDevUrl: ModelNormalizer.nullableString(map['pubDevUrl']),
      liveUrl: ModelNormalizer.nullableString(map['liveUrl']),
      projectType: projectType,
      sourceUrl: ModelNormalizer.nullableString(map['sourceUrl']),
      caseStudy: parsedCaseStudy.isAvailable
          ? parsedCaseStudy
          : ProjectCaseStudy.forProject(
              title: title,
              description: description,
              details: details,
              projectType: projectType,
              technologies: tags,
            ),
      featured: ModelNormalizer.boolean(map['featured']),
      order: ModelNormalizer.integer(map['order']),
      enabled: ModelNormalizer.boolean(map['enabled']),
    );
  }

  factory PortfolioProject.fromJson(String source) {
    return PortfolioProject.fromMap(ModelNormalizer.map(json.decode(source)));
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

  Map<String, Object?> toMap() => {
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

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'PortfolioProject(${toMap()})';

  @override
  bool operator ==(covariant PortfolioProject other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
