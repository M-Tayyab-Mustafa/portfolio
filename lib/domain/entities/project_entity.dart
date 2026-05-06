class ProjectEntity {
  final String image;
  final String title;
  final String description;
  final List<String> skills;
  final String? playStoreLink;
  final String? appStoreLink;
  final bool isFeatured;
  final int order;

  const ProjectEntity({
    required this.image,
    required this.title,
    required this.description,
    required this.skills,
    this.playStoreLink,
    this.appStoreLink,
    this.isFeatured = false,
    this.order = 0,
  });
}
