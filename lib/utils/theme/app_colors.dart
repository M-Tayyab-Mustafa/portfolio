part of 'package:portfolio/utils/utils_exports.dart';

class AppColors {
  AppColors._();

  static const Color transparent = Color(0x00000000);

  static const Color primary = Color(0xFF22D3EE);
  static const Color secondary = Color(0xFF94A3B8);
  static const Color tertiary = Color(0xFFBCE1FF);
  static const Color neutral = Color(0xFF0C1324);

  static const Color deepNavy = Color(0xFF0C1324);
  static const Color midnightNavy = Color(0xFF080E1C);
  static const Color darkNavy = Color(0xFF111A2E);
  static const Color cardNavy = Color(0xFF121B30);
  static const Color elevatedNavy = Color(0xFF172238);
  static const Color borderNavy = Color(0xFF1E3A4A);

  static const Color cyanGlow = Color(0xFF22D3EE);
  static const Color cyanSoft = Color(0xFF67E8F9);
  static const Color iceBlue = Color(0xFFBCE1FF);
  static const Color slateText = Color(0xFF94A3B8);

  static const Color surface = Color(0xFF0C1324);
  static const Color surfaceDim = Color(0xFF080E1C);
  static const Color surfaceBright = Color(0xFF172238);

  static const Color surfaceContainerLowest = Color(0xFF070C18);
  static const Color surfaceContainerLow = Color(0xFF0A1120);
  static const Color surfaceContainer = Color(0xFF111A2E);
  static const Color surfaceContainerHigh = Color(0xFF172238);
  static const Color surfaceContainerHighest = Color(0xFF1E2A42);

  static const Color onSurface = Color(0xFFEAF6FF);
  static const Color onSurfaceVariant = Color(0xFF94A3B8);

  static const Color inverseSurface = Color(0xFFEAF6FF);
  static const Color inverseOnSurface = Color(0xFF0C1324);

  static const Color outline = Color(0xFF2D4B5E);
  static const Color outlineVariant = Color(0xFF1E3A4A);

  static const Color surfaceTint = primary;

  static const Color onPrimary = Color(0xFF03151A);
  static const Color primaryContainer = Color(0xFF063B46);
  static const Color onPrimaryContainer = Color(0xFFB8F6FF);
  static const Color inversePrimary = Color(0xFF0891B2);

  static const Color onSecondary = Color(0xFF0C1324);
  static const Color secondaryContainer = Color(0xFF1E293B);
  static const Color onSecondaryContainer = Color(0xFFE2E8F0);

  static const Color onTertiary = Color(0xFF07111F);
  static const Color tertiaryContainer = Color(0xFF12314A);
  static const Color onTertiaryContainer = Color(0xFFE5F5FF);

  static const Color error = Color(0xFFFF6B6B);
  static const Color onError = Color(0xFF2A0000);
  static const Color errorContainer = Color(0xFF5A1111);
  static const Color onErrorContainer = Color(0xFFFFDADA);

  static const Color primaryFixed = Color(0xFFB8F6FF);
  static const Color primaryFixedDim = Color(0xFF67E8F9);
  static const Color onPrimaryFixed = Color(0xFF03151A);
  static const Color onPrimaryFixedVariant = Color(0xFF065A6A);

  static const Color secondaryFixed = Color(0xFFE2E8F0);
  static const Color secondaryFixedDim = Color(0xFF94A3B8);
  static const Color onSecondaryFixed = Color(0xFF0C1324);
  static const Color onSecondaryFixedVariant = Color(0xFF334155);

  static const Color tertiaryFixed = Color(0xFFE5F5FF);
  static const Color tertiaryFixedDim = Color(0xFFBCE1FF);
  static const Color onTertiaryFixed = Color(0xFF07111F);
  static const Color onTertiaryFixedVariant = Color(0xFF164E63);

  static const Color background = neutral;
  static const Color onBackground = Color(0xFFEAF6FF);
  static const Color surfaceVariant = Color(0xFF111A2E);

  static const Color deepBlack = Color(0xFF080E1C);
  static const Color signalRed = Color(0xFFFF6B6B);
  static const Color electricBlue = primary;

  static const Color border = outlineVariant;
  static const Color divider = Color(0xFF1E3A4A);

  static const Color textPrimary = Color(0xFFEAF6FF);
  static const Color textSecondary = secondary;
  static const Color textMuted = Color(0xFF64748B);

  static const Color textOnPrimary = onPrimary;
  static const Color textOnSecondary = onSecondary;
  static const Color textOnTertiary = onTertiary;

  static const Color lightBackground = Color(0xFFF8FCFF);
  static const Color lightShadow = Color(0x220C1324);
  static const Color lightScrim = Color(0x660C1324);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEAF6FF);
  static const Color lightSurfaceElevated = Color(0xFFF1F9FF);

  static const Color lightBorder = Color(0xFFB7D7E5);
  static const Color lightActiveBorder = primary;

  static const Color lightCursorColor = primary;
  static const Color lightSplashColor = Color(0x3322D3EE);
  static const Color lightHighlightColor = Color(0x2222D3EE);

  static const Color lightDivider = Color(0xFFD6EAF2);

  static const Color lightTextPrimary = Color(0xFF0C1324);
  static const Color lightTextSecondary = Color(0xFF334155);
  static const Color lightTextMuted = Color(0xFF64748B);

  static const Color darkBackground = Color(0xFF0C1324);
  static const Color darkShadow = Color(0x99000000);
  static const Color darkScrim = Color(0xCC000000);

  static const Color darkSurface = Color(0xFF111A2E);
  static const Color darkSurfaceVariant = Color(0xFF172238);
  static const Color darkSurfaceElevated = Color(0xFF1E2A42);

  static const Color darkBorder = Color(0xFF1E3A4A);
  static const Color darkActiveBorder = primary;

  static const Color darkCursorColor = primary;
  static const Color darkSplashColor = Color(0x3322D3EE);
  static const Color darkHighlightColor = Color(0x2222D3EE);

  static const Color darkDivider = Color(0xFF1E3A4A);

  static const Color darkTextPrimary = Color(0xFFEAF6FF);
  static const Color darkTextSecondary = Color(0xFFB6C3D1);
  static const Color darkTextMuted = Color(0xFF94A3B8);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = primary;

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryFixed,
    onPrimaryContainer: onPrimaryFixed,

    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryFixed,
    onSecondaryContainer: onSecondaryFixed,

    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryFixed,
    onTertiaryContainer: onTertiaryFixed,

    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,

    surface: lightSurface,
    onSurface: lightTextPrimary,
    surfaceContainerHighest: lightSurfaceElevated,
    onSurfaceVariant: lightTextSecondary,

    outline: lightBorder,
    outlineVariant: lightDivider,

    shadow: lightShadow,
    scrim: lightScrim,

    inverseSurface: darkSurface,
    onInverseSurface: darkTextPrimary,
    inversePrimary: inversePrimary,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,

    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,

    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,

    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,

    surface: darkSurface,
    onSurface: darkTextPrimary,
    surfaceContainerHighest: darkSurfaceElevated,
    onSurfaceVariant: darkTextSecondary,

    outline: darkBorder,
    outlineVariant: darkDivider,

    shadow: darkShadow,
    scrim: darkScrim,

    inverseSurface: lightSurface,
    onInverseSurface: lightTextPrimary,
    inversePrimary: inversePrimary,
  );
}
