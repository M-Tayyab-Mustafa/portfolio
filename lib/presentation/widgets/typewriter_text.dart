import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/presentation/blocs/typewriter/typewriter_cubit.dart';

class TypewriterText extends StatelessWidget {
  const TypewriterText({required this.prefix, super.key, this.fontSize = 14});

  final String prefix;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TypewriterCubit, TypewriterState>(
      builder: (context, state) {
        if (state.roles.isEmpty) return const SizedBox.shrink();
        return Text.rich(
          TextSpan(
            text: '${prefix.toUpperCase()}  ',
            children: [
              TextSpan(
                text: state.visibleText,
                style: const TextStyle(color: AppColors.accent),
              ),
              TextSpan(
                text: '  ',
                style: TextStyle(
                  backgroundColor: AppColors.accent,
                  fontSize: fontSize - 1,
                ),
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'monospace',
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.25,
          ),
        );
      },
    );
  }
}
