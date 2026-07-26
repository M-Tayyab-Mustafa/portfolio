import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';

enum AppButtonVariant { primary, outline, ghost }

class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expanded = false,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final AppButtonVariant variant;
  final bool expanded;
  final bool compact;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final button = MouseRegion(
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppLayout.radius),
          boxShadow: widget.variant == AppButtonVariant.primary && _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: .34),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : const [],
        ),
        child: TextButton(
          onPressed: widget.onPressed,
          style: _style(),
          child: Row(
            mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.label.toUpperCase()),
              if (widget.icon case final icon?) ...[
                const SizedBox(width: AppSpacing.xs),
                icon,
              ],
            ],
          ),
        ),
      ),
    );

    return widget.expanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  ButtonStyle _style() {
    final horizontal = widget.compact ? 20.0 : 28.0;
    final vertical = widget.compact ? 13.0 : 17.0;

    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size(48, 48)),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.radius),
        ),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.35,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.textMuted;
        }
        if (widget.variant == AppButtonVariant.ghost &&
            states.contains(WidgetState.hovered)) {
          return AppColors.accent;
        }
        return AppColors.textPrimary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.elevatedSurface;
        }
        switch (widget.variant) {
          case AppButtonVariant.primary:
            return states.contains(WidgetState.hovered)
                ? AppColors.accentBright
                : AppColors.accent;
          case AppButtonVariant.outline:
            return states.contains(WidgetState.hovered)
                ? AppColors.accent.withValues(alpha: .1)
                : AppColors.transparent;
          case AppButtonVariant.ghost:
            return AppColors.transparent;
        }
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final focused = states.contains(WidgetState.focused);
        if (widget.variant == AppButtonVariant.outline || focused) {
          return BorderSide(
            color: focused ? AppColors.textPrimary : AppColors.accent,
            width: focused ? 2 : 1.4,
          );
        }
        return BorderSide.none;
      }),
      overlayColor: WidgetStateProperty.all(AppColors.transparent),
    );
  }
}

class AppIconButton extends StatefulWidget {
  const AppIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
    this.size = 44,
  });

  final Widget icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.accent.withValues(alpha: .1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppLayout.radius),
          border: Border.all(
            color: _hovered ? AppColors.accent : AppColors.border,
          ),
        ),
        child: IconButton(
          onPressed: widget.onPressed,
          tooltip: widget.tooltip,
          color: _hovered ? AppColors.textPrimary : AppColors.textSecondary,
          focusColor: AppColors.accent.withValues(alpha: .22),
          hoverColor: AppColors.transparent,
          splashColor: AppColors.transparent,
          iconSize: 20,
          icon: widget.icon,
        ),
      ),
    );
  }
}
