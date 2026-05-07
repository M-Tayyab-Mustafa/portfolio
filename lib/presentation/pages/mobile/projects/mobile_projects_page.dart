import 'package:portfolio/presentation/blocs/projects/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/heading.dart';
import 'package:portfolio/presentation/widgets/project_card.dart';
import 'package:portfolio/utils/exports.dart';

class MobileProjectsPage extends StatefulWidget {
  const MobileProjectsPage({super.key});

  @override
  State<MobileProjectsPage> createState() => _MobileProjectsPageState();
}

class _MobileProjectsPageState extends State<MobileProjectsPage> {
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
              // ── Section heading ──────────────────────────────────────────
              Padding(
                padding: context.edgeInsets(top: 28, bottom: 8),
                child: FadeSlide(
                  child: MobileHeadingText(
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
                _buildProjectList(state.featuredProjects),
            ],
          ),
        );
      },
    );
  }

  // ── Content ────────────────────────────────────────────────────────────────
  Widget _buildProjectList(List projects) {
    // On mobile use a single-column ListView so cards are always full-width.
    return Padding(
      padding: context.edgeInsets(top: 24, bottom: 48),
      child: Column(
        children: projects
            .asMap()
            .entries
            .map(
              (e) => Padding(
                padding: context.edgeInsets(bottom: 20),
                child: ScaleFade(
                  delay: Duration(milliseconds: 120 + e.key * 140),
                  child: HoverCard(
                    child: ProjectCard(project: e.value),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── Shimmer ────────────────────────────────────────────────────────────────
  Widget _buildShimmerSkeleton() {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: context.edgeInsets(top: 24, bottom: 48),
      child: Shimmer.fromColors(
        baseColor: cs.surfaceContainerHighest,
        highlightColor: cs.surfaceContainerLow,
        child: Column(
          children: List.generate(
            3,
            (_) => Padding(
              padding: context.edgeInsets(bottom: 20),
              child: _buildSkeletonCard(cs.surfaceContainerHighest),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonCard(Color skeletonColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: skeletonColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),

        Padding(
          padding: context.edgeInsets(top: 12, bottom: 6),
          child: Container(width: 180.w, height: 20.h, color: skeletonColor),
        ),

        Container(width: 130.w, height: 13.h, color: skeletonColor),

        Padding(
          padding: context.edgeInsets(top: 10),
          child: Row(
            children: List.generate(
              3,
              (_) => Padding(
                padding: context.edgeInsets(right: 8),
                child: Container(
                  width: 54.w,
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
    );
  }
}
