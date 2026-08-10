import 'dart:convert';

import 'package:portfolio/core/constants/portfolio_enums.dart';
import 'package:portfolio/core/utils/model_normalizer.dart';

class ExperienceItem {
  const ExperienceItem({
    required this.period,
    required this.title,
    required this.context,
    required this.description,
    required this.highlights,
    required this.kind,
    required this.order,
    this.enabled = true,
  });

  factory ExperienceItem.fromMap(Map<String, Object?> map) => ExperienceItem(
    period: ModelNormalizer.string(map['period']),
    title: ModelNormalizer.string(map['title']),
    context: ModelNormalizer.string(map['context']),
    description: ModelNormalizer.string(map['description']),
    highlights: ModelNormalizer.strings(map['highlights']),
    kind: ExperienceKind.fromName(ModelNormalizer.string(map['kind'])),
    order: ModelNormalizer.integer(map['order']),
    enabled: ModelNormalizer.boolean(map['enabled']),
  );

  factory ExperienceItem.fromJson(String source) {
    return ExperienceItem.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String period;
  final String title;
  final String context;
  final String description;
  final List<String> highlights;
  final ExperienceKind kind;
  final int order;
  final bool enabled;

  Map<String, Object?> toMap() => {
    'period': period,
    'title': title,
    'context': context,
    'description': description,
    'highlights': highlights,
    'kind': kind.name,
    'order': order,
    'enabled': enabled,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ExperienceItem(${toMap()})';

  @override
  bool operator ==(covariant ExperienceItem other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
