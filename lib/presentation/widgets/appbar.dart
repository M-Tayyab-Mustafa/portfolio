import 'package:portfolio/presentation/blocs/shell/_bloc.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/utils/exports.dart';

class CSliverAppBar extends StatelessWidget {
  const CSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return const SliverAppBar();
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      return _buildWebAndTabletAppBar(context: context);
    } else {
      return _buildWebAndTabletAppBar(context: context);
    }
  }

  SliverAppBar _buildWebAndTabletAppBar({required BuildContext context}) {
    final isDark = AppThemeScope.isDark(context);
    return SliverAppBar(
      floating: true,
      leadingWidth: _getLeadingWidth(context: context),
      leading: _buildLeading(context: context),
      centerTitle: true,
      title: _buildTitle(context: context),
      actionsPadding: context.edgeInsets(right: 30),
      actions: [
        Padding(
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
        ),
      ],
    );
  }

  double _getLeadingWidth({required BuildContext context}) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return 80.w;
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      if (MediaQuery.sizeOf(context).width >= 760) {
        return 250.w;
      } else {
        return 80.w;
      }
    } else {
      return 250.w;
    }
  }

  Widget? _buildLeading({required BuildContext context}) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return _buildDrawerOption(context: context);
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      if (MediaQuery.sizeOf(context).width >= 760) {
        return _buildLeadingTitle(context: context);
      } else {
        return _buildDrawerOption(context: context);
      }
    } else {
      return _buildLeadingTitle(context: context);
    }
  }

  Widget _buildTitle({required BuildContext context}) {
    if (ResponsiveBreakpoints.of(context).isTablet) {
      if (MediaQuery.sizeOf(context).width >= 760) {
        return _buildSections(context: context);
      } else {
        return _buildLeadingTitle(context: context);
      }
    } else {
      return _buildSections(context: context);
    }
  }

  Widget _buildLeadingTitle({required BuildContext context}) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CImage(
            path: Constants.logoPath,
            size: 32,
            margin: context.edgeInsets(right: 12),
          ),
          Text('Tayyab.dev', style: Theme.of(context).textTheme.displaySmall),
        ],
      ),
    );
  }

  Widget _buildDrawerOption({required BuildContext context}) {
    return Container();
  }

  Widget _buildSections({required BuildContext context}) {
    return BlocBuilder<ShellBloc, ShellState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AnimatedMenuItem(
              title: 'ABOUT',
              isSelected: state.currentRoute == AppRoutes.about,
              onTap: () => context.read<ShellBloc>().add(
                const ShellSectionSelected(AppRoutes.about),
              ),
            ),
            Padding(
              padding: context.edgeInsets(horizontal: 20),
              child: _AnimatedMenuItem(
                title: 'SKILLS',
                isSelected: state.currentRoute == AppRoutes.skills,
                onTap: () => context.read<ShellBloc>().add(
                  const ShellSectionSelected(AppRoutes.skills),
                ),
              ),
            ),
            _AnimatedMenuItem(
              title: 'EXPERIENCE',
              isSelected: state.currentRoute == AppRoutes.experience,
              onTap: () => context.read<ShellBloc>().add(
                const ShellSectionSelected(AppRoutes.experience),
              ),
            ),
            Padding(
              padding: context.edgeInsets(horizontal: 20),
              child: _AnimatedMenuItem(
                title: 'PROJECTS',
                isSelected: state.currentRoute == AppRoutes.projects,
                onTap: () => context.read<ShellBloc>().add(
                  const ShellSectionSelected(AppRoutes.projects),
                ),
              ),
            ),
            _AnimatedMenuItem(
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

class _AnimatedMenuItem extends StatefulWidget {
  const _AnimatedMenuItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_AnimatedMenuItem> createState() => _AnimatedMenuItemState();
}

class _AnimatedMenuItemState extends State<_AnimatedMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected || _isHovered;
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: widget.title, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: isActive ? 1.05 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedSlide(
            offset: isActive ? const Offset(0, -0.04) : Offset.zero,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOutCubic,
                  style:
                      textStyle?.copyWith(
                        color: isActive
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurfaceVariant,
                      ) ??
                      TextStyle(color: theme.colorScheme.onSurface),
                  child: Text(widget.title),
                ),
                Padding(
                  padding: context.edgeInsets(top: 5),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOutCubic,
                    width: isActive ? textPainter.width + 16.w : 0,
                    height: 1,
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
