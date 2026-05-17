import 'package:portfolio/presentation/blocs/skills/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/heading.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

class TabletSkillsPage extends StatefulWidget {
  const TabletSkillsPage({super.key});

  @override
  State<TabletSkillsPage> createState() => _TabletSkillsPageState();
}

class _TabletSkillsPageState extends State<TabletSkillsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SkillsBloc>().add(const SkillsStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkillsBloc, SkillsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildShimmerLoading();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnalyticsRow(state.analytics),
            Padding(
              padding: context.edgeInsets(vertical: 64),
              child: FadeSlide(
                child: const TabletHeadingText(text: 'Technical Expertise'),
              ),
            ),
            Padding(
              padding: context.edgeInsets(bottom: 64),
              child: _buildTechGrid(state.technicalSkills),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsRow(List<SkillAnalyticEntity> analytics) {
    return IntrinsicHeight(
      child: Row(
        spacing: 16.w,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: analytics.asMap().entries.expand((e) {
          return [
            Expanded(
              child: ScaleFade(
                delay: Duration(milliseconds: 80 + e.key * 140),
                child: HoverCard(child: _buildAnalyticCard(e.value, e.key)),
              ),
            ),
          ];
        }).toList(),
      ),
    );
  }

  Widget _buildAnalyticCard(SkillAnalyticEntity a, int idx) {
    final cs = Theme.of(context).colorScheme;
    final numStr = a.title.replaceAll(RegExp(r'[^0-9]'), '');
    final numVal = int.tryParse(numStr);
    final suffix = a.title.replaceAll(RegExp(r'[0-9]'), '');

    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: Colors.transparent),
      ),
      child: Padding(
        padding: context.edgeInsets(vertical: 24, horizontal: 16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CImage(path: a.icon, size: 26.r, color: cs.primary),
              Padding(
                padding: context.edgeInsets(vertical: 10),
                child: numVal != null
                    ? AnimatedCounter(
                        target: numVal,
                        suffix: suffix,
                        delay: Duration(milliseconds: 300 + idx * 100),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        a.title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
              ),
              Text(
                a.subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechGrid(List<TechnicalSkillEntity> skills) {
    if (skills.isEmpty) return const SizedBox.shrink();

    const colCount = 2;
    final rows = <List<TechnicalSkillEntity>>[];
    for (var i = 0; i < skills.length; i += colCount) {
      rows.add(skills.sublist(i, (i + colCount).clamp(0, skills.length)));
    }

    return Column(
      children: rows.asMap().entries.map((rowEntry) {
        final rowIdx = rowEntry.key;
        final items = rowEntry.value;
        return Padding(
          padding: rowIdx > 0 ? context.edgeInsets(top: 24) : EdgeInsets.zero,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (items.length < colCount) const Spacer(),
                ...items.asMap().entries.expand((colEntry) {
                  final colIdx = colEntry.key;
                  final globalIdx = rowIdx * colCount + colIdx;
                  return [
                    Expanded(
                      child: ScaleFade(
                        delay: Duration(milliseconds: 120 + globalIdx * 110),
                        child: HoverCard(child: _buildTechCard(colEntry.value)),
                      ),
                    ),
                    if (colIdx < items.length - 1) SizedBox(width: 24.w),
                  ];
                }),
                if (items.length < colCount) const Spacer(),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTechCard(TechnicalSkillEntity skill) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: Colors.transparent),
      ),
      child: Padding(
        padding: context.edgeInsets(all: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CImage(path: skill.icon, size: 26.r, color: cs.primary),
            Padding(
              padding: context.edgeInsets(vertical: 12),
              child: Text(
                skill.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skill.skills.map((s) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: BoxBorder.all(color: cs.primary),
                  ),
                  child: Padding(
                    padding: context.edgeInsets(horizontal: 10, vertical: 5),
                    child: Text(
                      s,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    final cs = Theme.of(context).colorScheme;
    final baseColor = cs.surfaceContainerHighest;
    final highlightColor = cs.surfaceContainerLow;
    final skeletonColor = cs.surfaceContainerHighest;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: [
          Wrap(
            spacing: 16.w,
            runSpacing: 16.h,
            children: List.generate(
              4,
              (index) => Container(
                width: (1.sw / 2) - 32.w,
                height: 150,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),

          SizedBox(height: 64.h),

          Container(
            width: 220.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),

          SizedBox(height: 56.h),

          ...List.generate(
            3,
            (row) => Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Row(
                children: List.generate(
                  2,
                  (col) => Expanded(
                    child: Container(
                      height: 200,
                      margin: EdgeInsets.only(right: col < 1 ? 24.w : 0),
                      decoration: BoxDecoration(
                        color: skeletonColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
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
