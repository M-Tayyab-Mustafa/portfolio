import 'package:portfolio/presentation/blocs/shell/_bloc.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/utils/exports.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, theme),
            Padding(
              padding: context.edgeInsets(bottom: 8),
              child: const Divider(),
            ),
            Expanded(
              child: BlocBuilder<ShellBloc, ShellState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _item(
                        context,
                        title: "ABOUT",
                        route: AppRoutes.about,
                        selected: state.currentRoute == AppRoutes.about,
                      ),
                      _item(
                        context,
                        title: "SKILLS",
                        route: AppRoutes.skills,
                        selected: state.currentRoute == AppRoutes.skills,
                      ),
                      _item(
                        context,
                        title: "EXPERIENCE",
                        route: AppRoutes.experience,
                        selected: state.currentRoute == AppRoutes.experience,
                      ),
                      _item(
                        context,
                        title: "PROJECTS",
                        route: AppRoutes.projects,
                        selected: state.currentRoute == AppRoutes.projects,
                      ),
                      _item(
                        context,
                        title: "CONTACT",
                        route: AppRoutes.contact,
                        selected: state.currentRoute == AppRoutes.contact,
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: context.edgeInsets(top: 8),
              child: const Divider(),
            ),

            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: context.edgeInsets(all: 16),
      child: Row(
        children: [
          CImage(
            path: Constants.logoPath,
            size: 40,
            margin: context.edgeInsets(right: 12),
          ),
          Text("Tayyab.dev", style: theme.textTheme.titleLarge),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required String title,
    required String route,
    required bool selected,
  }) {
    return Padding(
      padding: context.edgeInsets(horizontal: 12, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        selected: selected,
        selectedTileColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.1),
        leading: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 2.w,
          height: selected ? 20.h : 0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        title: Text(
          title,
          style: selected
              ? Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
              : Theme.of(context).textTheme.titleMedium,
        ),
        onTap: () {
          context.read<ShellBloc>().add(ShellSectionSelected(route));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: context.edgeInsets(all: 16),
      child: Text(
        "© 2023 Tayyab. All rights reserved.",
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
