import 'package:portfolio/presentation/blocs/projects/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/heading.dart';
import 'package:portfolio/presentation/widgets/project_card.dart';
import 'package:portfolio/utils/exports.dart';

class WebProjectsPage extends StatefulWidget {
  const WebProjectsPage({super.key});

  @override
  State<WebProjectsPage> createState() => _WebProjectsPageState();
}

class _WebProjectsPageState extends State<WebProjectsPage> {
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
                padding: context.edgeInsets(top: 40, bottom: 20),
                child: FadeSlide(
                  child: HeadingText(
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
                  padding: context.edgeInsets(top: 80, bottom: 100),
                  child: Wrap(
                    spacing: 32.w,
                    runSpacing: 32.h,
                    children: state.featuredProjects
                        .asMap()
                        .entries
                        .map(
                          (e) => ScaleFade(
                            delay: Duration(milliseconds: 150 + e.key * 180),
                            child: HoverCard(
                              child: ProjectCard(project: e.value),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Shimmer skeleton that mimics the featured projects layout
  Widget _buildShimmerSkeleton() {
    final cs = Theme.of(context).colorScheme;
    const placeholderCount = 3; // Show 3 placeholder cards

    return Padding(
      padding: context.edgeInsets(vertical: 80),
      child: Shimmer.fromColors(
        baseColor: cs.surfaceContainerHighest,
        highlightColor: cs.surfaceContainerLow,
        child: Wrap(
          spacing: 32.w,
          runSpacing: 32.h,
          children: List.generate(
            placeholderCount,
            (_) => _buildSkeletonCard(),
          ),
        ),
      ),
    );
  }

  /// Placeholder project card mimicking the real ProjectCard layout
  Widget _buildSkeletonCard() {
    final cs = Theme.of(context).colorScheme;
    final skeletonColor = cs.surfaceContainerHighest;

    return SizedBox(
      width: 380.w, // Adjust based on your actual ProjectCard width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 220.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),

          Padding(
            padding: context.edgeInsets(top: 16, bottom: 8),
            child: Container(width: 200.w, height: 24.h, color: skeletonColor),
          ),

          Container(width: 140.w, height: 16.h, color: skeletonColor),

          Padding(
            padding: context.edgeInsets(top: 12),
            child: Row(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: context.edgeInsets(right: 8),
                  child: Container(
                    width: 60.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: skeletonColor,
                      borderRadius: BorderRadius.circular(12.r),
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
