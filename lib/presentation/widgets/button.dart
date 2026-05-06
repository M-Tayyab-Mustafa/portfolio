import 'dart:math';

import 'package:portfolio/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.color,
    this.child,
    this.height,
    this.width,
    this.borderRadius,
    this.onTap,
    this.title,
    this.style,
    this.margin,
    this.padding,
    this.radius,
    this.titleColor,
  });
  final Color? color;
  final Widget? child;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final double? radius;
  final VoidCallback? onTap;
  final String? title;
  final Color? titleColor;
  final TextStyle? style;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final buttonRadius = borderRadius ?? BorderRadius.circular(radius?.r ?? 4);
    final theme = Theme.of(context);
    final backgroundColor = color ?? theme.colorScheme.primary;
    final effectiveTitleColor =
        titleColor ?? (color == null ? theme.colorScheme.onPrimary : null);
    final isPrimary = color == null || color == theme.colorScheme.primary;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        borderRadius: buttonRadius,
        onTap: onTap,
        child: Container(
          height: height?.h,
          width: width?.w,
          decoration: BoxDecoration(
            borderRadius: buttonRadius,
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isPrimary
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          alignment: Alignment.center,
          padding: padding ?? context.edgeInsets(vertical: 12, horizontal: 32),
          child: title != null
              ? Text(
                  title ?? '',
                  style:
                      style ??
                      theme.textTheme.labelLarge?.copyWith(
                        color: effectiveTitleColor,
                      ),
                )
              : child,
        ),
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({super.key, required this.title, required this.url});
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4.r),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          launchUrl(uri);
        }
      },
      child: Padding(
        padding: context.edgeInsets(vertical: 4, horizontal: 8),
        child: Text.rich(
          TextSpan(
            text: title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            children: [
              WidgetSpan(
                child: Padding(
                  padding: context.edgeInsets(left: 8),
                  child: Transform.rotate(
                    angle: -45 * pi / 180,
                    child: Icon(Icons.arrow_forward, size: 16.dm),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
