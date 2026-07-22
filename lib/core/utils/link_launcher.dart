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

  /// Opens a direct-download URL for a Google Drive file when possible.
  ///
  /// Firestore can store either the standard Google Drive sharing link or an
  /// already-direct download URL. Other valid HTTPS file URLs are preserved.
  static Future<bool> download(String rawUrl) => open(_downloadUrl(rawUrl));

  static String _downloadUrl(String rawUrl) {
    final uri = Uri.tryParse(rawUrl.trim());
    if (uri == null || uri.host.toLowerCase() != 'drive.google.com') {
      return rawUrl;
    }

    String? fileId;
    final pathSegments = uri.pathSegments;
    final fileIndex = pathSegments.indexOf('d');
    if (fileIndex >= 0 && fileIndex + 1 < pathSegments.length) {
      fileId = pathSegments[fileIndex + 1];
    }
    fileId ??= uri.queryParameters['id'];
    if (fileId == null || fileId.trim().isEmpty) return rawUrl;

    return Uri.https('drive.google.com', '/uc', {
      'export': 'download',
      'id': fileId,
    }).toString();
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
