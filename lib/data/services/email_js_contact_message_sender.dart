import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:portfolio/domain/services/contact_message_sender.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';

class EmailJsContactMessageSender implements ContactMessageSender {
  EmailJsContactMessageSender({http.Client? client}) : _client = client;

  static final Uri _sendEndpoint = Uri.https(
    'api.emailjs.com',
    '/api/v1.0/email/send',
  );

  final http.Client? _client;

  @override
  Future<void> send({
    required EmailJsConfiguration configuration,
    required String senderName,
    required String senderEmail,
    required String subject,
    required String message,
  }) async {
    try {
      if (!configuration.isConfigured) {
        throw const FormatException(
          'EmailJS configuration is incomplete in Firestore.',
        );
      }

      final client = _client ?? http.Client();
      try {
        final response = await client
            .post(
              _sendEndpoint,
              headers: const {'Content-Type': 'application/json'},
              body: jsonEncode({
                'service_id': configuration.serviceId,
                'template_id': configuration.templateId,
                'user_id': configuration.publicKey,
                'template_params': {
                  configuration.nameParameter: senderName,
                  configuration.emailParameter: senderEmail,
                  configuration.subjectParameter: subject,
                  configuration.messageParameter: message,
                },
              }),
            )
            .timeout(const Duration(seconds: 20));

        if (response.statusCode != 200) {
          throw EmailJsDeliveryException(
            statusCode: response.statusCode,
            responseBody: response.body,
          );
        }
      } finally {
        if (_client == null) client.close();
      }
    } catch (error, stackTrace) {
      developer.log(
        'EmailJS message delivery failed for service '
        '"${configuration.serviceId}" and template '
        '"${configuration.templateId}".',
        name: 'portfolio.contact.emailjs',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

class EmailJsDeliveryException implements Exception {
  const EmailJsDeliveryException({
    required this.statusCode,
    required this.responseBody,
  });

  final int statusCode;
  final String responseBody;

  @override
  String toString() =>
      'EmailJSResponseStatus ([$statusCode] ${responseBody.trim()})';
}
