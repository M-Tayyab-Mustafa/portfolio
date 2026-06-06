part of 'package:portfolio/utils/utils_exports.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(BuildContext context) {
    return _build(
      brightness: Brightness.light,
      colorScheme: AppColors.lightColorScheme,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      surfaceVariant: AppColors.lightSurfaceVariant,
      surfaceElevated: AppColors.lightSurfaceElevated,
      border: AppColors.lightBorder,
      activeBorder: AppColors.lightActiveBorder,
      cursorColor: AppColors.lightCursorColor,
      splashColor: AppColors.lightSplashColor,
      highlightColor: AppColors.lightHighlightColor,
      divider: AppColors.lightDivider,
      textPrimary: AppColors.lightTextPrimary,
      textSecondary: AppColors.lightTextSecondary,
      textMuted: AppColors.lightTextMuted,
      textButtonColor: AppColors.primary,
    );
  }

  static ThemeData dark(BuildContext context) {
    return _build(
      brightness: Brightness.dark,
      colorScheme: AppColors.darkColorScheme,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      surfaceVariant: AppColors.darkSurfaceVariant,
      surfaceElevated: AppColors.darkSurfaceElevated,
      border: AppColors.darkBorder,
      activeBorder: AppColors.darkActiveBorder,
      cursorColor: AppColors.darkCursorColor,
      splashColor: AppColors.darkSplashColor,
      highlightColor: AppColors.darkHighlightColor,
      divider: AppColors.darkDivider,
      textPrimary: AppColors.darkTextPrimary,
      textSecondary: AppColors.darkTextSecondary,
      textMuted: AppColors.darkTextMuted,
      textButtonColor: AppColors.inversePrimary,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color background,
    required Color surface,
    required Color surfaceVariant,
    required Color surfaceElevated,
    required Color border,
    required Color activeBorder,
    required Color cursorColor,
    required Color splashColor,
    required Color highlightColor,
    required Color divider,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
    required Color textButtonColor,
  }) {
    final textTheme = AppTextStyles.textTheme(textPrimary);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      cardColor: surface,
      dividerColor: divider,
      disabledColor: textMuted.withAlpha(115),
      textTheme: textTheme,
      fontFamily: AppTextStyles.hankenGrotesk,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: surface.withValues(alpha: 0.8),
        foregroundColor: textPrimary,
        surfaceTintColor: AppColors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        surfaceTintColor: AppColors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
          side: BorderSide(color: border.withAlpha(190)),
        ),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textButtonColor,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface.withValues(alpha: 0.5),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textMuted),
        labelStyle: textTheme.labelMedium,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: activeBorder, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
      iconTheme: IconThemeData(color: textSecondary, size: 20),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: cursorColor,
        selectionColor: cursorColor.withAlpha(82),
        selectionHandleColor: cursorColor,
      ),
      splashColor: splashColor.withAlpha(31),
      highlightColor: highlightColor.withAlpha(20),
      visualDensity: VisualDensity.standard,
    );
  }
}
