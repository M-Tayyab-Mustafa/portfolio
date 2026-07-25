import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';

class SkillItem {
  const SkillItem({required this.name, required this.iconName});

  factory SkillItem.fromMap(Map<String, Object?> map) => SkillItem(
    name: ModelNormalizer.string(map['name']),
    iconName: ModelNormalizer.string(map['iconName']),
  );

  factory SkillItem.fromJson(String source) {
    return SkillItem.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String name;
  final String iconName;

  Map<String, Object?> toMap() => {'name': name, 'iconName': iconName};

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'SkillItem(${toMap()})';

  @override
  bool operator ==(covariant SkillItem other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}

class SkillGroup {
  const SkillGroup({
    required this.title,
    required this.iconName,
    required this.skills,
    required this.order,
    this.enabled = true,
  });

  factory SkillGroup.fromMap(Map<String, Object?> map) => SkillGroup(
    title: ModelNormalizer.string(map['title']),
    iconName: ModelNormalizer.string(map['iconName']),
    skills: ModelNormalizer.maps(
      map['skills'],
    ).map(SkillItem.fromMap).toList(growable: false),
    order: ModelNormalizer.integer(map['order']),
    enabled: ModelNormalizer.boolean(map['enabled']),
  );

  factory SkillGroup.fromJson(String source) {
    return SkillGroup.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String title;
  final String iconName;
  final List<SkillItem> skills;
  final int order;
  final bool enabled;

  Map<String, Object?> toMap() => {
    'title': title,
    'iconName': iconName,
    'skills': skills.map((skill) => skill.toMap()).toList(growable: false),
    'order': order,
    'enabled': enabled,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'SkillGroup(${toMap()})';

  @override
  bool operator ==(covariant SkillGroup other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
