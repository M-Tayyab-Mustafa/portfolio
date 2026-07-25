import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';

class ServiceItem {
  const ServiceItem({
    required this.title,
    required this.description,
    required this.iconName,
    required this.order,
    this.enabled = true,
  });

  factory ServiceItem.fromMap(Map<String, Object?> map) => ServiceItem(
    title: ModelNormalizer.string(map['title']),
    description: ModelNormalizer.string(map['description']),
    iconName: ModelNormalizer.string(map['iconName']),
    order: ModelNormalizer.integer(map['order']),
    enabled: ModelNormalizer.boolean(map['enabled']),
  );

  factory ServiceItem.fromJson(String source) {
    return ServiceItem.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String title;
  final String description;
  final String iconName;
  final int order;
  final bool enabled;

  Map<String, Object?> toMap() => {
    'title': title,
    'description': description,
    'iconName': iconName,
    'order': order,
    'enabled': enabled,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ServiceItem(${toMap()})';

  @override
  bool operator ==(covariant ServiceItem other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
