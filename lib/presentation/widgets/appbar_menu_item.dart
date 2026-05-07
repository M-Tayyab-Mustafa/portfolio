import 'package:portfolio/utils/exports.dart';

class AnimatedMenuItem extends StatefulWidget {
  const AnimatedMenuItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<AnimatedMenuItem> createState() => AnimatedMenuItemState();
}

class AnimatedMenuItemState extends State<AnimatedMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected || _isHovered;
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: widget.title, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: isActive ? 1.05 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedSlide(
            offset: isActive ? const Offset(0, -0.04) : Offset.zero,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOutCubic,
                  style:
                      textStyle?.copyWith(
                        color: isActive
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurfaceVariant,
                      ) ??
                      TextStyle(color: theme.colorScheme.onSurface),
                  child: Text(widget.title),
                ),
                Padding(
                  padding: context.edgeInsets(top: 5),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOutCubic,
                    width: isActive ? textPainter.width + 16.w : 0,
                    height: 1,
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
