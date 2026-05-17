import 'package:portfolio/utils/exports.dart';

class CTextField extends StatelessWidget {
  const CTextField({
    super.key,
    required this.label,
    required this.controller,
    this.margin,
    this.maxLength,
    this.maxLine = 1,
    this.counterText,
    required this.hintText,
    this.validator,
  });
  final String label;
  final TextEditingController controller;
  final EdgeInsets? margin;
  final int? maxLength;
  final int maxLine;
  final String? counterText;
  final String hintText;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: context.edgeInsets(left: 8, bottom: 8),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLength: maxLength,
            maxLines: maxLine,
            decoration: InputDecoration(
              hintText: hintText,
              counterText: counterText ?? '',
            ),
          ),
        ],
      ),
    );
  }
}
