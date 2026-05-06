class SkillAnalyticEntity {
  final String icon;
  final String title;
  final String subtitle;
  final int order;

  const SkillAnalyticEntity({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.order = 0,
  });
}

class TechnicalSkillEntity {
  final String icon;
  final String title;
  final List<String> skills;
  final int order;

  const TechnicalSkillEntity({
    required this.icon,
    required this.title,
    required this.skills,
    this.order = 0,
  });
}
