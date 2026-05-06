import 'package:portfolio/domain/domain_exports.dart';

class SkillAnalyticModel {
  final String icon;
  final String title;
  final String subtitle;
  final int order;

  const SkillAnalyticModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.order = 0,
  });

  factory SkillAnalyticModel.fromMap(Map<String, dynamic> data) =>
      SkillAnalyticModel(
        icon: data['icon'] as String? ?? '',
        title: data['title'] as String? ?? '',
        subtitle: data['subtitle'] as String? ?? '',
        order: data['order'] as int? ?? 0,
      );

  SkillAnalyticEntity toEntity() => SkillAnalyticEntity(
    icon: icon,
    title: title,
    subtitle: subtitle,
    order: order,
  );
}

class TechnicalSkillModel {
  final String icon;
  final String title;
  final List<String> skills;
  final int order;

  const TechnicalSkillModel({
    required this.icon,
    required this.title,
    required this.skills,
    this.order = 0,
  });

  factory TechnicalSkillModel.fromMap(Map<String, dynamic> data) =>
      TechnicalSkillModel(
        icon: data['icon'] as String? ?? '',
        title: data['title'] as String? ?? '',
        skills: List<String>.from(data['skills'] as List? ?? []),
        order: data['order'] as int? ?? 0,
      );

  TechnicalSkillEntity toEntity() => TechnicalSkillEntity(
    icon: icon,
    title: title,
    skills: skills,
    order: order,
  );
}
