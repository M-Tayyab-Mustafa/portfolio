part of 'package:portfolio/utils/utils_exports.dart';

class AppColors {
  AppColors._();

  // Neo-Technical color tokens from DESIGN.md.
  static const Color surface = Color(0xFFFBF9F8);
  static const Color surfaceDim = Color(0xFFDBD9D9);
  static const Color surfaceBright = Color(0xFFFBF9F8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF5F3F3);
  static const Color surfaceContainer = Color(0xFFEFEDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE8E7);
  static const Color surfaceContainerHighest = Color(0xFFE4E2E2);
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color onSurfaceVariant = Color(0xFF444748);
  static const Color inverseSurface = Color(0xFF303030);
  static const Color inverseOnSurface = Color(0xFFF2F0F0);
  static const Color outline = Color(0xFF747878);
  static const Color outlineVariant = Color(0xFFC4C7C7);
  static const Color surfaceTint = Color(0xFF5F5E5E);
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1C1B1B);
  static const Color onPrimaryContainer = Color(0xFF858383);
  static const Color inversePrimary = Color(0xFFC8C6C5);
  static const Color secondary = Color(0xFFB71511);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFDB3327);
  static const Color onSecondaryContainer = Color(0xFFFFFBFF);
  static const Color tertiary = Color(0xFF000000);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF001551);
  static const Color onTertiaryContainer = Color(0xFF537AFF);
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color primaryFixed = Color(0xFFE5E2E1);
  static const Color primaryFixedDim = Color(0xFFC8C6C5);
  static const Color onPrimaryFixed = Color(0xFF1C1B1B);
  static const Color onPrimaryFixedVariant = Color(0xFF474746);
  static const Color secondaryFixed = Color(0xFFFFDAD5);
  static const Color secondaryFixedDim = Color(0xFFFFB4A9);
  static const Color onSecondaryFixed = Color(0xFF410001);
  static const Color onSecondaryFixedVariant = Color(0xFF930004);
  static const Color tertiaryFixed = Color(0xFFDCE1FF);
  static const Color tertiaryFixedDim = Color(0xFFB6C4FF);
  static const Color onTertiaryFixed = Color(0xFF001551);
  static const Color onTertiaryFixedVariant = Color(0xFF0039B3);
  static const Color background = Color(0xFFFBF9F8);
  static const Color onBackground = Color(0xFF1B1C1C);
  static const Color surfaceVariant = Color(0xFFE4E2E2);

  // Brand accents described in DESIGN.md prose.
  static const Color deepBlack = Color(0xFF1A1A1A);
  static const Color signalRed = Color(0xFFE63B2E);
  static const Color electricBlue = Color(0xFF0055FF);
  static const Color neutral = Color(0xFF4A4A4A);

  static const Color border = outlineVariant;
  static const Color divider = surfaceContainerHighest;
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color textMuted = Color(0xFF747878);
  static const Color textOnPrimary = onPrimary;
  static const Color textOnSecondary = onSecondary;
  static const Color textOnTertiary = onTertiary;

  static const Color lightBackground = background;
  static const Color lightSurface = surfaceDim;
  static const Color lightSurfaceVariant = surfaceContainer;
  static const Color lightSurfaceElevated = surfaceContainerHigh;
  static const Color lightBorder = outlineVariant;
  static const Color lightActiveBorder = deepBlack;
  static const Color lightCursorColor = deepBlack;
  static const Color lightSplashColor = surfaceTint;
  static const Color lightHighlightColor = surfaceTint;
  static const Color lightDivider = surfaceContainerHighest;
  static const Color lightTextPrimary = onSurface;
  static const Color lightTextSecondary = onSurfaceVariant;
  static const Color lightTextMuted = outline;

  static const Color darkBackground = Color(0xFF111111);
  static const Color darkSurface = Color(0xFF1C1B1B);
  static const Color darkSurfaceVariant = Color(0xFF242323);
  static const Color darkSurfaceElevated = Color(0xFF303030);
  static const Color darkBorder = outline;
  static const Color darkActiveBorder = inverseOnSurface;
  static const Color darkCursorColor = inverseOnSurface;
  static const Color darkSplashColor = inverseSurface;
  static const Color darkHighlightColor = inverseSurface;
  static const Color darkDivider = Color(0xFF3A3939);
  static const Color darkTextPrimary = inverseOnSurface;
  static const Color darkTextSecondary = Color(0xFFC8C6C5);
  static const Color darkTextMuted = Color(0xFF858383);

  static const Color success = Color(0xFF147A4D);
  static const Color warning = Color(0xFFB86B00);
  static const Color info = electricBlue;

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: textOnPrimary,
    primaryContainer: primaryFixed,
    onPrimaryContainer: onPrimaryFixed,
    secondary: secondary,
    onSecondary: textOnSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: textOnTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: textOnPrimary,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: lightTextPrimary,
    surfaceContainerHighest: surfaceContainerHighest,
    onSurfaceVariant: lightTextSecondary,
    outline: lightBorder,
    outlineVariant: lightDivider,
    shadow: Color(0x33000000),
    scrim: Color(0x66000000),
    inverseSurface: inverseSurface,
    onInverseSurface: inverseOnSurface,
    inversePrimary: inversePrimary,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: inversePrimary,
    onPrimary: primaryContainer,
    primaryContainer: primaryContainer,
    onPrimaryContainer: inverseOnSurface,
    secondary: secondaryFixedDim,
    onSecondary: onSecondaryFixed,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: onTertiaryContainer,
    onTertiary: onTertiaryFixed,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: tertiaryFixed,
    error: errorContainer,
    onError: onErrorContainer,
    errorContainer: onErrorContainer,
    onErrorContainer: errorContainer,
    surface: darkSurface,
    onSurface: darkTextPrimary,
    surfaceContainerHighest: darkSurfaceVariant,
    onSurfaceVariant: darkTextSecondary,
    outline: darkBorder,
    outlineVariant: darkDivider,
    shadow: Color(0x99000000),
    scrim: Color(0xCC000000),
    inverseSurface: surface,
    onInverseSurface: onSurface,
    inversePrimary: primary,
  );
}
