part of 'shell_page.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({super.key});

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
        Container(
          height: 60.h,
          margin: context.edgeInsets(top: 20),
          padding: context.edgeInsets(horizontal: 80),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '© 2023 MUHAMMAD TAYYAB. BUILT WITH FLUTTER & PRECISION.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: AppTextStyles.nimbusMonoFontFamily,
                    color: colorScheme.onSecondary,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _footerLink(
                    text: 'GITHUB',
                    onTap: () {
                      context.read<ContactBloc>().add(const GitHubEvent());
                    },
                  ),
                  _footerLink(
                    text: 'LINKEDIN',
                    onTap: () {
                      context.read<ContactBloc>().add(const LinkedinEvent());
                    },
                  ),
                  _footerLink(
                    text: 'EMAIL',
                    onTap: () {
                      context.read<ContactBloc>().add(const EmailEvent());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _footerLink({required String text, required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: context.edgeInsets(horizontal: 12, vertical: 4),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontFamily: AppTextStyles.nimbusMonoFontFamily,
            color: colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
