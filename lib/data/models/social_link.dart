import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';

class SocialLink {
  const SocialLink({
    required this.label,
    required this.url,
    required this.iconName,
    required this.order,
    this.enabled = true,
  });

  factory SocialLink.fromMap(Map<String, Object?> map) => SocialLink(
    label: ModelNormalizer.string(map['label']),
    url: ModelNormalizer.string(map['url']),
    iconName: ModelNormalizer.string(map['iconName']),
    order: ModelNormalizer.integer(map['order']),
    enabled: ModelNormalizer.boolean(map['enabled']),
  );

  factory SocialLink.fromJson(String source) {
    return SocialLink.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String label;
  final String url;
  final String iconName;
  final int order;
  final bool enabled;

  Map<String, Object?> toMap() => {
    'label': label,
    'url': url,
    'iconName': iconName,
    'order': order,
    'enabled': enabled,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'SocialLink(${toMap()})';

  @override
  bool operator ==(covariant SocialLink other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
