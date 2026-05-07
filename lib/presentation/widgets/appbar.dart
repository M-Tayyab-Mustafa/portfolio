import 'package:portfolio/presentation/blocs/shell/_bloc.dart';
import 'package:portfolio/presentation/widgets/appbar_menu_item.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/utils/exports.dart';

class CSliverAppBar extends StatelessWidget {
  const CSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width < 760) {
      return _simpleAppBar(context: context);
    } else {
      return _buildWebAppBar(context: context);
    }
  }

  SliverAppBar _buildWebAppBar({required BuildContext context}) {
    return SliverAppBar(
      floating: true,
      leadingWidth: 200.w,
      centerTitle: true,
      leading: _buildTitle(context: context),
      title: _buildSections(context: context),
      actionsPadding: context.edgeInsets(right: 30),
      actions: [_buildThemeButton(context: context)],
    );
  }

  SliverAppBar _simpleAppBar({required BuildContext context}) {
    return SliverAppBar(
      floating: true,
      leading: DrawerButton(onPressed: () => Scaffold.of(context).openDrawer()),
      centerTitle: true,
      title: _buildTitle(context: context),
      actionsPadding: context.edgeInsets(right: 16),
      actions: [_buildThemeButton(context: context)],
    );
  }

  Widget _buildThemeButton({required BuildContext context}) {
    final isDark = AppThemeScope.isDark(context);
    return Padding(
      padding: context.edgeInsets(left: 16),
      child: IconButton(
        tooltip: isDark ? "Switch to light mode" : "Switch to dark mode",
        splashRadius: 22,
        onPressed: () => AppThemeScope.toggle(context),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 160),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            isDark ? Icons.dark_mode : Icons.light_mode,
            key: ValueKey(isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle({required BuildContext context}) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CImage(
            path: Constants.logoPath,
            size: 30,
            margin: context.edgeInsets(right: 12),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Tayyab',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '.dev',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSections({required BuildContext context}) {
    return BlocBuilder<ShellBloc, ShellState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedMenuItem(
              title: 'ABOUT',
              isSelected: state.currentRoute == AppRoutes.about,
              onTap: () => context.read<ShellBloc>().add(
                const ShellSectionSelected(AppRoutes.about),
              ),
            ),
            Padding(
              padding: context.edgeInsets(horizontal: 20),
              child: AnimatedMenuItem(
                title: 'SKILLS',
                isSelected: state.currentRoute == AppRoutes.skills,
                onTap: () => context.read<ShellBloc>().add(
                  const ShellSectionSelected(AppRoutes.skills),
                ),
              ),
            ),
            AnimatedMenuItem(
              title: 'EXPERIENCE',
              isSelected: state.currentRoute == AppRoutes.experience,
              onTap: () => context.read<ShellBloc>().add(
                const ShellSectionSelected(AppRoutes.experience),
              ),
            ),
            Padding(
              padding: context.edgeInsets(horizontal: 20),
              child: AnimatedMenuItem(
                title: 'PROJECTS',
                isSelected: state.currentRoute == AppRoutes.projects,
                onTap: () => context.read<ShellBloc>().add(
                  const ShellSectionSelected(AppRoutes.projects),
                ),
              ),
            ),
            AnimatedMenuItem(
              title: 'CONTACT',
              isSelected: state.currentRoute == AppRoutes.contact,
              onTap: () => context.read<ShellBloc>().add(
                const ShellSectionSelected(AppRoutes.contact),
              ),
            ),
          ],
        );
      },
    );
  }
}
