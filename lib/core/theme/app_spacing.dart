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
  static const double tabletMinimum = 430;
  static const double desktopMinimum = 768;
  static const double compactDesktop = 1120;
  static const double wideDesktop = 1600;
  static const double contentMaxWidth = 1280;
  static const double mobileContentMaxWidth = tabletMinimum;
  static const double tabletContentMaxWidth = 980;
  static const double readingMaxWidth = 680;
  static const double navigationHeight = 80;
  static const double mobileNavigationHeight = 64;
  static const double tabletNavigationHeight = 72;
  static const double radius = 3;

  static bool isMobile(double width) => width < tabletMinimum;

  static double adaptiveNavigationHeight(double width) {
    return isMobile(width) ? mobileNavigationHeight : tabletNavigationHeight;
  }

  static double mobileHorizontalPadding(double width) {
    return width < 360 ? 16 : 20;
  }

  static double tabletHorizontalPadding(double width) {
    if (width < 720) return 24;
    if (width < 960) return 32;
    return 40;
  }

  static double horizontalPadding(double width) {
    if (isMobile(width)) return mobileHorizontalPadding(width);
    if (width < compactDesktop) return 28;
    if (width < wideDesktop) return 48;
    return 64;
  }

  static double sectionPadding(double width) {
    if (isMobile(width)) return 72;
    return width >= wideDesktop ? AppSpacing.sectionWide : AppSpacing.section;
  }
}
