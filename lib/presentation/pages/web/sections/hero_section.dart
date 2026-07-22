import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/shared/widgets/portfolio_image.dart';
import 'package:portfolio/presentation/pages/web/widgets/grid_backdrop.dart';
import 'package:portfolio/presentation/pages/web/widgets/outlined_text.dart';
import 'package:portfolio/presentation/pages/web/widgets/typewriter_text.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({required this.content, super.key});

  final PortfolioContent content;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final compact = viewport.width < AppLayout.compactDesktop;
    final height = math.max(viewport.height, compact ? 760.0 : 820.0);
    return SizedBox(
      height: height,
      child: ColoredBox(
        color: AppColors.background,
        child: Stack(
          children: [
            const Positioned.fill(child: GridBackdrop()),
            const Positioned(
              left: -120,
              top: 70,
              child: _AmbientGlow(size: 430, opacity: .11),
            ),
            const Positioned(
              right: -100,
              bottom: 20,
              child: _AmbientGlow(size: 390, opacity: .06),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppLayout.contentMaxWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppLayout.horizontalPadding(viewport.width),
                    AppLayout.navigationHeight + 28,
                    AppLayout.horizontalPadding(viewport.width),
                    56,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: _HeroCopy(content: content, compact: compact),
                      ),
                      SizedBox(width: compact ? 30 : 64),
                      Expanded(
                        flex: 5,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: _HeroPortrait(
                            content: content,
                            compact: compact,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 18,
              left: 0,
              right: 0,
              child: Center(
                child: _ScrollCue(
                  label: 'Scroll down',
                  onPressed: () => context
                      .read<PortfolioNavigationCubit>()
                      .navigateTo(PortfolioSection.about),
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
  const _HeroCopy({required this.content, required this.compact});

  final PortfolioContent content;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final profile = content.profile;
    final width = MediaQuery.sizeOf(context).width;
    final heroStyle = Theme.of(context).textTheme.displayLarge!.copyWith(
      fontSize: AppTypography.heroSize(width),
      height: .84,
      letterSpacing: compact ? -2.4 : -3.8,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: .1),
            border: Border.all(color: AppColors.accent.withValues(alpha: .28)),
            borderRadius: BorderRadius.circular(AppLayout.radius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Text(
              profile.title.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.4,
              ),
            ),
          ),
        ),
        SizedBox(height: compact ? 24 : 30),
        Text(profile.firstName.toUpperCase(), style: heroStyle),
        OutlinedText(profile.lastName.toUpperCase(), style: heroStyle),
        const SizedBox(height: 25),
        SizedBox(height: 28, child: TypewriterText(prefix: 'Specializing in')),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            profile.subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontSize: compact ? 15 : 17),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              label: 'View my work',
              onPressed: () => context
                  .read<PortfolioNavigationCubit>()
                  .navigateTo(PortfolioSection.projects),
            ),
            const SizedBox(width: 14),
            AppButton(
              label: 'Contact me',
              variant: AppButtonVariant.outline,
              onPressed: () => context
                  .read<PortfolioNavigationCubit>()
                  .navigateTo(PortfolioSection.contact),
            ),
          ],
        ),
        SizedBox(height: compact ? 28 : 38),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CONNECT',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.7,
              ),
            ),
            const SizedBox(width: 14),
            Container(width: 38, height: 1, color: AppColors.borderStrong),
            const SizedBox(width: 14),
            for (final social in content.socials) ...[
              AppIconButton(
                tooltip: social.label,
                onPressed: () => context.read<ExternalLinkCubit>().open(
                  url: social.url,
                  label: social.label,
                  failureTemplate: '{label} could not be opened.',
                ),
                icon: AppIcon(social.iconName, size: 19),
              ),
              if (social != content.socials.last) const SizedBox(width: 9),
            ],
          ],
        ),
      ],
    );
  }
}

class _HeroPortrait extends StatefulWidget {
  const _HeroPortrait({required this.content, required this.compact});

  final PortfolioContent content;
  final bool compact;

  @override
  State<_HeroPortrait> createState() => _HeroPortraitState();
}

class _HeroPortraitState extends State<_HeroPortrait> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final width = widget.compact ? 270.0 : 350.0;
    final height = widget.compact ? 365.0 : 455.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: SizedBox(
        width: width + 28,
        height: height + 28,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -52,
              top: -52,
              width: width + 132,
              height: height + 132,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: .72,
                    colors: [
                      AppColors.accent.withValues(alpha: _hovered ? .12 : .09),
                      AppColors.accent.withValues(alpha: _hovered ? .05 : .03),
                      AppColors.transparent,
                    ],
                    stops: const [0, .48, 1],
                  ),
                  borderRadius: BorderRadius.circular(80),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(
                        alpha: _hovered ? .09 : .06,
                      ),
                      blurRadius: _hovered ? 48 : 40,
                      spreadRadius: _hovered ? 4 : 2,
                    ),
                    BoxShadow(
                      color: AppColors.accent.withValues(
                        alpha: _hovered ? .07 : .04,
                      ),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 14,
              width: width,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: .42),
                  ),
                  borderRadius: BorderRadius.circular(AppLayout.radius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppLayout.radius),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedScale(
                          scale: _hovered ? 1.045 : 1,
                          duration: const Duration(milliseconds: 650),
                          curve: Curves.easeOutCubic,
                          child: Semantics(
                            image: true,
                            label: 'Portrait of Muhammad Tayyab',
                            child: PortfolioImage(
                              source: widget.content.profile.portraitAsset,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0x16000000),
                                Color(0xC8080808),
                              ],
                              stops: [0, .64, 1],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(right: 0, top: 0, child: _Corner(top: true)),
            const Positioned(left: 0, bottom: 0, child: _Corner(top: false)),
          ],
        ),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.accent.withValues(alpha: opacity),
            AppColors.transparent,
          ],
        ),
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  const _Corner({required this.top});

  final bool top;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: top
                ? const BorderSide(color: AppColors.accent, width: 2)
                : BorderSide.none,
            right: top
                ? const BorderSide(color: AppColors.accent, width: 2)
                : BorderSide.none,
            bottom: !top
                ? const BorderSide(color: AppColors.accent, width: 2)
                : BorderSide.none,
            left: !top
                ? const BorderSide(color: AppColors.accent, width: 2)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _ScrollCue extends StatefulWidget {
  const _ScrollCue({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  State<_ScrollCue> createState() => _ScrollCueState();
}

class _ScrollCueState extends State<_ScrollCue>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
    _offset = Tween<double>(
      begin: 0,
      end: 5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textMuted,
        minimumSize: const Size(80, 48),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          AnimatedBuilder(
            animation: _offset,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _offset.value),
              child: child,
            ),
            child: const AppIcon(
              'arrowDown',
              size: 18,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
