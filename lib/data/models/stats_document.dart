import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';

class StatsDocument {
  const StatsDocument({required this.items});

  factory StatsDocument.fromMap(Map<String, Object?> map) {
    final items = ModelNormalizer.enabledAndOrdered(
      ModelNormalizer.maps(map['items']).map(StatItem.fromMap),
      enabled: (item) => item.enabled,
      order: (item) => item.order,
    );
    return StatsDocument(items: items);
  }

  factory StatsDocument.fromJson(String source) {
    return StatsDocument.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final List<StatItem> items;

  Map<String, Object?> toMap() => {
    'items': items.map((item) => item.toMap()).toList(growable: false),
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'StatsDocument(${toMap()})';

  @override
  bool operator ==(covariant StatsDocument other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}

class StatItem {
  const StatItem({
    required this.value,
    required this.label,
    required this.iconName,
    required this.order,
    this.enabled = true,
  });

  factory StatItem.fromMap(Map<String, Object?> map) => StatItem(
    value: ModelNormalizer.string(map['value']),
    label: ModelNormalizer.string(map['label']),
    iconName: ModelNormalizer.string(map['iconName']),
    order: ModelNormalizer.integer(map['order']),
    enabled: ModelNormalizer.boolean(map['enabled']),
  );

  factory StatItem.fromJson(String source) {
    return StatItem.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String value;
  final String label;
  final String iconName;
  final int order;
  final bool enabled;

  Map<String, Object?> toMap() => {
    'value': value,
    'label': label,
    'iconName': iconName,
    'order': order,
    'enabled': enabled,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'StatItem(${toMap()})';

  @override
  bool operator ==(covariant StatItem other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
