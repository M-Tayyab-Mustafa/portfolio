import 'package:portfolio/presentation/blocs/experience/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/heading.dart';
import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

class TabletExperiencePage extends StatefulWidget {
  const TabletExperiencePage({super.key});

  @override
  State<TabletExperiencePage> createState() => _TabletExperiencePageState();
}

class _TabletExperiencePageState extends State<TabletExperiencePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lineCtrl;
  late final Animation<double> _lineProgress;

  @override
  void initState() {
    super.initState();
    context.read<ExperienceBloc>().add(const ExperienceStarted());
    _lineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _lineProgress = CurvedAnimation(parent: _lineCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _lineCtrl.dispose();
    super.dispose();
  }

  void _onTimelineVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= 0.05) {
      if (_lineCtrl.status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(milliseconds: 220), () {
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
              padding: context.edgeInsets(top: 48),
              child: FadeSlide(
                child: const TabletHeadingText(text: 'Experience'),
              ),
            ),
            if (state.isLoading)
              _buildShimmerSkeleton()
            else
              Padding(
                padding: context.edgeInsets(top: 40, bottom: 60),
                child: VisibilityDetector(
                  key: const Key('experience_timeline_tablet'),
                  onVisibilityChanged: _onTimelineVisibilityChanged,
                  child: Stack(
                    children: [
                      // Growing timeline line – centred vertically on tablet
                      Positioned.fill(
                        child: Center(
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
                                            .withAlpha(60),
                                      ],
                                    ),
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
                                invert: e.key.isOdd,
                                delay: Duration(
                                  milliseconds: 200 + e.key * 220,
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
    const skeletonCardsCount = 2;
    final skeletonColor = cs.surfaceContainerHighest;

    return Padding(
      padding: context.edgeInsets(top: 40, bottom: 60),
      child: Shimmer.fromColors(
        baseColor: cs.surfaceContainerHighest,
        highlightColor: cs.surfaceContainerLow,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Container(width: 2, color: cs.outlineVariant),
              ),
            ),
            Column(
              children: List.generate(skeletonCardsCount, (index) {
                final invert = index.isOdd;
                return Padding(
                  padding: context.edgeInsets(vertical: 28),
                  child: Row(
                    children: invert
                        ? [
                            _buildSkeletonCard(skeletonColor),
                            _buildSkeletonDot(skeletonColor),
                            _buildSkeletonInfoPanel(skeletonColor),
                          ]
                        : [
                            _buildSkeletonInfoPanel(skeletonColor),
                            _buildSkeletonDot(skeletonColor),
                            _buildSkeletonCard(skeletonColor),
                          ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonInfoPanel(Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 80.w, height: 14.h, color: color),
          Padding(
            padding: context.edgeInsets(top: 12, bottom: 8),
            child: Container(width: 140.w, height: 22.h, color: color),
          ),
          Container(width: 100.w, height: 12.h, color: color),
        ],
      ),
    );
  }

  Widget _buildSkeletonDot(Color color) {
    return Padding(
      // Tablet: tighter horizontal gap around the dot
      padding: context.edgeInsets(horizontal: 32),
      child: Container(
        width: 12.r,
        height: 12.r,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }

  Widget _buildSkeletonCard(Color color) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: color,
        ),
        child: Padding(
          padding: context.edgeInsets(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              4,
              (_) => Padding(
                padding: context.edgeInsets(bottom: 8),
                child: Container(
                  width: double.infinity,
                  height: 12.h,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required ExperienceEntity exp,
    required bool invert,
    required Duration delay,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final infoPanel = Expanded(
      child: FadeSlide(
        delay: delay,
        beginOffset: Offset(invert ? -40 : 40, 0),
        child: Column(
          crossAxisAlignment: invert
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(
              exp.date,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            Padding(
              padding: context.edgeInsets(top: 12, bottom: 8),
              child: Text(
                exp.title,
                textAlign: invert ? TextAlign.start : TextAlign.end,
                // Tablet: step down from headlineMedium → titleLarge
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              exp.subTitle,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );

    final dot = Padding(
      // Tablet: reduced horizontal margin around dot
      padding: context.edgeInsets(horizontal: 32),
      child: ScaleFade(
        delay: Duration(milliseconds: delay.inMilliseconds + 80),
        child: PulsingDot(size: 12.r, color: cs.primary),
      ),
    );

    final descPanel = Expanded(
      child: FadeSlide(
        delay: Duration(milliseconds: delay.inMilliseconds + 160),
        beginOffset: Offset(invert ? 40 : -40, 0),
        child: HoverCard(
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Padding(
              padding: context.edgeInsets(horizontal: 16, vertical: 24),
              child: Text(exp.description, style: theme.textTheme.bodySmall),
            ),
          ),
        ),
      ),
    );

    return Padding(
      // Tablet: tighter vertical padding between cards
      padding: context.edgeInsets(vertical: 28),
      child: Row(
        children: invert
            ? [descPanel, dot, infoPanel]
            : [infoPanel, dot, descPanel],
      ),
    );
  }
}
