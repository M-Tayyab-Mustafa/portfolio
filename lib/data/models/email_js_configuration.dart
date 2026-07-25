import 'dart:convert';

import 'package:portfolio/core/utils/model_normalizer.dart';

class EmailJsConfiguration {
  const EmailJsConfiguration({
    required this.serviceId,
    required this.templateId,
    required this.publicKey,
    required this.nameParameter,
    required this.emailParameter,
    required this.subjectParameter,
    required this.messageParameter,
  });

  final String serviceId;
  final String templateId;
  final String publicKey;
  final String nameParameter;
  final String emailParameter;
  final String subjectParameter;
  final String messageParameter;

  factory EmailJsConfiguration.fromMap(Map<String, Object?> map) {
    return EmailJsConfiguration(
      serviceId: ModelNormalizer.string(map['serviceId']),
      templateId: ModelNormalizer.string(map['templateId']),
      publicKey: ModelNormalizer.string(map['publicKey']),
      nameParameter: ModelNormalizer.string(map['nameParameter']),
      emailParameter: ModelNormalizer.string(map['emailParameter']),
      subjectParameter: ModelNormalizer.string(map['subjectParameter']),
      messageParameter: ModelNormalizer.string(map['messageParameter']),
    );
  }

  factory EmailJsConfiguration.fromJson(String source) {
    return EmailJsConfiguration.fromMap(
      ModelNormalizer.map(json.decode(source)),
    );
  }

  bool get isConfigured =>
      serviceId.isNotEmpty &&
      templateId.isNotEmpty &&
      publicKey.isNotEmpty &&
      nameParameter.isNotEmpty &&
      emailParameter.isNotEmpty &&
      subjectParameter.isNotEmpty &&
      messageParameter.isNotEmpty;

  EmailJsConfiguration copyWith({
    String? serviceId,
    String? templateId,
    String? publicKey,
    String? nameParameter,
    String? emailParameter,
    String? subjectParameter,
    String? messageParameter,
  }) {
    return EmailJsConfiguration(
      serviceId: serviceId ?? this.serviceId,
      templateId: templateId ?? this.templateId,
      publicKey: publicKey ?? this.publicKey,
      nameParameter: nameParameter ?? this.nameParameter,
      emailParameter: emailParameter ?? this.emailParameter,
      subjectParameter: subjectParameter ?? this.subjectParameter,
      messageParameter: messageParameter ?? this.messageParameter,
    );
  }

  Map<String, Object?> toMap() => {
    'serviceId': serviceId,
    'templateId': templateId,
    'publicKey': publicKey,
    'nameParameter': nameParameter,
    'emailParameter': emailParameter,
    'subjectParameter': subjectParameter,
    'messageParameter': messageParameter,
  };

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'EmailJsConfiguration('
        'serviceId: $serviceId, '
        'templateId: $templateId, '
        'publicKey: $publicKey, '
        'nameParameter: $nameParameter, '
        'emailParameter: $emailParameter, '
        'subjectParameter: $subjectParameter, '
        'messageParameter: $messageParameter'
        ')';
  }

  @override
  bool operator ==(covariant EmailJsConfiguration other) {
    if (identical(this, other)) return true;
    return other.serviceId == serviceId &&
        other.templateId == templateId &&
        other.publicKey == publicKey &&
        other.nameParameter == nameParameter &&
        other.emailParameter == emailParameter &&
        other.subjectParameter == subjectParameter &&
        other.messageParameter == messageParameter;
  }

  @override
  int get hashCode => Object.hash(
    serviceId,
    templateId,
    publicKey,
    nameParameter,
    emailParameter,
    subjectParameter,
    messageParameter,
  );
}
