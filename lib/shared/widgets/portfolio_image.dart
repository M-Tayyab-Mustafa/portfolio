import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/utils/google_drive_url.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';

class PortfolioImage extends StatelessWidget {
  const PortfolioImage({required this.source, super.key, this.width, this.height, this.fit, this.alignment = Alignment.center, this.semanticLabel, this.excludeFromSemantics = false, this.color, this.colorBlendMode, this.errorBuilder});

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

  @override
  Widget build(BuildContext context) {
    final resolvedSource = GoogleDriveUrl.imageSource(source);
    final uri = Uri.tryParse(resolvedSource);
    final isRemote = uri != null && (uri.scheme.toLowerCase() == 'https' || uri.scheme.toLowerCase() == 'http');
    Widget defaultErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
      return const Center(child: AppIcon('brokenImage', color: AppColors.textMuted, size: 28));
    }

    Widget handleImageError(BuildContext context, Object error, StackTrace? stackTrace) {
      final resolvedSource = GoogleDriveUrl.imageSource(source);
      final uri = Uri.tryParse(resolvedSource);
      debugPrint(
        'PortfolioImage failed to load. '
        'source="$source", resolvedSource="$uri", error=$error',
      );
      if (stackTrace != null) {
        debugPrintStack(label: 'PortfolioImage load failure stack trace', stackTrace: stackTrace);
      }
      return (errorBuilder ?? defaultErrorBuilder)(context, error, stackTrace);
    }

    if (isRemote) {
      return Image.network(resolvedSource, width: width, height: height, fit: fit, alignment: alignment, semanticLabel: semanticLabel, excludeFromSemantics: excludeFromSemantics, color: color, colorBlendMode: colorBlendMode, errorBuilder: handleImageError);
    }
    return Image.asset(resolvedSource, width: width, height: height, fit: fit, alignment: alignment, semanticLabel: semanticLabel, excludeFromSemantics: excludeFromSemantics, color: color, colorBlendMode: colorBlendMode, errorBuilder: handleImageError);
  }
}
