import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

class BrandLoader extends StatefulWidget {
  const BrandLoader({super.key});

  @override
  State<BrandLoader> createState() => _BrandLoaderState();
}

class _BrandLoaderState extends State<BrandLoader>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _loopController;
  late final Animation<double> _entrance;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _entrance = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    return ColoredBox(
      color: AppColors.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _LoaderBackdrop(),
          Center(
            child: FadeTransition(
              opacity: _entrance,
              child: ScaleTransition(
                scale: Tween<double>(begin: .82, end: 1).animate(_entrance),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AnimatedBrandMark(
                      animation: _loopController,
                      reducedMotion: reducedMotion,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'MUHAMMAD',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 7,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'TAYYAB',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 5,
                      ),
                    ),
                    const SizedBox(height: 38),
                    _ProgressTrack(
                      animation: _loopController,
                      reducedMotion: reducedMotion,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'INITIALIZING DIGITAL CANVAS...',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontFamily: 'monospace',
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoaderBackdrop extends StatelessWidget {
  const _LoaderBackdrop();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _LoaderBackdropPainter());
  }
}

class _LoaderBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.drawCircle(
      center,
      size.shortestSide * .28,
      Paint()
        ..shader =
            const RadialGradient(
              colors: [Color(0x28E50914), Color(0x00080808)],
            ).createShader(
              Rect.fromCircle(center: center, radius: size.shortestSide * .3),
            ),
    );
    final gridPaint = Paint()
      ..color = const Color(0x0AFFFFFF)
      ..strokeWidth = 1;
    for (double x = 12; x < size.width; x += 24) {
      for (double y = 12; y < size.height; y += 24) {
        canvas.drawCircle(Offset(x, y), .7, gridPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AnimatedBrandMark extends StatelessWidget {
  const _AnimatedBrandMark({
    required this.animation,
    required this.reducedMotion,
  });

  final Animation<double> animation;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final phase = reducedMotion ? .5 : animation.value;
        final pulse = .5 + (.5 * (1 - (phase * 2 - 1).abs()));
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 128 + (22 * pulse),
              height: 128 + (22 * pulse),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(
                      alpha: .14 + (.1 * pulse),
                    ),
                    blurRadius: 56,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xE60C0C0C),
                border: Border.all(color: AppColors.borderStrong, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 12,
                    right: 12,
                    top: 12,
                    child: Container(
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.accent, Color(0x4DFFFFFF)],
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'M',
                        children: [
                          TextSpan(
                            text: '//',
                            style: TextStyle(color: AppColors.accent),
                          ),
                          TextSpan(text: 'T'),
                        ],
                      ),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'monospace',
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(
                          alpha: .5 + (.5 * pulse),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.animation, required this.reducedMotion});

  final Animation<double> animation;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: ColoredBox(
        color: const Color(0x0DFFFFFF),
        child: SizedBox(
          width: 192,
          height: 2,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final progress = reducedMotion ? .5 : animation.value;
              return Align(
                alignment: Alignment(-2 + (4 * progress), 0),
                child: Container(
                  width: 96,
                  height: 2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.transparent,
                        AppColors.accent,
                        AppColors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
