import 'package:portfolio/utils/exports.dart';

class HeadingText extends StatelessWidget {
  const HeadingText({
    super.key,
    required this.text,
    this.trailing,
    this.onTapTrailing,
  });
  final String text;
  final String? trailing;
  final VoidCallback? onTapTrailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTextStyles.interFontFamily,
                ),
              ),
              Padding(
                padding: context.edgeInsets(top: 8),
                child: SizedBox(width: 100.w, child: Divider(thickness: 2)),
              ),
            ],
          ),
        ),
        if (trailing != null)
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: onTapTrailing,
            child: Padding(
              padding: context.edgeInsets(horizontal: 16, vertical: 8),
              child: Text(
                trailing!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
      ],
    );
  }
}

class TabletHeadingText extends StatelessWidget {
  const TabletHeadingText({
    super.key,
    required this.text,
    this.trailing,
    this.onTapTrailing,
  });
  final String text;
  final String? trailing;
  final VoidCallback? onTapTrailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                // Tablet: step down from displayMedium → headlineLarge
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTextStyles.interFontFamily,
                ),
              ),
              Padding(
                padding: context.edgeInsets(top: 6),
                // Tablet: slightly shorter divider accent
                child: SizedBox(width: 70.w, child: Divider(thickness: 2)),
              ),
            ],
          ),
        ),
        if (trailing != null)
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: onTapTrailing,
            child: Padding(
              padding: context.edgeInsets(horizontal: 12, vertical: 6),
              child: Text(
                trailing!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
      ],
    );
  }
}

class MobileHeadingText extends StatelessWidget {
  const MobileHeadingText({
    super.key,
    required this.text,
    this.trailing,
    this.onTapTrailing,
  });
  final String text;
  final String? trailing;
  final VoidCallback? onTapTrailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                // Mobile: step down from headlineLarge → headlineMedium
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTextStyles.interFontFamily,
                ),
              ),
              Padding(
                padding: context.edgeInsets(top: 5),
                // Mobile: shorter accent divider
                child: SizedBox(width: 48.w, child: Divider(thickness: 2)),
              ),
            ],
          ),
        ),
        if (trailing != null)
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: onTapTrailing,
            child: Padding(
              padding: context.edgeInsets(horizontal: 10, vertical: 6),
              child: Text(
                trailing!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
}
