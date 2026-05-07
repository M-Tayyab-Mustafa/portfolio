part of 'shell_page.dart';

class TabletLayout extends StatefulWidget {
  const TabletLayout({super.key});

  @override
  State<TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<TabletLayout> {
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
                  TabletAboutPage(key: SectionService.about),
                  TabletSkillsPage(key: SectionService.skills),
                  TabletExperiencePage(key: SectionService.experience),
                  TabletProjectsPage(key: SectionService.projects),
                  TabletContactPage(key: SectionService.contact),
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
