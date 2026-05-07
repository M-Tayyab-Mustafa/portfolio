import 'package:portfolio/presentation/blocs/contact/_bloc.dart';
import 'package:portfolio/utils/exports.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return _buildMobileAndTabletFooter(context: context);
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      return _buildMobileAndTabletFooter(context: context);
    } else {
      return _buildWebFooter(context: context);
    }
  }

  Widget _footerLink({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
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

  Widget _buildMobileAndTabletFooter({required BuildContext context}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: context.edgeInsets(top: 16),
      padding: context.edgeInsets(top: 8),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '© 2023 MUHAMMAD TAYYAB. BUILT WITH FLUTTER & PRECISION.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: AppTextStyles.nimbusMonoFontFamily,
              color: colorScheme.onSecondary,
            ),
          ),
          Padding(
            padding: context.edgeInsets(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _footerLink(
                  context: context,
                  text: 'GITHUB',
                  onTap: () {
                    context.read<ContactBloc>().add(const GitHubEvent());
                  },
                ),
                _footerLink(
                  context: context,
                  text: 'LINKEDIN',
                  onTap: () {
                    context.read<ContactBloc>().add(const LinkedinEvent());
                  },
                ),
                _footerLink(
                  context: context,
                  text: 'EMAIL',
                  onTap: () {
                    context.read<ContactBloc>().add(const EmailEvent());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebFooter({required BuildContext context}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 60.h,
      margin: context.edgeInsets(top: 16),
      padding: context.edgeInsets(all: 16),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _footerLink(
                context: context,
                text: 'GITHUB',
                onTap: () {
                  context.read<ContactBloc>().add(const GitHubEvent());
                },
              ),
              _footerLink(
                context: context,
                text: 'LINKEDIN',
                onTap: () {
                  context.read<ContactBloc>().add(const LinkedinEvent());
                },
              ),
              _footerLink(
                context: context,
                text: 'EMAIL',
                onTap: () {
                  context.read<ContactBloc>().add(const EmailEvent());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
