import 'package:portfolio/domain/domain_exports.dart';

class AboutModel {
  final String badge;
  final String name;
  final String bio;
  final String imageUrl;

  const AboutModel({
    required this.badge,
    required this.name,
    required this.bio,
    required this.imageUrl,
  });

  factory AboutModel.fromMap(Map<String, dynamic> data) => AboutModel(
    badge: data['badge'] as String? ?? '',
    name: data['name'] as String? ?? '',
    bio: data['bio'] as String? ?? '',
    imageUrl: data['imageUrl'] as String? ?? '',
  );

  AboutEntity toEntity() =>
      AboutEntity(badge: badge, name: name, bio: bio, imageUrl: imageUrl);
}
