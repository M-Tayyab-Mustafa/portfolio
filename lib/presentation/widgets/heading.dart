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
