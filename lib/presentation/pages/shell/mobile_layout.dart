part of 'shell_page.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: context.edgeInsets(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MobileAboutPage(key: SectionService.about),
                  MobileSkillsPage(key: SectionService.skills),
                  MobileExperiencePage(key: SectionService.experience),
                  MobileProjectsPage(key: SectionService.projects),
                  MobileContactPage(key: SectionService.contact),
                ],
              ),
            ),
          ),
        ),
        FooterWidget(),
      ],
    );
  }
}
