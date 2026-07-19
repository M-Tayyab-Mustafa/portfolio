import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/hover_surface.dart';
import 'package:portfolio/shared/widgets/portfolio_image.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_container.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({required this.content, super.key});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < AppLayout.compactDesktop;
    return SectionContainer(
      background: AppColors.surface,
      ambientAlignment: Alignment.centerRight,
      ambientOpacity: .055,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealOnScroll(
            child: SectionHeader(
              eyebrow: content.heading('about').eyebrow,
              title: content.heading('about').title,
              accentTitle: content.heading('about').accentTitle,
              centered: false,
            ),
          ),
          SizedBox(height: compact ? 60 : 76),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: RevealOnScroll(
                  offset: const Offset(-.08, 0),
                  child: _AboutPortrait(content: content, compact: compact),
                ),
              ),
              SizedBox(width: compact ? 48 : 78),
              Expanded(
                flex: 7,
                child: RevealOnScroll(
                  delay: const Duration(milliseconds: 100),
                  offset: const Offset(.06, 0),
                  child: _AboutCopy(content: content),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutCopy extends StatelessWidget {
  const _AboutCopy({required this.content});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    final profile = content.profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I combine engineering precision with elegant aesthetics.',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 18),
        Text(profile.aboutBrief, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        Text(profile.aboutLong, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 16) / 2;
            return Wrap(
              spacing: 16,
              runSpacing: 15,
              children: [
                for (final focus in profile.coreFocus)
                  SizedBox(
                    width: itemWidth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: AppIcon(
                            'check',
                            size: 17,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            focus,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 32),
        AppButton(
          label: 'Explore my GitHub',
          icon: const AppIcon(
            'external',
            size: 17,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.read<ExternalLinkCubit>().open(
            url: content.link(PortfolioLinkKey.github),
            label: 'GitHub',
            failureTemplate: '{label} could not be opened.',
          ),
        ),
        const SizedBox(height: 40),
        const Divider(height: 1),
        const SizedBox(height: 26),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final entry in content.stats.indexed) ...[
                Expanded(child: _StatCard(stat: entry.$2)),
                if (entry.$1 != content.stats.length - 1)
                  const SizedBox(width: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final StatItem stat;

  @override
  Widget build(BuildContext context) {
    return HoverSurface(
      lift: false,
      background: AppColors.background.withValues(alpha: .55),
      padding: const EdgeInsets.all(17),
      builder: (context, hovered) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stat.value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AppIcon(stat.iconName, size: 20, color: AppColors.accent),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stat.label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: .9,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutPortrait extends StatefulWidget {
  const _AboutPortrait({required this.content, required this.compact});

  final PortfolioContent content;
  final bool compact;

  @override
  State<_AboutPortrait> createState() => _AboutPortraitState();
}

class _AboutPortraitState extends State<_AboutPortrait> {
  bool _hovered = false;

  static const _grayscale = <double>[
    .2126,
    .7152,
    .0722,
    0,
    0,
    .2126,
    .7152,
    .0722,
    0,
    0,
    .2126,
    .7152,
    .0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  @override
  Widget build(BuildContext context) {
    final width = widget.compact ? 270.0 : 320.0;
    final height = widget.compact ? 350.0 : 410.0;
    return Center(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: SizedBox(
          width: width + 38,
          height: height + 50,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 28,
                top: 22,
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 4,
                width: width,
                height: height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppLayout.radius),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColorFiltered(
                        colorFilter: const ColorFilter.matrix(_grayscale),
                        child: PortfolioImage(
                          source: widget.content.profile.portraitAsset,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          semanticLabel: 'Portrait of Muhammad Tayyab',
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _hovered ? 1 : 0,
                        duration: const Duration(milliseconds: 620),
                        child: PortfolioImage(
                          source: widget.content.profile.portraitAsset,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          excludeFromSemantics: true,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        color: AppColors.accent.withValues(
                          alpha: _hovered ? 0 : .08,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: -4,
                bottom: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: .36),
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 18),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _AvailabilityDot(),
                        const SizedBox(width: 10),
                        Text(
                          'AVAILABLE FOR HIRE',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailabilityDot extends StatelessWidget {
  const _AvailabilityDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.success,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: .35),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
