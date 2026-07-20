import 'package:flutter/material.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/hover_surface.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_container.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_header.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({required this.content, super.key});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < AppLayout.compactDesktop;
    return SectionContainer(
      ambientAlignment: Alignment.topLeft,
      child: Column(
        children: [
          RevealOnScroll(
            child: SectionHeader(
              eyebrow: content.heading('skills').eyebrow,
              title: content.heading('skills').title,
              accentTitle: content.heading('skills').accentTitle,
            ),
          ),
          SizedBox(height: compact ? 58 : 76),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 1100 ? 2 : 4;
              final gap = compact ? 15.0 : 22.0;
              final cardWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final entry in content.skillGroups.indexed)
                    SizedBox(
                      width: cardWidth,
                      child: RevealOnScroll(
                        delay: Duration(milliseconds: entry.$1 * 70),
                        child: _SkillGroupCard(group: entry.$2),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 54),
          RevealOnScroll(
            child: Text(
              'CONTINUOUS LEARNING  •  INDUSTRY STANDARD ARCHITECTURES  •  ABSOLUTE VISUAL OPTIMIZATION',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted,
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillGroupCard extends StatelessWidget {
  const _SkillGroupCard({required this.group});

  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    return HoverSurface(
      lift: false,
      padding: const EdgeInsets.all(24),
      builder: (context, hovered) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                width: hovered ? 8 : 5,
                height: 28,
                color: AppColors.accent,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  group.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 18),
          for (final skill in group.skills) ...[
            _SkillTile(skill: skill),
            if (skill != group.skills.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _SkillTile extends StatefulWidget {
  const _SkillTile({required this.skill});

  final SkillItem skill;

  @override
  State<_SkillTile> createState() => _SkillTileState();
}

class _SkillTileState extends State<_SkillTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.accent.withValues(alpha: .055)
              : AppColors.background.withValues(alpha: .55),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: .35)
                : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(AppLayout.radius),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(
                  color: _hovered
                      ? AppColors.accent.withValues(alpha: .3)
                      : AppColors.border,
                ),
              ),
              child: Center(
                child: AppIcon(
                  widget.skill.iconName,
                  size: 19,
                  color: _hovered ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.skill.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovered ? AppColors.accent : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
