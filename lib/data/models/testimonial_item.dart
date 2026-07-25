import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';

class TestimonialItem {
  const TestimonialItem({
    required this.name,
    required this.role,
    required this.company,
    required this.content,
    required this.rating,
    required this.avatar,
    required this.order,
    this.enabled = true,
  });

  factory TestimonialItem.fromMap(Map<String, Object?> map) {
    final name = ModelNormalizer.string(map['name']);
    final configuredAvatar = ModelNormalizer.string(map['avatar']);
    return TestimonialItem(
      name: name,
      role: ModelNormalizer.string(map['role']),
      company: ModelNormalizer.string(map['company']),
      content: ModelNormalizer.string(map['content']),
      rating: ModelNormalizer.integer(map['rating'], fallback: 5).clamp(1, 5),
      avatar: configuredAvatar.isEmpty
          ? ModelNormalizer.initials(name)
          : configuredAvatar,
      order: ModelNormalizer.integer(map['order']),
      enabled: ModelNormalizer.boolean(map['enabled']),
    );
  }

  factory TestimonialItem.fromJson(String source) {
    return TestimonialItem.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String name;
  final String role;
  final String company;
  final String content;
  final int rating;
  final String avatar;
  final int order;
  final bool enabled;

  Map<String, Object?> toMap() => {
    'name': name,
    'role': role,
    'company': company,
    'content': content,
    'rating': rating,
    'avatar': avatar,
    'order': order,
    'enabled': enabled,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'TestimonialItem(${toMap()})';

  @override
  bool operator ==(covariant TestimonialItem other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
