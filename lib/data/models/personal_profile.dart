import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';

class PersonalProfile {
  const PersonalProfile({
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.subtitle,
    required this.aboutBrief,
    required this.aboutLong,
    required this.email,
    required this.portraitAsset,
    required this.logoAsset,
    required this.roles,
    required this.coreFocus,
  });

  factory PersonalProfile.fromMap(Map<String, Object?> map, {String? logoAssetOverride}) {
    return PersonalProfile(
      firstName: ModelNormalizer.string(map['firstName']),
      lastName: ModelNormalizer.string(map['lastName']),
      title: ModelNormalizer.string(map['title']),
      subtitle: ModelNormalizer.string(map['subtitle']),
      aboutBrief: ModelNormalizer.string(map['aboutBrief']),
      aboutLong: ModelNormalizer.string(map['aboutLong']),
      email: ModelNormalizer.string(map['email']),
      portraitAsset: ModelNormalizer.string(map['portraitAsset']),
      logoAsset: logoAssetOverride ?? ModelNormalizer.string(map['logoAsset']),
      roles: ModelNormalizer.strings(map['roles']),
      coreFocus: ModelNormalizer.strings(map['coreFocus']),
    );
  }

  factory PersonalProfile.fromJson(String source) {
    return PersonalProfile.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String firstName;
  final String lastName;
  final String title;
  final String subtitle;
  final String aboutBrief;
  final String aboutLong;
  final String email;
  final String portraitAsset;
  final String logoAsset;
  final List<String> roles;
  final List<String> coreFocus;

  String get fullName => '$firstName $lastName'.trim();

  Map<String, Object?> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'title': title,
    'subtitle': subtitle,
    'aboutBrief': aboutBrief,
    'aboutLong': aboutLong,
    'email': email,
    'portraitAsset': portraitAsset,
    'logoAsset': logoAsset,
    'roles': roles,
    'coreFocus': coreFocus,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'PersonalProfile(${toMap()})';

  @override
  bool operator ==(covariant PersonalProfile other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
