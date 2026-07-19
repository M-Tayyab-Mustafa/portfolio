import 'package:flutter/material.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_container.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_header.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({required this.content, super.key});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < AppLayout.compactDesktop;
    final practice = content.experiences
        .where((item) => item.kind == ExperienceKind.practice)
        .toList(growable: false);
    final milestones = content.experiences
        .where((item) => item.kind == ExperienceKind.milestone)
        .toList(growable: false);

    return SectionContainer(
      background: AppColors.surface,
      ambientAlignment: Alignment.bottomLeft,
      ambientOpacity: .055,
      child: Column(
        children: [
          RevealOnScroll(
            child: SectionHeader(
              eyebrow: content.heading('experience').eyebrow,
              title: content.heading('experience').title,
              accentTitle: content.heading('experience').accentTitle,
            ),
          ),
          SizedBox(height: compact ? 66 : 84),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TimelineColumn(
                  title: 'Work History',
                  iconName: 'briefcase',
                  items: practice,
                  slideFromLeft: true,
                ),
              ),
              SizedBox(width: compact ? 42 : 66),
              Expanded(
                child: _TimelineColumn(
                  title: 'Education',
                  iconName: 'milestone',
                  items: milestones,
                  slideFromLeft: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineColumn extends StatelessWidget {
  const _TimelineColumn({
    required this.title,
    required this.iconName,
    required this.items,
    required this.slideFromLeft,
  });

  final String title;
  final String iconName;
  final List<ExperienceItem> items;
  final bool slideFromLeft;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: .1),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: .3),
                ),
              ),
              child: Center(
                child: AppIcon(iconName, size: 21, color: AppColors.accent),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: AppColors.accent.withValues(alpha: .32)),
            ),
          ),
          padding: const EdgeInsets.only(left: 28),
          child: Column(
            children: [
              for (final entry in items.indexed) ...[
                RevealOnScroll(
                  delay: Duration(milliseconds: entry.$1 * 100),
                  offset: Offset(slideFromLeft ? -.06 : .06, 0),
                  child: _TimelineItem(item: entry.$2),
                ),
                if (entry.$1 != items.length - 1) const SizedBox(height: 44),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatefulWidget {
  const _TimelineItem({required this.item});

  final ExperienceItem item;

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -36,
            top: 4,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovered ? AppColors.accent : AppColors.background,
                border: Border.all(color: AppColors.accent, width: 2),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: .3),
                          blurRadius: 10,
                        ),
                      ]
                    : const [],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: .09),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: .26),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppIcon(
                        'calendar',
                        size: 13,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.period,
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 240),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 18,
                  color: _hovered ? AppColors.accent : AppColors.textPrimary,
                ),
                child: Text(item.title),
              ),
              const SizedBox(height: 6),
              Text(
                item.context,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
              ),
              const SizedBox(height: 13),
              for (final highlight in item.highlights)
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: SizedBox(
                          width: 5,
                          height: 5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          highlight,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
