import 'package:portfolio/presentation/blocs/skills/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/heading.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

class MobileSkillsPage extends StatefulWidget {
  const MobileSkillsPage({super.key});

  @override
  State<MobileSkillsPage> createState() => _MobileSkillsPageState();
}

class _MobileSkillsPageState extends State<MobileSkillsPage> {
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
            _buildAnalyticsGrid(state.analytics),

            Padding(
              padding: context.edgeInsets(vertical: 40),
              child: FadeSlide(
                child: const MobileHeadingText(text: 'Technical Expertise'),
              ),
            ),

            Padding(
              padding: context.edgeInsets(bottom: 48),
              child: _buildTechList(state.technicalSkills),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsGrid(List<SkillAnalyticEntity> analytics) {
    final pairs = <List<SkillAnalyticEntity>>[];
    for (var i = 0; i < analytics.length; i += 2) {
      pairs.add(analytics.sublist(i, (i + 2).clamp(0, analytics.length)));
    }

    return Column(
      children: pairs.asMap().entries.map((rowEntry) {
        final rowIdx = rowEntry.key;
        final items = rowEntry.value;

        return Padding(
          padding: rowIdx > 0 ? context.edgeInsets(top: 12) : EdgeInsets.zero,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...items.asMap().entries.expand((colEntry) {
                  final globalIdx = rowIdx * 2 + colEntry.key;
                  return [
                    Expanded(
                      child: ScaleFade(
                        delay: Duration(milliseconds: 80 + globalIdx * 120),
                        child: HoverCard(
                          child: _buildAnalyticCard(colEntry.value, globalIdx),
                        ),
                      ),
                    ),
                    if (colEntry.key == 0) SizedBox(width: 12.w),
                  ];
                }),

                if (items.length == 1) ...[
                  SizedBox(width: 12.w),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnalyticCard(SkillAnalyticEntity a, int idx) {
    final cs = Theme.of(context).colorScheme;
    final numStr = a.title.replaceAll(RegExp(r'[^0-9]'), '');
    final numVal = int.tryParse(numStr);
    final suffix = a.title.replaceAll(RegExp(r'[0-9]'), '');

    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: const BorderSide(color: Colors.transparent),
      ),
      child: Padding(
        padding: context.edgeInsets(vertical: 20, horizontal: 12),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CImage(path: a.icon, size: 22.r, color: cs.primary),
              Padding(
                padding: context.edgeInsets(vertical: 8),
                child: numVal != null
                    ? AnimatedCounter(
                        target: numVal,
                        suffix: suffix,
                        delay: Duration(milliseconds: 280 + idx * 90),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )
                    : Text(
                        a.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
              ),
              Text(
                a.subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 10.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechList(List<TechnicalSkillEntity> skills) {
    if (skills.isEmpty) return const SizedBox.shrink();

    return Column(
      children: skills.asMap().entries.map((e) {
        return Padding(
          padding: e.key > 0 ? context.edgeInsets(top: 16) : EdgeInsets.zero,
          child: ScaleFade(
            delay: Duration(milliseconds: 100 + e.key * 100),
            child: HoverCard(child: _buildTechCard(e.value)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTechCard(TechnicalSkillEntity skill) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: const BorderSide(color: Colors.transparent),
      ),
      child: Padding(
        padding: context.edgeInsets(all: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CImage(path: skill.icon, size: 22.r, color: cs.primary),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    skill.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

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
                    padding: context.edgeInsets(horizontal: 9, vertical: 4),
                    child: Text(
                      s,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontSize: 10.sp),
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
    final skeletonColor = cs.surfaceContainerHighest;

    return Shimmer.fromColors(
      baseColor: cs.surfaceContainerHighest,
      highlightColor: cs.surfaceContainerLow,
      child: Column(
        children: [
          ...List.generate(2, (row) {
            return Padding(
              padding: EdgeInsets.only(bottom: row < 1 ? 12.h : 0),
              child: Row(
                children: List.generate(2, (col) {
                  return Expanded(
                    child: Container(
                      height: 120.h,
                      margin: EdgeInsets.only(right: col < 1 ? 12.w : 0),
                      decoration: BoxDecoration(
                        color: skeletonColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),

          SizedBox(height: 40.h),

          Container(
            width: 200.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),

          SizedBox(height: 32.h),

          ...List.generate(4, (i) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Container(
                height: 130.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
