import 'package:portfolio/presentation/blocs/experience/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/heading.dart';
import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

class MobileExperiencePage extends StatefulWidget {
  const MobileExperiencePage({super.key});

  @override
  State<MobileExperiencePage> createState() => _MobileExperiencePageState();
}

class _MobileExperiencePageState extends State<MobileExperiencePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lineCtrl;
  late final Animation<double> _lineProgress;

  @override
  void initState() {
    super.initState();
    context.read<ExperienceBloc>().add(const ExperienceStarted());
    _lineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _lineProgress = CurvedAnimation(parent: _lineCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _lineCtrl.dispose();
    super.dispose();
  }

  void _onTimelineVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= 0.04) {
      if (_lineCtrl.status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(milliseconds: 180), () {
          if (mounted) _lineCtrl.forward();
        });
      }
    } else if (info.visibleFraction == 0.0) {
      _lineCtrl.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExperienceBloc, ExperienceState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: context.edgeInsets(top: 36, bottom: 0),
              child: FadeSlide(
                child: const MobileHeadingText(text: 'Experience'),
              ),
            ),
            if (state.isLoading)
              _buildShimmerSkeleton()
            else
              Padding(
                padding: context.edgeInsets(top: 32, bottom: 48),
                child: VisibilityDetector(
                  key: const Key('experience_timeline_mobile'),
                  onVisibilityChanged: _onTimelineVisibilityChanged,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 20.w,
                        child: AnimatedBuilder(
                          animation: _lineProgress,
                          builder: (_, _) => Align(
                            alignment: Alignment.topCenter,
                            child: FractionallySizedBox(
                              heightFactor: _lineProgress.value,
                              child: Container(
                                width: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withAlpha(50),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Column(
                        children: state.experiences
                            .asMap()
                            .entries
                            .map(
                              (e) => _buildCard(
                                exp: e.value,
                                delay: Duration(
                                  milliseconds: 180 + e.key * 200,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerSkeleton() {
    final cs = Theme.of(context).colorScheme;
    final skeletonColor = cs.surfaceContainerHighest;

    return Padding(
      padding: context.edgeInsets(top: 32, bottom: 48),
      child: Shimmer.fromColors(
        baseColor: cs.surfaceContainerHighest,
        highlightColor: cs.surfaceContainerLow,
        child: Column(
          children: List.generate(3, (index) {
            return Padding(
              padding: context.edgeInsets(vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: context.edgeInsets(horizontal: 14, top: 4),
                    child: Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: skeletonColor,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70.w,
                          height: 12.h,
                          color: skeletonColor,
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 160.w,
                          height: 20.h,
                          color: skeletonColor,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 100.w,
                          height: 12.h,
                          color: skeletonColor,
                        ),
                        SizedBox(height: 14.h),

                        Container(
                          width: double.infinity,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: skeletonColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCard({required ExperienceEntity exp, required Duration delay}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: context.edgeInsets(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: context.edgeInsets(horizontal: 14, top: 3),
            child: ScaleFade(
              delay: Duration(milliseconds: delay.inMilliseconds + 60),
              child: PulsingDot(size: 12.r, color: cs.primary),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeSlide(
                  delay: delay,
                  beginOffset: const Offset(20, 0),
                  child: Text(
                    exp.date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),

                SizedBox(height: 6.h),

                FadeSlide(
                  delay: Duration(milliseconds: delay.inMilliseconds + 60),
                  beginOffset: const Offset(20, 0),
                  child: Text(
                    exp.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                FadeSlide(
                  delay: Duration(milliseconds: delay.inMilliseconds + 100),
                  beginOffset: const Offset(20, 0),
                  child: Text(
                    exp.subTitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: cs.primary,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                FadeSlide(
                  delay: Duration(milliseconds: delay.inMilliseconds + 160),
                  beginOffset: const Offset(0, 16),
                  child: HoverCard(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Padding(
                        padding: context.edgeInsets(
                          horizontal: 14,
                          vertical: 16,
                        ),
                        child: Text(
                          exp.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
