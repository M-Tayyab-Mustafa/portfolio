part of 'package:portfolio/utils/utils_exports.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextTheme textTheme(Color textColor) {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: textColor),
      displayMedium: displayMedium.copyWith(color: textColor),
      displaySmall: displaySmall.copyWith(color: textColor),
      headlineLarge: headlineLarge.copyWith(color: textColor),
      headlineMedium: headlineMedium.copyWith(color: textColor),
      headlineSmall: headlineSmall.copyWith(color: textColor),
      bodyLarge: bodyLarge.copyWith(color: textColor),
      bodyMedium: bodyMedium.copyWith(color: textColor),
      bodySmall: bodySmall.copyWith(color: textColor),
      labelLarge: labelLarge.copyWith(color: textColor),
      labelMedium: labelMedium.copyWith(color: textColor),
      labelSmall: labelSmall.copyWith(color: textColor),
      titleLarge: titleLarge.copyWith(color: textColor),
      titleMedium: titleMedium.copyWith(color: textColor),
      titleSmall: titleSmall.copyWith(color: textColor),
    );
  }

  // Display
  static TextStyle get displayLarge => TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: 0,
  );

  static TextStyle get displayMedium => TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.16,
    letterSpacing: 0,
  );

  static TextStyle get displaySmall => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0,
  );

  // Headings
  static TextStyle get headlineLarge => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.32,
    letterSpacing: 0,
  );

  static TextStyle get headlineSmall => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.36,
    letterSpacing: 0,
  );

  // Body
  static TextStyle get bodyLarge => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
    letterSpacing: 0,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
    letterSpacing: 0,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.55,
    letterSpacing: 0,
  );

  // Labels
  static TextStyle get labelLarge => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1,
    letterSpacing: 0,
  );

  static TextStyle get labelMedium => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1,
    letterSpacing: 0,
  );

  static TextStyle get labelSmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1,
    letterSpacing: 0,
  );

  // Titles
  static TextStyle get titleLarge => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.45,
    letterSpacing: 0,
  );

  static TextStyle get titleMedium => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.45,
    letterSpacing: 0,
  );

  static TextStyle get titleSmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.45,
    letterSpacing: 0,
  );
}
