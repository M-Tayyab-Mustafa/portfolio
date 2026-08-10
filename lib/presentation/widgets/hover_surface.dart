import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

typedef HoverSurfaceBuilder =
    Widget Function(BuildContext context, bool hovered);

class HoverSurface extends StatefulWidget {
  const HoverSurface({
    required this.builder,
    super.key,
    this.background = AppColors.surface,
    this.padding = const EdgeInsets.all(28),
    this.lift = true,
    this.hoverBorder = AppColors.accent,
  });

  final HoverSurfaceBuilder builder;
  final Color background;
  final EdgeInsets padding;
  final bool lift;
  final Color hoverBorder;

  @override
  State<HoverSurface> createState() => _HoverSurfaceState();
}

class _HoverSurfaceState extends State<HoverSurface> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(
          0,
          widget.lift && _hovered ? -4 : 0,
          0,
        ),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.circular(AppLayout.radius),
          border: Border.all(
            color: _hovered
                ? widget.hoverBorder.withValues(alpha: .42)
                : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: .07),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ]
              : const [],
        ),
        child: widget.builder(context, _hovered),
      ),
    );
  }
}
