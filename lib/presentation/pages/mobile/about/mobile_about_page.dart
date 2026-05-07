import 'package:portfolio/presentation/blocs/about/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/button.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

class MobileAboutPage extends StatefulWidget {
  const MobileAboutPage({super.key});

  @override
  State<MobileAboutPage> createState() => _MobileAboutPageState();
}

class _MobileAboutPageState extends State<MobileAboutPage>
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

    final imageSize = Size(180.w, 180.h);
    final placeholderColor = colorScheme.surfaceContainerHighest;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surfaceContainerLow,
      child: SingleChildScrollView(
        child: Padding(
          padding: context.edgeInsets(horizontal: 20, top: 36, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: imageSize.height,
                  width: imageSize.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: placeholderColor,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20.w,
                    child: Divider(
                      color: colorScheme.primary,
                      thickness: 1.5.h,
                    ),
                  ),
                  Padding(
                    padding: context.edgeInsets(left: 8),
                    child: Container(
                      width: 70.w,
                      height: 10.h,
                      color: placeholderColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              Container(width: 200.w, height: 32.h, color: placeholderColor),

              SizedBox(height: 8.h),

              Container(width: 140.w, height: 14.h, color: placeholderColor),

              SizedBox(height: 16.h),

              Column(
                children: List.generate(
                  5,
                  (_) => Padding(
                    padding: context.edgeInsets(bottom: 7),
                    child: Container(
                      width: double.infinity,
                      height: 12.h,
                      color: placeholderColor,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              Container(
                width: double.infinity,
                height: 44.h,
                decoration: BoxDecoration(
                  color: placeholderColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),

              SizedBox(height: 12.h),

              Container(
                width: double.infinity,
                height: 44.h,
                decoration: BoxDecoration(
                  color: placeholderColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AboutEntity about) {
    final cs = Theme.of(context).colorScheme;

    final imageSize = Size(180.w, 180.h);

    return SingleChildScrollView(
      child: Padding(
        padding: context.edgeInsets(horizontal: 20, top: 36, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeSlide(
              beginOffset: const Offset(0, -24),
              child: Center(
                child: AnimatedBuilder(
                  animation: _borderCtrl,
                  builder: (_, child) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
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
                    borderRadius: BorderRadius.circular(16.r),
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

            SizedBox(height: 24.h),

            FadeSlide(
              delay: const Duration(milliseconds: 100),
              beginOffset: const Offset(0, 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20.w,
                    child: Divider(color: cs.primary, thickness: 1.5.h),
                  ),
                  Padding(
                    padding: context.edgeInsets(left: 8),
                    child: Text(
                      about.badge,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 9.sp,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            FadeSlide(
              delay: const Duration(milliseconds: 160),
              beginOffset: const Offset(0, 20),
              child: Text(
                about.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 30.sp,
                  letterSpacing: 1.5,
                  height: 1.15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: 16.h),

            FadeSlide(
              delay: const Duration(milliseconds: 260),
              child: Text(
                about.bio,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.65,
                ),
              ),
            ),

            SizedBox(height: 28.h),

            FadeSlide(
              delay: const Duration(milliseconds: 360),
              beginOffset: const Offset(0, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HoverCard(
                    child: AppButton(
                      onTap: () => context.read<AboutBloc>().add(
                        ViewAllProjects(context: context),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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

                  SizedBox(height: 12.h),

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
          ],
        ),
      ),
    );
  }
}
