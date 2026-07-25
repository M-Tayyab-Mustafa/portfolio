import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/links/external_link_cubit.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';
import 'package:portfolio/presentation/widgets/brand_logo.dart';

import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';

class PortfolioFooter extends StatelessWidget {
  const PortfolioFooter({required this.content, super.key});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return ColoredBox(
      color: AppColors.background,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppLayout.contentMaxWidth,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppLayout.horizontalPadding(width),
                56,
                AppLayout.horizontalPadding(width),
                40,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _FooterBrand(content: content),
                  ),
                  const SizedBox(height: 42),
                  const Divider(height: 1),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '© ${DateTime.now().year} Muhammad Tayyab. Built with Flutter.',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                        ),
                      ),
                      for (final social in content.socials) ...[
                        const SizedBox(width: 8),
                        AppIconButton(
                          size: 36,
                          tooltip: social.label,
                          onPressed: () =>
                              context.read<ExternalLinkCubit>().open(
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
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand({required this.content});

  final PortfolioDataState content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BrandLogo(
          profile: content.profile,
          semanticLabel: 'Muhammad Tayyab, go to the portfolio home section',
          onPressed: () => context.read<PortfolioNavigationCubit>().navigateTo(
            PortfolioSection.home,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Production Flutter products, built for clarity and growth.',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
