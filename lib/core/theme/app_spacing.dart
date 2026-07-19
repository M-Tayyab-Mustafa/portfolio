abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double section = 112;
  static const double sectionWide = 128;
}

abstract final class AppLayout {
  static const double desktopMinimum = 900;
  static const double compactDesktop = 1120;
  static const double wideDesktop = 1600;
  static const double contentMaxWidth = 1280;
  static const double readingMaxWidth = 680;
  static const double navigationHeight = 80;
  static const double radius = 3;

  static double horizontalPadding(double width) {
    if (width < compactDesktop) return 28;
    if (width < wideDesktop) return 48;
    return 64;
  }

  static double sectionPadding(double width) {
    return width >= wideDesktop ? AppSpacing.sectionWide : AppSpacing.section;
  }
}
