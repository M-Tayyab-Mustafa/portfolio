import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size = 22,
    this.color,
    this.semanticLabel,
  });

  final String name;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    // Firestore can describe an icon by name, but the image itself always
    // resolves from this bundled local asset directory.
    final effectiveName = supportedNames.contains(name) ? name : 'code';
    final effectiveColor =
        color ??
        IconTheme.of(context).color ??
        DefaultTextStyle.of(context).style.color ??
        Colors.white;

    return SvgPicture.asset(
      'assets/icons/$effectiveName.svg',
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
        'assets/icons/brokenImage.svg',
        width: size,
        height: size,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(effectiveColor, BlendMode.srcIn),
        semanticsLabel: semanticLabel,
        excludeFromSemantics: semanticLabel == null,
        errorBuilder: (context, error, stackTrace) =>
            SizedBox.square(dimension: size),
      ),
    );
  }

  static const Set<String> supportedNames = {
    'android',
    'animation',
    'api',
    'architecture',
    'arrowDown',
    'arrowLeft',
    'arrowLongRight',
    'arrowRight',
    'arrowUp',
    'automation',
    'branch',
    'briefcase',
    'brokenImage',
    'calendar',
    'canvas',
    'check',
    'close',
    'cloud',
    'code',
    'database',
    'devices',
    'download',
    'email',
    'external',
    'flutter',
    'github',
    'info',
    'integration',
    'layers',
    'linkedin',
    'milestone',
    'mobile',
    'package',
    'palette',
    'payments',
    'person',
    'quote',
    'repository',
    'rocket',
    'security',
    'send',
    'speed',
    'state',
    'testing',
    'widgets',
  };
}
