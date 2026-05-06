class ExperienceEntity {
  final String date;
  final String title;
  final String subTitle;
  final String description;
  final int order;

  const ExperienceEntity({
    required this.date,
    required this.title,
    required this.subTitle,
    required this.description,
    this.order = 0,
  });
}
