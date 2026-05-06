import 'package:portfolio/presentation/blocs/projects/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/heading.dart';
import 'package:portfolio/presentation/widgets/project_card.dart';
import 'package:portfolio/utils/exports.dart';

class AllProjectsPage extends StatefulWidget {
  const AllProjectsPage({super.key});

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectsBloc>().add(const FetchAllProjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  BlocBuilder<ProjectsBloc, ProjectsState> _buildBody() {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        if (state.isLoadingAll) {
          return _buildShimmerSkeleton(); // ✨ Shimmer loading state ✨
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: SingleChildScrollView(
              padding: context.edgeInsets(horizontal: 30, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeSlide(child: const HeadingText(text: 'All Projects')),
                  SizedBox(height: 60.h),
                  Wrap(
                    spacing: 32.w,
                    runSpacing: 32.h,
                    children: state.allProjects
                        .asMap()
                        .entries
                        .map(
                          (e) => ScaleFade(
                            delay: Duration(milliseconds: 80 + e.key * 100),
                            child: HoverCard(
                              child: ProjectCard(project: e.value),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Shimmer skeleton that mimics the all projects layout
  Widget _buildShimmerSkeleton() {
    final cs = Theme.of(context).colorScheme;
    const placeholderCount = 6; // Show 6 placeholder cards (typical grid)

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1440),
        child: SingleChildScrollView(
          padding: context.edgeInsets(horizontal: 30, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading placeholder
              Container(
                width: 200.w,
                height: 36.h,
                color: cs.surfaceContainerHighest,
              ),
              SizedBox(height: 60.h),
              Shimmer.fromColors(
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
            ],
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
