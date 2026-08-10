import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';

class NavigationLabels {
  const NavigationLabels({
    required this.home,
    required this.about,
    required this.skills,
    required this.services,
    required this.projects,
    required this.experience,
    required this.contact,
  });

  factory NavigationLabels.fromMap(Map<String, Object?> map) => NavigationLabels(
    home: ModelNormalizer.string(map['home']),
    about: ModelNormalizer.string(map['about']),
    skills: ModelNormalizer.string(map['skills']),
    services: ModelNormalizer.string(map['services']),
    projects: ModelNormalizer.string(map['projects']),
    experience: ModelNormalizer.string(map['experience']),
    contact: ModelNormalizer.string(map['contact']),
  );

  factory NavigationLabels.fromJson(String source) {
    return NavigationLabels.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String home;
  final String about;
  final String skills;
  final String services;
  final String projects;
  final String experience;
  final String contact;

  String valueFor(String sectionName) => switch (sectionName) {
    'home' => home,
    'about' => about,
    'skills' => skills,
    'services' => services,
    'projects' => projects,
    'experience' => experience,
    'contact' => contact,
    _ => sectionName,
  };

  Map<String, Object?> toMap() => {
    'home': home,
    'about': about,
    'skills': skills,
    'services': services,
    'projects': projects,
    'experience': experience,
    'contact': contact,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'NavigationLabels(${toMap()})';

  @override
  bool operator ==(covariant NavigationLabels other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
