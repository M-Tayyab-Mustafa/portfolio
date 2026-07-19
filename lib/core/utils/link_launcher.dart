import 'package:url_launcher/url_launcher.dart';

abstract final class LinkLauncher {
  static Future<bool> open(String rawUrl) async {
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || !_isAllowed(uri)) return false;

    try {
      return await launchUrl(uri, mode: LaunchMode.platformDefault);
    } on Exception {
      return false;
    }
  }

  static bool _isAllowed(Uri uri) {
    switch (uri.scheme.toLowerCase()) {
      case 'http':
      case 'https':
        return uri.host.isNotEmpty;
      case 'mailto':
      case 'tel':
        return uri.path.trim().isNotEmpty;
      default:
        return false;
    }
  }
}
