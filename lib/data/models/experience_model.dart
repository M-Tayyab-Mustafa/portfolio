import 'package:portfolio/domain/domain_exports.dart';

class ExperienceModel {
  final String date;
  final String title;
  final String subTitle;
  final String description;
  final int order;

  const ExperienceModel({
    required this.date,
    required this.title,
    required this.subTitle,
    required this.description,
    this.order = 0,
  });

  factory ExperienceModel.fromMap(Map<String, dynamic> data) => ExperienceModel(
    date: data['date'] as String? ?? '',
    title: data['title'] as String? ?? '',
    subTitle: data['subTitle'] as String? ?? '',
    description: data['description'] as String? ?? '',
    order: data['order'] as int? ?? 0,
  );

  ExperienceEntity toEntity() => ExperienceEntity(
    date: date,
    title: title,
    subTitle: subTitle,
    description: description,
    order: order,
  );
}
