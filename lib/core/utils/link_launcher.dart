import 'package:flutter/foundation.dart';
import 'package:portfolio/core/utils/google_drive_url.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class LinkLauncher {
  static Future<bool> open(String rawUrl) async {
    final normalizedUrl = rawUrl.trim();
    final uri = Uri.tryParse(normalizedUrl);
    if (uri == null || !_isAllowed(uri)) {
      debugPrint('LinkLauncher rejected invalid URL: "$normalizedUrl"');
      return false;
    }

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (!launched) {
        debugPrint('LinkLauncher could not open URL: "$uri"');
      }
      return launched;
    } on Object catch (error, stackTrace) {
      debugPrint('LinkLauncher failed to open URL: "$uri", error=$error');
      debugPrintStack(
        label: 'LinkLauncher failure stack trace',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Opens a direct-download URL for a Google Drive file when possible.
  ///
  /// Firestore can store either the standard Google Drive sharing link or an
  /// already-direct download URL. Other valid HTTPS file URLs are preserved.
  static Future<bool> download(String rawUrl) =>
      open(GoogleDriveUrl.downloadSource(rawUrl));

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
