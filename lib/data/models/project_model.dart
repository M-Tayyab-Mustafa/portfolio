import 'package:portfolio/domain/domain_exports.dart';

class ProjectModel {
  final String image;
  final String title;
  final String description;
  final List<String> skills;
  final String? playStoreLink;
  final String? appStoreLink;
  final bool isFeatured;
  final int order;

  const ProjectModel({
    required this.image,
    required this.title,
    required this.description,
    required this.skills,
    this.playStoreLink,
    this.appStoreLink,
    this.isFeatured = false,
    this.order = 0,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> data) => ProjectModel(
    image: data['image'] as String? ?? '',
    title: data['title'] as String? ?? '',
    description: data['description'] as String? ?? '',
    skills: List<String>.from(data['skills'] as List? ?? []),
    playStoreLink: data['playStoreLink'] as String?,
    appStoreLink: data['appStoreLink'] as String?,
    isFeatured: data['isFeatured'] as bool? ?? false,
    order: data['order'] as int? ?? 0,
  );

  ProjectEntity toEntity() => ProjectEntity(
    image: image,
    title: title,
    description: description,
    skills: skills,
    playStoreLink: playStoreLink,
    appStoreLink: appStoreLink,
    isFeatured: isFeatured,
    order: order,
  );
}
