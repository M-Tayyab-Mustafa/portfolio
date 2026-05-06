part of 'package:portfolio/utils/utils_exports.dart';

class AppTextStyles {
  AppTextStyles._();

  static final String? interFontFamily = GoogleFonts.inter().fontFamily;
  static final String? spaceGroteskFontFamily =
      GoogleFonts.spaceGrotesk().fontFamily;
  static final String nimbusMonoFontFamily = 'Nimbus Mono';

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
    fontFamily: spaceGroteskFontFamily,
    fontSize: 48.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: 0,
  );

  static TextStyle get displayMedium => TextStyle(
    fontFamily: spaceGroteskFontFamily,
    fontSize: 40.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.16,
    letterSpacing: 0,
  );

  static TextStyle get displaySmall => TextStyle(
    fontFamily: spaceGroteskFontFamily,
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0,
  );

  // Headings
  static TextStyle get headlineLarge => TextStyle(
    fontFamily: spaceGroteskFontFamily,
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontFamily: spaceGroteskFontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.32,
    letterSpacing: 0,
  );

  static TextStyle get headlineSmall => TextStyle(
    fontFamily: spaceGroteskFontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.36,
    letterSpacing: 0,
  );

  // Body
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: interFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
    letterSpacing: 0,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: interFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
    letterSpacing: 0,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: interFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.55,
    letterSpacing: 0,
  );

  // Labels
  static TextStyle get labelLarge => TextStyle(
    fontFamily: interFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1,
    letterSpacing: 0,
  );

  static TextStyle get labelMedium => TextStyle(
    fontFamily: interFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1,
    letterSpacing: 0,
  );

  static TextStyle get labelSmall => TextStyle(
    fontFamily: interFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1,
    letterSpacing: 0,
  );

  // Titles
  static TextStyle get titleLarge => TextStyle(
    fontFamily: interFontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.45,
    letterSpacing: 0,
  );

  static TextStyle get titleMedium => TextStyle(
    fontFamily: interFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.45,
    letterSpacing: 0,
  );

  static TextStyle get titleSmall => TextStyle(
    fontFamily: interFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.45,
    letterSpacing: 0,
  );
}
