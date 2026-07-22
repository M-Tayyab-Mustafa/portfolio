import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';

class PortfolioImage extends StatelessWidget {
  const PortfolioImage({
    required this.source,
    super.key,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.color,
    this.colorBlendMode,
    this.errorBuilder,
  });

  final String source;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final Color? color;
  final BlendMode? colorBlendMode;
  final ImageErrorWidgetBuilder? errorBuilder;

  static String _resolveSource(String source) {
    final uri = Uri.tryParse(source);
    if (uri == null || uri.host.toLowerCase() != 'drive.google.com') {
      return source;
    }

    String? fileId;
    final segments = uri.pathSegments;
    final fileIndex = segments.indexOf('file');
    if (fileIndex >= 0 &&
        segments.length > fileIndex + 2 &&
        segments[fileIndex + 1] == 'd') {
      fileId = segments[fileIndex + 2];
    } else {
      fileId = uri.queryParameters['id'];
    }

    if (fileId == null || fileId.isEmpty) return source;
    // Use Drive's final image host directly. The `/thumbnail` endpoint redirects,
    // and that redirect can be rejected by Flutter Web's image loader.
    return 'https://lh3.googleusercontent.com/d/'
        '${Uri.encodeComponent(fileId)}=w2000';
  }

  @override
  Widget build(BuildContext context) {
    final resolvedSource = _resolveSource(source);
    final uri = Uri.tryParse(resolvedSource);
    final isRemote =
        uri != null &&
        (uri.scheme.toLowerCase() == 'https' ||
            uri.scheme.toLowerCase() == 'http');
    Widget defaultErrorBuilder(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
    ) {
      return const Center(
        child: AppIcon('brokenImage', color: AppColors.textMuted, size: 28),
      );
    }

    if (isRemote) {
      return Image.network(
        resolvedSource,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: errorBuilder ?? defaultErrorBuilder,
      );
    }
    return Image.asset(
      resolvedSource,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      color: color,
      colorBlendMode: colorBlendMode,
      errorBuilder: errorBuilder ?? defaultErrorBuilder,
    );
  }
}
