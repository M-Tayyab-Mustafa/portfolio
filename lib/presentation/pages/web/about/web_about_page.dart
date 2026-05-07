import 'package:portfolio/presentation/blocs/about/_bloc.dart';
import 'package:portfolio/presentation/widgets/animated_section.dart';
import 'package:portfolio/presentation/widgets/button.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

class WebAboutPage extends StatefulWidget {
  const WebAboutPage({super.key});

  @override
  State<WebAboutPage> createState() => _WebAboutPageState();
}

class _WebAboutPageState extends State<WebAboutPage>
    with SingleTickerProviderStateMixin {
  final double _screenHeight =
      PlatformDispatcher.instance.views.first.physicalSize.height /
      PlatformDispatcher.instance.views.first.devicePixelRatio;

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
    return SizedBox(
      height: _screenHeight - kToolbarHeight,
      child: BlocBuilder<AboutBloc, AboutState>(
        builder: (context, state) {
          if (state.isLoading || state.about == null) {
            return _buildShimmerSkeleton();
          }
          return _buildContent(state.about!);
        },
      ),
    );
  }

  Widget _buildShimmerSkeleton() {
    final colorScheme = Theme.of(context).colorScheme;
    final imageSize = Size(400.w, 400.h);

    final placeholderColor = colorScheme.surfaceContainerHighest;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surfaceContainerLow,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: context.edgeInsets(left: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 25.w,
                        child: Divider(
                          color: colorScheme.primary,
                          thickness: 2.h,
                        ),
                      ),
                      Padding(
                        padding: context.edgeInsets(left: 8),
                        child: Container(
                          width: 80.w,
                          height: 16.h,
                          color: placeholderColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  Container(
                    width: 300.w,
                    height: 48.h,
                    color: placeholderColor,
                  ),

                  SizedBox(height: 24.h),

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

                  SizedBox(height: 32.h),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                height: imageSize.height,
                width: imageSize.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  color: placeholderColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AboutEntity about) {
    final cs = Theme.of(context).colorScheme;
    final imageSize = Size(400.w, 400.h);

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: context.edgeInsets(left: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeSlide(
                  beginOffset: const Offset(-50, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 25.w,
                        child: Divider(color: cs.primary, thickness: 2.h),
                      ),
                      Padding(
                        padding: context.edgeInsets(left: 8),
                        child: Text(
                          about.badge,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                FadeSlide(
                  delay: const Duration(milliseconds: 100),
                  beginOffset: const Offset(-50, 0),
                  child: Text(
                    about.name,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 64.sp,
                      letterSpacing: 2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                FadeSlide(
                  delay: const Duration(milliseconds: 240),
                  child: Padding(
                    padding: context.edgeInsets(top: 24),
                    child: Text(
                      about.bio,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                FadeSlide(
                  delay: const Duration(milliseconds: 380),
                  beginOffset: const Offset(0, 30),
                  child: Padding(
                    padding: context.edgeInsets(top: 32),
                    child: Row(
                      children: [
                        HoverCard(
                          child: AppButton(
                            onTap: () => context.read<AboutBloc>().add(
                              ViewAllProjects(context: context),
                            ),
                            margin: context.edgeInsets(right: 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: context.edgeInsets(right: 8),
                                  child: Text(
                                    'VIEW PROJECTS',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
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
        ),

        Expanded(
          flex: 5,
          child: FadeSlide(
            delay: const Duration(milliseconds: 140),
            beginOffset: const Offset(50, 0),
            child: Center(
              child: AnimatedBuilder(
                animation: _borderCtrl,
                builder: (_, child) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    gradient: SweepGradient(
                      transform: GradientRotation(_borderCtrl.value * 6.28318),
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.inversePrimary,
                        Theme.of(context).colorScheme.inversePrimary,
                        Theme.of(context).colorScheme.primary,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: child,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
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
        ),
      ],
    );
  }
}
