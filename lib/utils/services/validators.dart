part of 'package:portfolio/utils/utils_exports.dart';

class Validators {
  static String? name(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (v.trim().length < 3) return 'Name too short';
    return null;
  }

  static String? email(String? v) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!regex.hasMatch(v.trim())) return 'Invalid email';
    return null;
  }

  static String? message(String? v) {
    if (v == null || v.trim().isEmpty) return 'Message required';
    if (v.trim().length < 10) return 'Too short';
    return null;
  }
}
