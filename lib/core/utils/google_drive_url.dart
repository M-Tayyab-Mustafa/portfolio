abstract final class GoogleDriveUrl {
  static String imageSource(String rawUrl) {
    final source = rawUrl.trim();
    final uri = Uri.tryParse(source);
    if (uri == null || uri.host.toLowerCase() != 'drive.google.com') {
      return source;
    }

    final fileId = _fileId(uri);
    if (fileId == null) return source;

    return 'https://lh3.googleusercontent.com/d/'
        '${Uri.encodeComponent(fileId)}=w2000';
  }

  static String downloadSource(String rawUrl) {
    final source = rawUrl.trim();
    final uri = Uri.tryParse(source);
    if (uri == null || uri.host.toLowerCase() != 'drive.google.com') {
      return source;
    }

    final fileId = _fileId(uri);
    if (fileId == null) return source;

    final queryParameters = <String, String>{'id': fileId, 'export': 'download'};
    final resourceKey = uri.queryParameters['resourcekey']?.trim();
    if (resourceKey != null && resourceKey.isNotEmpty) {
      queryParameters['resourcekey'] = resourceKey;
    }
    return Uri.https('drive.usercontent.google.com', '/download', queryParameters).toString();
  }

  static String? _fileId(Uri uri) {
    final segments = uri.pathSegments;
    for (var index = 0; index < segments.length - 1; index++) {
      if (segments[index] != 'd') continue;
      final fileId = segments[index + 1].trim();
      if (fileId.isNotEmpty) return fileId;
    }

    final queryFileId = uri.queryParameters['id']?.trim();
    return queryFileId == null || queryFileId.isEmpty ? null : queryFileId;
  }
}
