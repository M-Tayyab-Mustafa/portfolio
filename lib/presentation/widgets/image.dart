import 'package:portfolio/utils/exports.dart';

import 'platform_file_image_stub.dart'
    if (dart.library.io) 'platform_file_image_io.dart';

/// Provides reusable UI for image.
///
/// This file was re-documented without changing implementation behavior.

/// Defines the cImage type.
class CImage extends StatelessWidget {
  /// Creates a cImage instance.
  const CImage({
    super.key,
    required this.path,
    this.fit,
    this.size,
    this.height,
    this.width,
    this.type,
    this.borderRadius,
    this.clipper,
    this.clipBehavior = Clip.antiAlias,
    this.margin,
    this.padding,
    this.onTap,
    this.color,
    this.colorBlendMode,
    this.enableBorder = false,
    this.border,
    this.shape = BoxShape.rectangle,
  });

  final String path;
  final BoxFit? fit;
  final double? size;
  final double? height;
  final double? width;
  final Color? color;
  final BlendMode? colorBlendMode;
  final ImageType? type;
  final BorderRadiusGeometry? borderRadius;
  final CustomClipper<RRect>? clipper;
  final Clip clipBehavior;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final GestureTapCallback? onTap;
  final bool enableBorder;
  final Border? border;
  final BoxShape shape;

  /// Returns height.
  double? get _height => size?.dm ?? height?.h;

  /// Returns width.
  double? get _width => size?.dm ?? width?.w;

  /// Returns is circle.
  bool get _isCircle => shape == BoxShape.circle;

  /// Returns type.
  ImageType get _type {
    if (type != null) return type!;
    if (path.startsWith('assets/')) {
      return ImageType.asset;
    }

    return ImageType.network;
  }

  /// Builds the widget subtree for this component.
  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Center(child: _buildImage()),
    );

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: _height,
          width: _width,

          decoration: BoxDecoration(
            shape: shape,

            borderRadius: !_isCircle ? borderRadius ?? BorderRadius.zero : null,
            border: enableBorder ? border ?? const Border() : null,
          ),

          child: _isCircle
              ? ClipOval(clipBehavior: clipBehavior, child: child)
              : ClipRRect(
                  borderRadius: borderRadius ?? BorderRadius.zero,
                  clipper: clipper,
                  clipBehavior: clipBehavior,
                  child: child,
                ),
        ),
      ),
    );
  }

  /// Handles build image.
  Widget _buildImage() {
    final h = _height;
    final w = _width;

    return switch (_type) {
      ImageType.file => buildPlatformFileImage(
        path: path,
        isSvg: path.isSvg,
        fit: fit ?? BoxFit.contain,
        colorBlendMode: colorBlendMode,
        color: color,
        height: h,
        width: w,
      ),

      ImageType.asset =>
        path.isSvg
            ? SvgPicture.asset(
                path,
                fit: fit ?? BoxFit.contain,
                colorFilter: color != null
                    ? ColorFilter.mode(
                        color!,
                        colorBlendMode ?? BlendMode.srcIn,
                      )
                    : null,
                height: h,
                width: w,
              )
            : Image.asset(
                path,
                fit: fit ?? BoxFit.contain,
                colorBlendMode: colorBlendMode,
                color: color,
                height: h,
                width: w,
              ),

      ImageType.network => CachedNetworkImage(
        imageUrl: path,
        height: h,
        width: w,
        colorBlendMode: colorBlendMode,
        fit: fit ?? BoxFit.contain,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        placeholder: (context, url) => _buildPlaceholder(width: w, height: h),
        color: color,
      ),
    };
  }

  /// Handles build shimmer placeholder.
  Widget _buildPlaceholder({
    double? width,
    double? height,
    BorderRadius? radius,
  }) {
    final cs = Theme.of(navigatorKey.currentContext!).colorScheme;

    final baseColor = cs.surfaceContainerHighest;
    final highlightColor = cs.surfaceContainerLow;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

extension FileExtension on String {
  String get extension {
    if (isEmpty) return '';

    final parts = trim().split('.');

    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  bool get isSvg => extension == 'svg';
}
