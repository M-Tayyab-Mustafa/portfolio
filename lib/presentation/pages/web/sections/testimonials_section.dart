import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/core/animations/reveal_on_scroll.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';
import 'package:portfolio/shared/widgets/app_button.dart';
import 'package:portfolio/shared/widgets/app_icon.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_container.dart';
import 'package:portfolio/presentation/pages/web/widgets/section_header.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({required this.content, super.key});

  final PortfolioContent content;

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  int _currentIndex = 0;
  int _direction = 1;

  @override
  void didUpdateWidget(covariant TestimonialsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_currentIndex >= widget.content.testimonials.length) {
      _currentIndex = 0;
    }
  }

  void _move(int direction) {
    final count = widget.content.testimonials.length;
    if (count < 2) return;
    setState(() {
      _direction = direction;
      _currentIndex = (_currentIndex + direction) % count;
      if (_currentIndex < 0) _currentIndex = count - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;
    final testimonials = content.testimonials;
    final heading = content.heading('testimonials');
    return SectionContainer(
      ambientOpacity: .065,
      child: Column(
        children: [
          RevealOnScroll(
            child: SectionHeader(
              eyebrow: heading.eyebrow,
              title: heading.title,
              accentTitle: heading.accentTitle,
            ),
          ),
          const SizedBox(height: 58),
          RevealOnScroll(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1024),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final gutter = constraints.maxWidth >= 1000 ? 64.0 : 52.0;
                  return Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: gutter),
                        child: testimonials.isEmpty
                            ? const _EmptyTestimonials()
                            : AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(.035 * _direction, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: _TestimonialCard(
                                  key: ValueKey(
                                    '${testimonials[_currentIndex].name}-$_currentIndex',
                                  ),
                                  testimonial: testimonials[_currentIndex],
                                ),
                              ),
                      ),
                      if (testimonials.isNotEmpty) ...[
                        Positioned(
                          left: 0,
                          child: AppIconButton(
                            size: 48,
                            icon: const AppIcon('arrowLeft'),
                            tooltip: 'Previous testimonial',
                            onPressed: testimonials.length > 1
                                ? () => _move(-1)
                                : null,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: AppIconButton(
                            size: 48,
                            icon: const AppIcon('arrowRight'),
                            tooltip: 'Next testimonial',
                            onPressed: testimonials.length > 1
                                ? () => _move(1)
                                : null,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
          if (testimonials.length > 1) ...[
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final entry in testimonials.indexed)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => setState(() {
                        _direction = entry.$1 >= _currentIndex ? 1 : -1;
                        _currentIndex = entry.$1;
                      }),
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        width: entry.$1 == _currentIndex ? 32 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: entry.$1 == _currentIndex
                              ? AppColors.accent
                              : AppColors.borderStrong,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 48),
          _SubmitFeedbackButton(
            onPressed: () =>
                context.push(PortfolioRoute.testimonialSubmissionPath),
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({required this.testimonial, super.key});

  final TestimonialItem testimonial;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      padding: const EdgeInsets.all(42),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: -8,
            child: Opacity(
              opacity: .1,
              child: const AppIcon('quote', size: 68, color: AppColors.accent),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (var index = 0; index < 5; index++)
                    Icon(
                      index < testimonial.rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: AppColors.accent,
                      size: 19,
                    ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                '“${testimonial.content}”',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.accent,
                    child: Text(
                      testimonial.avatar,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        testimonial.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          text: '${testimonial.role} at ',
                          children: [
                            TextSpan(
                              text: testimonial.company,
                              style: const TextStyle(color: AppColors.accent),
                            ),
                          ],
                        ),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyTestimonials extends StatelessWidget {
  const _EmptyTestimonials();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(46),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const AppIcon('quote', size: 42, color: AppColors.accent),
          const SizedBox(height: 20),
          Text(
            'Your experience could be featured here',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'Published client feedback will appear here after review.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _SubmitFeedbackButton extends StatefulWidget {
  const _SubmitFeedbackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_SubmitFeedbackButton> createState() => _SubmitFeedbackButtonState();
}

class _SubmitFeedbackButtonState extends State<_SubmitFeedbackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accent : AppColors.surface,
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✨', style: TextStyle(fontSize: 15, height: 1)),
                  const SizedBox(width: 10),
                  const Text(
                    'SUBMIT YOUR FEEDBACK',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
