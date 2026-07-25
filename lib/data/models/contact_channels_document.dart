import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';

class ContactChannelsDocument {
  const ContactChannelsDocument({required this.items});

  factory ContactChannelsDocument.fromMap(Map<String, Object?> map) {
    final items = ModelNormalizer.enabledAndOrdered(
      ModelNormalizer.maps(map['items']).map(ContactChannel.fromMap),
      enabled: (item) => item.enabled,
      order: (item) => item.order,
    );
    return ContactChannelsDocument(items: items);
  }

  factory ContactChannelsDocument.fromJson(String source) {
    return ContactChannelsDocument.fromMap(
      ModelNormalizer.map(json.decode(source)),
    );
  }

  final List<ContactChannel> items;

  Map<String, Object?> toMap() => {
    'items': items.map((item) => item.toMap()).toList(growable: false),
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ContactChannelsDocument(${toMap()})';

  @override
  bool operator ==(covariant ContactChannelsDocument other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}

class ContactChannel {
  const ContactChannel({
    required this.label,
    required this.value,
    required this.url,
    required this.iconName,
    required this.order,
    this.enabled = true,
  });

  factory ContactChannel.fromMap(Map<String, Object?> map) => ContactChannel(
    label: ModelNormalizer.string(map['label']),
    value: ModelNormalizer.string(map['value']),
    url: ModelNormalizer.string(map['url']),
    iconName: ModelNormalizer.string(map['iconName']),
    order: ModelNormalizer.integer(map['order']),
    enabled: ModelNormalizer.boolean(map['enabled']),
  );

  factory ContactChannel.fromJson(String source) {
    return ContactChannel.fromMap(ModelNormalizer.map(json.decode(source)));
  }

  final String label;
  final String value;
  final String url;
  final String iconName;
  final int order;
  final bool enabled;

  Map<String, Object?> toMap() => {
    'label': label,
    'value': value,
    'url': url,
    'iconName': iconName,
    'order': order,
    'enabled': enabled,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ContactChannel(${toMap()})';

  @override
  bool operator ==(covariant ContactChannel other) {
    if (identical(this, other)) return true;
    return other.toJson() == toJson();
  }

  @override
  int get hashCode => toJson().hashCode;
}
