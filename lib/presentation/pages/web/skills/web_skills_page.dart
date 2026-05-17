import 'package:portfolio/presentation/blocs/skills/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/heading.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

class WebSkillsPage extends StatefulWidget {
  const WebSkillsPage({super.key});

  @override
  State<WebSkillsPage> createState() => _WebSkillsPageState();
}

class _WebSkillsPageState extends State<WebSkillsPage> {
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
              padding: context.edgeInsets(vertical: 100),
              child: FadeSlide(
                child: const HeadingText(text: 'Technical Expertise'),
              ),
            ),
            Padding(
              padding: context.edgeInsets(bottom: 100),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: analytics.asMap().entries.expand((e) {
          return [
            Expanded(
              child: ScaleFade(
                delay: Duration(milliseconds: 80 + e.key * 140),
                child: HoverCard(child: _buildAnalyticCard(e.value, e.key)),
              ),
            ),
            if (e.key < analytics.length - 1) SizedBox(width: 24.w),
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
        side: const BorderSide(color: AppColors.transparent),
      ),
      child: Padding(
        padding: context.edgeInsets(vertical: 32, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CImage(path: a.icon, size: 30.r, color: cs.primary),
            Padding(
              padding: context.edgeInsets(vertical: 12),
              child: numVal != null
                  ? AnimatedCounter(
                      target: numVal,
                      suffix: suffix,
                      delay: Duration(milliseconds: 300 + idx * 100),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      a.title,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            Text(
              a.subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechGrid(List<TechnicalSkillEntity> skills) {
    if (skills.isEmpty) return const SizedBox.shrink();
    final rows = <List<TechnicalSkillEntity>>[];
    for (var i = 0; i < skills.length; i += 3) {
      rows.add(skills.sublist(i, (i + 3).clamp(0, skills.length)));
    }

    return Column(
      children: rows.asMap().entries.map((rowEntry) {
        final rowIdx = rowEntry.key;
        final items = rowEntry.value;
        return Padding(
          padding: rowIdx > 0 ? context.edgeInsets(top: 32) : EdgeInsets.zero,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (items.length < 3) const Spacer(),
                ...items.asMap().entries.expand((colEntry) {
                  final colIdx = colEntry.key;
                  final globalIdx = rowIdx * 3 + colIdx;
                  return [
                    Expanded(
                      child: ScaleFade(
                        delay: Duration(milliseconds: 120 + globalIdx * 110),
                        child: HoverCard(child: _buildTechCard(colEntry.value)),
                      ),
                    ),
                    if (colIdx < items.length - 1) SizedBox(width: 32.w),
                  ];
                }),
                if (items.length < 3) const Spacer(),
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
        side: const BorderSide(color: AppColors.transparent),
      ),
      child: Padding(
        padding: context.edgeInsets(all: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CImage(path: skill.icon, size: 30.r, color: cs.primary),
            Padding(
              padding: context.edgeInsets(vertical: 16),
              child: Text(
                skill.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
                    padding: context.edgeInsets(horizontal: 12, vertical: 6),
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
          // Analytics row
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  height: 180,
                  margin: EdgeInsets.only(right: index < 2 ? 24.w : 0),
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 100.h),

          // Heading
          Container(
            width: 250.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),

          SizedBox(height: 80.h),

          // Skills cards
          ...List.generate(
            2,
            (row) => Padding(
              padding: EdgeInsets.only(bottom: 32.h),
              child: Row(
                children: List.generate(
                  3,
                  (col) => Expanded(
                    child: Container(
                      height: 220,
                      margin: EdgeInsets.only(right: col < 2 ? 32.w : 0),
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
