part of 'package:portfolio/utils/utils_exports.dart';

class SectionService {
  const SectionService._();

  static final about = GlobalKey();
  static final skills = GlobalKey();
  static final experience = GlobalKey();
  static final projects = GlobalKey();
  static final contact = GlobalKey();

  static GlobalKey? fromRoute(String route) => switch (route) {
    AppRoutes.about => about,
    AppRoutes.skills => skills,
    AppRoutes.experience => experience,
    AppRoutes.projects => projects,
    AppRoutes.contact => contact,
    _ => null,
  };

  static Future<void> scrollToSection(GlobalKey key) async {
    final context = key.currentContext;

    if (context == null || !context.mounted) return;

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }
}
