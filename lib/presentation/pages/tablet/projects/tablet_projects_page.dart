import 'package:portfolio/presentation/blocs/projects/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/heading.dart';
import 'package:portfolio/presentation/widgets/project_card.dart';
import 'package:portfolio/utils/exports.dart';

class TabletProjectsPage extends StatefulWidget {
  const TabletProjectsPage({super.key});

  @override
  State<TabletProjectsPage> createState() => _TabletProjectsPageState();
}

class _TabletProjectsPageState extends State<TabletProjectsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectsBloc>().add(const ProjectsStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: context.edgeInsets(top: 32, bottom: 16),
                child: FadeSlide(
                  child: TabletHeadingText(
                    text: 'Featured Projects',
                    trailing: 'View All',
                    onTapTrailing: () => context.read<ProjectsBloc>().add(
                      ViewAllProjects(context: context),
                    ),
                  ),
                ),
              ),
              if (state.isLoading)
                _buildShimmerSkeleton()
              else
                Padding(
                  padding: context.edgeInsets(top: 48, bottom: 64),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        runSpacing: 24,
                        children: state.featuredProjects
                            .asMap()
                            .entries
                            .map(
                              (e) => ScaleFade(
                                delay: Duration(
                                  milliseconds: 150 + e.key * 180,
                                ),
                                child: HoverCard(
                                  child: ProjectCard(project: e.value),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerSkeleton() {
    final cs = Theme.of(context).colorScheme;

    const placeholderCount = 4;

    return Padding(
      padding: context.edgeInsets(top: 48, bottom: 64),
      child: Shimmer.fromColors(
        baseColor: cs.surfaceContainerHighest,
        highlightColor: cs.surfaceContainerLow,
        child: Wrap(
          spacing: 24.w,
          runSpacing: 24.h,
          children: List.generate(
            placeholderCount,
            (_) => _buildSkeletonCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    final cs = Theme.of(context).colorScheme;
    final skeletonColor = cs.surfaceContainerHighest;

    return SizedBox(
      width: 300.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),

          Padding(
            padding: context.edgeInsets(top: 14, bottom: 6),
            child: Container(width: 160.w, height: 20.h, color: skeletonColor),
          ),

          Container(width: 120.w, height: 14.h, color: skeletonColor),

          Padding(
            padding: context.edgeInsets(top: 10),
            child: Row(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: context.edgeInsets(right: 8),
                  child: Container(
                    width: 50.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
