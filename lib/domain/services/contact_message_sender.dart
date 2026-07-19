import 'package:portfolio/shared/models/portfolio_models.dart';

abstract interface class ContactMessageSender {
  Future<void> send({
    required EmailJsConfiguration configuration,
    required String senderName,
    required String senderEmail,
    required String subject,
    required String message,
  });
}
