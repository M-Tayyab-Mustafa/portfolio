import 'package:portfolio/presentation/blocs/about/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/button.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

class TabletAboutPage extends StatefulWidget {
  const TabletAboutPage({super.key});

  @override
  State<TabletAboutPage> createState() => _TabletAboutPageState();
}

class _TabletAboutPageState extends State<TabletAboutPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _borderCtrl;

  @override
  void initState() {
    super.initState();
    context.read<AboutBloc>().add(const AboutStarted());
    _borderCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _borderCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutBloc, AboutState>(
      builder: (context, state) {
        if (state.isLoading || state.about == null) {
          return _buildShimmerSkeleton();
        }
        return _buildContent(state.about!);
      },
    );
  }

  Widget _buildShimmerSkeleton() {
    final colorScheme = Theme.of(context).colorScheme;
    // Tablet: smaller, centred image
    final imageSize = Size(260.w, 260.h);
    final placeholderColor = colorScheme.surfaceContainerHighest;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surfaceContainerLow,
      child: SingleChildScrollView(
        child: Padding(
          padding: context.edgeInsets(horizontal: 24, top: 48, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image placeholder – centred on tablet
              Center(
                child: Container(
                  height: imageSize.height,
                  width: imageSize.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    color: placeholderColor,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Badge row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 25.w,
                    child: Divider(
                      color: colorScheme.primary,
                      thickness: 1.5.h,
                    ),
                  ),
                  Padding(
                    padding: context.edgeInsets(left: 8),
                    child: Container(
                      width: 80.w,
                      height: 12.h,
                      color: placeholderColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Name
              Container(width: 280.w, height: 40.h, color: placeholderColor),

              SizedBox(height: 20.h),

              // Bio lines
              Column(
                children: List.generate(
                  4,
                  (_) => Padding(
                    padding: context.edgeInsets(bottom: 8),
                    child: Container(
                      width: double.infinity,
                      height: 14.h,
                      color: placeholderColor,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // Buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: placeholderColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Container(
                    width: 120.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: placeholderColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AboutEntity about) {
    final cs = Theme.of(context).colorScheme;
    // Tablet: smaller image, centred above text
    final imageSize = Size(260.w, 260.h);

    return SingleChildScrollView(
      child: Padding(
        padding: context.edgeInsets(horizontal: 24, top: 48, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Animated portrait ──────────────────────────────────────────
            FadeSlide(
              beginOffset: const Offset(0, -30),
              child: Center(
                child: AnimatedBuilder(
                  animation: _borderCtrl,
                  builder: (_, child) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      gradient: SweepGradient(
                        transform: GradientRotation(
                          _borderCtrl.value * 6.28318,
                        ),
                        colors: [
                          cs.primary,
                          cs.inversePrimary,
                          cs.inversePrimary,
                          cs.primary,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: child,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: cs.surface),
                      child: CImage(
                        height: imageSize.height,
                        width: imageSize.width,
                        path: about.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 36.h),

            // ── Text content ───────────────────────────────────────────────
            FadeSlide(
              delay: const Duration(milliseconds: 100),
              beginOffset: const Offset(-30, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 25.w,
                    child: Divider(color: cs.primary, thickness: 1.5.h),
                  ),
                  Padding(
                    padding: context.edgeInsets(left: 8),
                    child: Text(
                      about.badge,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            FadeSlide(
              delay: const Duration(milliseconds: 180),
              beginOffset: const Offset(-30, 0),
              child: Text(
                about.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  // Tablet: slightly smaller than the 64.sp desktop value
                  fontSize: 44.sp,
                  letterSpacing: 2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            FadeSlide(
              delay: const Duration(milliseconds: 280),
              child: Padding(
                padding: context.edgeInsets(top: 20),
                child: Text(
                  about.bio,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ),

            FadeSlide(
              delay: const Duration(milliseconds: 400),
              beginOffset: const Offset(0, 30),
              child: Padding(
                padding: context.edgeInsets(top: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HoverCard(
                      child: AppButton(
                        onTap: () => context.read<AboutBloc>().add(
                          ViewAllProjects(context: context),
                        ),
                        margin: context.edgeInsets(right: 14),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: context.edgeInsets(right: 8),
                              child: Text(
                                'VIEW PROJECTS',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(color: cs.onPrimary),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.arrow_right,
                              size: Theme.of(
                                context,
                              ).textTheme.labelLarge?.fontSize,
                              color: cs.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    HoverCard(
                      child: AppButton(
                        onTap: () => context.read<AboutBloc>().add(
                          ContactMe(context: context),
                        ),
                        color: cs.surface,
                        title: 'CONTACT ME',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
