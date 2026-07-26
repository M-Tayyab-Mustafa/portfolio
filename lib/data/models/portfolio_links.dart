import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';
import 'package:portfolio/data/models/portfolio_link_key.dart';

class PortfolioLinks {
  const PortfolioLinks({
    required this.github,
    required this.linkedin,
    required this.pubDev,
    required this.resumeUrl,
  });

  factory PortfolioLinks.fromMap(Map<String, Object?> map) => PortfolioLinks(
    github: ModelNormalizer.string(map[PortfolioLinkKey.github]),
    linkedin: ModelNormalizer.string(map[PortfolioLinkKey.linkedin]),
    pubDev: ModelNormalizer.string(map[PortfolioLinkKey.pubDev]),
    resumeUrl: ModelNormalizer.string(map[PortfolioLinkKey.resumeUrl]),
  );

  factory PortfolioLinks.fromJson(String source) {
    return PortfolioLinks.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String github;
  final String linkedin;
  final String pubDev;
  final String resumeUrl;

  String valueFor(String key) => switch (key) {
    PortfolioLinkKey.github => github,
    PortfolioLinkKey.linkedin => linkedin,
    PortfolioLinkKey.pubDev => pubDev,
    PortfolioLinkKey.resumeUrl => resumeUrl,
    _ => '',
  };

  Map<String, Object?> toMap() => {
    PortfolioLinkKey.github: github,
    PortfolioLinkKey.linkedin: linkedin,
    PortfolioLinkKey.pubDev: pubDev,
    PortfolioLinkKey.resumeUrl: resumeUrl,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'PortfolioLinks(${toMap()})';

  @override
  bool operator ==(covariant PortfolioLinks other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
