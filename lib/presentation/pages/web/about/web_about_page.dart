import 'package:portfolio/presentation/blocs/about/_bloc.dart';
import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/presentation/widgets/button.dart';
import 'package:portfolio/utils/exports.dart';

class WebAboutPage extends StatefulWidget {
  const WebAboutPage({super.key});

  @override
  State<WebAboutPage> createState() => _WebAboutPageState();
}

class _WebAboutPageState extends State<WebAboutPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<AboutBloc>().add(const AboutStarted());
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
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surfaceContainerLow,
      child: Container(),
    );
  }

  Widget _buildContent(AboutEntity about) {
    final double screenHeight =
        PlatformDispatcher.instance.views.first.physicalSize.height /
        PlatformDispatcher.instance.views.first.devicePixelRatio;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: screenHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: context.edgeInsets(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: colorScheme.primary),
                            ),
                            child: Padding(
                              padding: context.edgeInsets(
                                vertical: 4,
                                horizontal: 12,
                              ),
                              child: Text(
                                'STATUS: ONLINE',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontFamily: AppTextStyles.jetBrainsMono,
                                      color: colorScheme.primary,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: context.edgeInsets(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  about.name.trim(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  about.badge,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontSize: 34,
                                        color: colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: context.edgeInsets(top: 8, bottom: 16),
                            child: Text(
                              about.bio,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Padding(
                            padding: context.edgeInsets(top: 16),
                            child: Row(
                              children: [
                                AppButton(
                                  title: 'INITIALIZE_PROJECT',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: colorScheme.primaryContainer,
                                        fontFamily: AppTextStyles.jetBrainsMono,
                                      ),
                                ),
                                AppButton(
                                  margin: context.edgeInsets(left: 16),
                                  showShadow: false,
                                  title: 'VIEW_SOURCE',
                                  borderColor: colorScheme.primary,
                                  color: AppColors.transparent,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: colorScheme.primary,
                                        fontFamily: AppTextStyles.jetBrainsMono,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.08,
                                ),
                                spreadRadius: 1,
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 80.w,
                                child: Divider(color: colorScheme.primary),
                              ),
                              Padding(
                                padding: context.edgeInsets(
                                  horizontal: 32,
                                  vertical: 26,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: context.edgeInsets(bottom: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: colorScheme.error,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: SizedBox(
                                                    height: 16,
                                                    width: 16,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: context.edgeInsets(
                                                    horizontal: 8,
                                                  ),
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color: colorScheme
                                                          .onSurfaceVariant,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                    ),
                                                  ),
                                                ),
                                                DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: colorScheme.outline,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: SizedBox(
                                                    height: 16,
                                                    width: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'sys_kernel.tsx',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: colorScheme.secondary,
                                                  fontFamily: AppTextStyles
                                                      .jetBrainsMono,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: context.edgeInsets(
                                        top: 32,
                                        bottom: 16,
                                      ),
                                      child: _buildTerminalText(),
                                    ),
                                  ],
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
              Align(
                alignment: Alignment.bottomRight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.08),
                        spreadRadius: screenHeight * 0.2,
                        blurRadius: screenHeight * 0.8,
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: screenHeight * 0.3,
                    width: screenHeight * 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          color: Theme.of(context).scaffoldBackgroundColor,
          height: screenHeight,
          child: Row(
            children: [
              Expanded(child: Container()),
              Expanded(child: Container()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTerminalText() {
    final secondaryTextStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontFamily: AppTextStyles.jetBrainsMono);
    final primaryTextStyle = secondaryTextStyle?.copyWith(
      color: Theme.of(context).colorScheme.primary,
    );

    final textSpans = [
      TextSpan(text: 'const ', style: primaryTextStyle),
      TextSpan(text: 'Architect = () => {\n', style: secondaryTextStyle),
      TextSpan(text: '  const ', style: primaryTextStyle),
      TextSpan(
        text: '[performance, setPerformance] = useState(\'MAX\');\n',
        style: secondaryTextStyle,
      ),
      TextSpan(text: '\n', style: secondaryTextStyle),
      TextSpan(text: '  return', style: primaryTextStyle),
      TextSpan(text: ' (\n', style: secondaryTextStyle),
      TextSpan(text: '    <', style: secondaryTextStyle),
      TextSpan(text: 'Ecosystem', style: primaryTextStyle),
      TextSpan(text: '>\n', style: secondaryTextStyle),
      TextSpan(text: '      <', style: secondaryTextStyle),
      TextSpan(text: 'Service ', style: primaryTextStyle),
      TextSpan(text: 'type="Distributed" />\n', style: secondaryTextStyle),
      TextSpan(text: '      <', style: secondaryTextStyle),
      TextSpan(text: 'Performance ', style: primaryTextStyle),
      TextSpan(text: 'metric={performance} />\n', style: secondaryTextStyle),
      TextSpan(text: '    </', style: secondaryTextStyle),
      TextSpan(text: 'Ecosystem', style: primaryTextStyle),
      TextSpan(text: '>\n', style: secondaryTextStyle),
      TextSpan(text: '  );\n', style: secondaryTextStyle),
      TextSpan(text: '};\n', style: secondaryTextStyle),
    ];
    return RichText(text: TextSpan(children: textSpans));
  }
}
