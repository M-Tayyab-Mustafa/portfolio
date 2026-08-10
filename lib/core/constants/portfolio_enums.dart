enum ProjectCategory {
  all('All work'),
  packages('Packages'),
  mobile('Mobile apps'),
  integrations('Integrations'),
  ui('UI engineering');

  const ProjectCategory(this.label);

  final String label;

  static ProjectCategory fromName(String? value) {
    return values.firstWhere(
      (category) => category.name == value,
      orElse: () => ProjectCategory.ui,
    );
  }
}

enum ExperienceKind {
  practice,
  milestone;

  static ExperienceKind fromName(String? value) {
    return values.firstWhere(
      (kind) => kind.name == value,
      orElse: () => ExperienceKind.practice,
    );
  }
}
