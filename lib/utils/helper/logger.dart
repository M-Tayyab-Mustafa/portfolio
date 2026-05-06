part of 'package:portfolio/utils/utils_exports.dart';

class Logger {
  const Logger._();

  static void log(dynamic message, {String? name}) {
    if (kDebugMode) {
      developer.log('~Portfolio log $message', name: name ?? '');
    }
  }
}
