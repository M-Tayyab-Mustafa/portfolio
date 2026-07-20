import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final textTheme = AppTypography.build();
    const colorScheme = ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.textPrimary,
      secondary: AppColors.accentBright,
      onSecondary: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.accentBright,
      onError: AppColors.textPrimary,
      outline: AppColors.borderStrong,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      textTheme: textTheme,
      focusColor: AppColors.accent.withValues(alpha: .28),
      hoverColor: AppColors.accent.withValues(alpha: .08),
      splashColor: AppColors.accent.withValues(alpha: .12),
      dividerColor: AppColors.border,
      cardColor: AppColors.surface,
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          minimumSize: WidgetStateProperty.all(const Size(48, 44)),
          shape: WidgetStateProperty.all(const StadiumBorder()),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textMuted.withValues(alpha: .7),
        ),
        labelStyle: textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        border: _border(AppColors.borderStrong),
        enabledBorder: _border(AppColors.borderStrong),
        focusedBorder: _border(AppColors.accent, width: 1.4),
        errorBorder: _border(AppColors.accentBright),
        focusedErrorBorder: _border(AppColors.accentBright, width: 1.4),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(6),
        radius: const Radius.circular(2),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.accent;
          }
          return AppColors.textMuted.withValues(alpha: .6);
        }),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.elevatedSurface,
          border: Border.all(color: AppColors.borderStrong),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
      ),
      visualDensity: VisualDensity.standard,
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
