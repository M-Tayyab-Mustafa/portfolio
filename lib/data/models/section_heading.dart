import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';

class SectionHeading {
  const SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.accentTitle,
  });

  factory SectionHeading.fromMap(Map<String, Object?> map) => SectionHeading(
    eyebrow: ModelNormalizer.string(map['eyebrow']),
    title: ModelNormalizer.string(map['title']),
    accentTitle: ModelNormalizer.string(map['accentTitle']),
  );

  factory SectionHeading.fromJson(String source) {
    return SectionHeading.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String eyebrow;
  final String title;
  final String accentTitle;

  Map<String, Object?> toMap() => {
    'eyebrow': eyebrow,
    'title': title,
    'accentTitle': accentTitle,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'SectionHeading(${toMap()})';

  @override
  bool operator ==(covariant SectionHeading other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}

class PortfolioSectionHeadings {
  const PortfolioSectionHeadings({
    required this.about,
    required this.skills,
    required this.services,
    required this.projects,
    required this.experience,
    required this.testimonials,
    required this.contact,
  });

  factory PortfolioSectionHeadings.fromMap(Map<String, Object?> map) {
    return PortfolioSectionHeadings(
      about: SectionHeading.fromMap(ModelNormalizer.map(map['about'])),
      skills: SectionHeading.fromMap(ModelNormalizer.map(map['skills'])),
      services: SectionHeading.fromMap(ModelNormalizer.map(map['services'])),
      projects: SectionHeading.fromMap(ModelNormalizer.map(map['projects'])),
      experience: SectionHeading.fromMap(
        ModelNormalizer.map(map['experience']),
      ),
      testimonials: SectionHeading.fromMap(
        ModelNormalizer.map(map['testimonials']),
      ),
      contact: SectionHeading.fromMap(ModelNormalizer.map(map['contact'])),
    );
  }

  factory PortfolioSectionHeadings.fromJson(String source) {
    return PortfolioSectionHeadings.fromMap(
      ModelNormalizer.map(json.decode(source)),
    );
  }

  final SectionHeading about;
  final SectionHeading skills;
  final SectionHeading services;
  final SectionHeading projects;
  final SectionHeading experience;
  final SectionHeading testimonials;
  final SectionHeading contact;

  SectionHeading valueFor(String sectionName) => switch (sectionName) {
    'about' => about,
    'skills' => skills,
    'services' => services,
    'projects' => projects,
    'experience' => experience,
    'testimonials' => testimonials,
    'contact' => contact,
    _ => const SectionHeading(eyebrow: '', title: '', accentTitle: ''),
  };

  Map<String, Object?> toMap() => {
    'about': about.toMap(),
    'skills': skills.toMap(),
    'services': services.toMap(),
    'projects': projects.toMap(),
    'experience': experience.toMap(),
    'testimonials': testimonials.toMap(),
    'contact': contact.toMap(),
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'PortfolioSectionHeadings(${toMap()})';

  @override
  bool operator ==(covariant PortfolioSectionHeadings other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
