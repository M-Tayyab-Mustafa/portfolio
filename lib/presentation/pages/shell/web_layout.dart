part of 'shell_page.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({super.key});

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: Padding(
              padding: context.edgeInsets(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WebAboutPage(key: SectionService.about),
                  WebSkillsPage(key: SectionService.skills),
                  WebExperiencePage(key: SectionService.experience),
                  WebProjectsPage(key: SectionService.projects),
                  WebContactPage(key: SectionService.contact),
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
