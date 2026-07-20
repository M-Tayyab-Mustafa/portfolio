import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextTheme build() {
    final base = ThemeData.dark(useMaterial3: true).textTheme;
    final body = base.apply(fontFamily: 'Inter');
    final display = base.apply(fontFamily: 'SpaceGrotesk');

    return body.copyWith(
      displayLarge: display.displayLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        letterSpacing: -3.2,
        height: .9,
      ),
      displayMedium: display.displayMedium?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        letterSpacing: -2.4,
        height: .95,
      ),
      headlineLarge: display.headlineLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
      ),
      headlineMedium: display.headlineMedium?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: display.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: body.titleMedium?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        color: const Color(0xFFB5B5B5),
        height: 1.7,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        color: const Color(0xFFB5B5B5),
        height: 1.65,
      ),
      bodySmall: body.bodySmall?.copyWith(
        color: const Color(0xFF727272),
        height: 1.5,
      ),
      labelLarge: body.labelLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  static double heroSize(double width) {
    if (width < 1050) return 64;
    if (width < 1400) return 82;
    return 96;
  }

  static double sectionTitleSize(double width) {
    if (width < 1050) return 40;
    if (width < 1400) return 48;
    return 56;
  }
}
