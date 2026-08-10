import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';
import 'package:portfolio/presentation/widgets/grid_backdrop.dart';
import 'package:portfolio/presentation/widgets/outlined_text.dart';
import 'package:portfolio/presentation/widgets/portfolio_image.dart';
import 'package:portfolio/presentation/widgets/typewriter_text.dart';

class TabletHeroSection extends StatelessWidget {
  const TabletHeroSection({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final wide = viewport.width >= 860;
    final minimumHeight = math.max(viewport.height, wide ? 720.0 : 920.0);

    return ColoredBox(
      color: AppColors.background,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minimumHeight),
        child: Stack(
          children: [
            const Positioned.fill(
              child: GridBackdrop(spacing: 52, opacity: .28),
            ),
            Positioned(
              right: -160,
              top: 90,
              child: Container(
                width: 430,
                height: 430,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: .09),
                      AppColors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppLayout.tabletContentMaxWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppLayout.tabletHorizontalPadding(viewport.width),
                    AppLayout.tabletNavigationHeight + 62,
                    AppLayout.tabletHorizontalPadding(viewport.width),
                    68,
                  ),
                  child: wide
                      ? Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: _HeroCopy(content: content, wide: true),
                            ),
                            const SizedBox(width: 44),
                            Expanded(
                              flex: 5,
                              child: _HeroPortrait(content: content),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroCopy(content: content, wide: false),
                            const SizedBox(height: 48),
                            Center(child: _HeroPortrait(content: content)),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.content, required this.wide});

  final PortfolioDataState content;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final profile = content.profile;
    final nameSize = wide ? 60.0 : 52.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: .1),
            border: Border.all(color: AppColors.accent.withValues(alpha: .35)),
            borderRadius: BorderRadius.circular(AppLayout.radius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              profile.title.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          profile.firstName.toUpperCase(),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: nameSize,
            height: .88,
            letterSpacing: -2.6,
          ),
        ),
        OutlinedText(
          profile.lastName.toUpperCase(),
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: nameSize,
            height: .92,
            letterSpacing: -2.6,
          ),
          strokeWidth: 1.4,
        ),
        const SizedBox(height: 22),
        const SizedBox(
          height: 24,
          child: TypewriterText(prefix: 'I build', fontSize: 12),
        ),
        const SizedBox(height: 16),
        Text(
          profile.subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: 15, height: 1.65),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton(
              label: 'View projects',
              compact: true,
              onPressed: () => context
                  .read<PortfolioNavigationCubit>()
                  .navigateTo(PortfolioSection.projects),
            ),
            AppButton(
              label: 'Let’s talk',
              compact: true,
              variant: AppButtonVariant.outline,
              onPressed: () => context
                  .read<PortfolioNavigationCubit>()
                  .navigateTo(PortfolioSection.contact),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Text(
              'CONNECT',
              style: TextStyle(
                color: AppColors.textMuted,
                fontFamily: 'monospace',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(width: 12),
            Container(width: 28, height: 1, color: AppColors.borderStrong),
            const SizedBox(width: 10),
            for (final social in content.socials.take(4)) ...[
              AppIconButton(
                size: 40,
                tooltip: social.label,
                onPressed: () => context.read<ExternalLinkCubit>().open(
                  url: social.url,
                  label: social.label,
                  failureTemplate: '{label} could not be opened.',
                ),
                icon: AppIcon(social.iconName, size: 17),
              ),
              const SizedBox(width: 7),
            ],
          ],
        ),
      ],
    );
  }
}

class _HeroPortrait extends StatelessWidget {
  const _HeroPortrait({required this.content});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 310),
      child: AspectRatio(
        aspectRatio: .76,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 14,
              top: 14,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: .52),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              right: 14,
              bottom: 14,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.borderStrong),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x99000000),
                      blurRadius: 32,
                      offset: Offset(0, 16),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PortfolioImage(
                      source: content.profile.portraitAsset,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      semanticLabel: content.profile.fullName,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xD9080808)],
                          stops: [.58, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 18,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x8822C55E),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 9),
                          const Expanded(
                            child: Text(
                              'AVAILABLE FOR SELECT PROJECTS',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontFamily: 'monospace',
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: .8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -12,
              top: 28,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  border: Border.all(color: AppColors.accentBright),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  child: Text(
                    'FLUTTER  •  DART',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'monospace',
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
