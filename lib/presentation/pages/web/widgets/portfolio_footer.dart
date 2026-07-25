import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';
import 'package:portfolio/presentation/widgets/brand_logo.dart';

class PortfolioFooter extends StatelessWidget {
  const PortfolioFooter({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.contentMaxWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppLayout.horizontalPadding(width),
              vertical: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BrandLogo(
                      profile: content.profile,
                      semanticLabel: 'Muhammad Tayyab',
                      compact: true,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© ${DateTime.now().year} Muhammad Tayyab. Built with Flutter.',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final social in content.socials) ...[
                      const SizedBox(width: 8),
                      AppIconButton(
                        size: 36,
                        tooltip: social.label,
                        onPressed: () => context.read<ExternalLinkCubit>().open(
                          url: social.url,
                          label: social.label,
                          failureTemplate: '{label} could not be opened.',
                        ),
                        icon: AppIcon(social.iconName, size: 17),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
