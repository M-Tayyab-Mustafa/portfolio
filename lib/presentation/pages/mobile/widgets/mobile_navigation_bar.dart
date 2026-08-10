import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/routing/app_routes.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';
import 'package:portfolio/presentation/widgets/app_button.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';
import 'package:portfolio/presentation/widgets/brand_logo.dart';

class MobileNavigationBar extends StatelessWidget {
  const MobileNavigationBar({
    required this.content,
    required this.activeSection,
    required this.isScrolled,
    super.key,
  });

  final PortfolioDataState content;
  final PortfolioSection activeSection;
  final bool isScrolled;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    const navigationHeight = AppLayout.mobileNavigationHeight;
    final horizontalPadding = AppLayout.mobileHorizontalPadding(width);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      height: navigationHeight,
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: isScrolled ? .97 : .9),
        border: const Border(bottom: BorderSide(color: AppColors.border)),
        boxShadow: isScrolled
            ? const [
                BoxShadow(
                  color: Color(0x88000000),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ]
            : const [],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.mobileContentMaxWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                InkWell(
                  onTap: () => context
                      .read<PortfolioNavigationCubit>()
                      .navigateTo(PortfolioSection.home),
                  child: BrandLogo(
                    profile: content.profile,
                    semanticLabel: '${content.profile.fullName} home',
                    compact: true,
                    showWordmark: width >= 390,
                  ),
                ),
                const Spacer(),
                AppButton(
                  label: 'Hire me',
                  compact: true,
                  onPressed: () => context
                      .read<PortfolioNavigationCubit>()
                      .navigateTo(PortfolioSection.contact),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<PortfolioSection>(
                  tooltip: 'Open navigation',
                  color: AppColors.elevatedSurface,
                  surfaceTintColor: AppColors.transparent,
                  offset: Offset(0, navigationHeight - 10),
                  constraints: const BoxConstraints(minWidth: 220),
                  onSelected: (section) => context
                      .read<PortfolioNavigationCubit>()
                      .navigateTo(section),
                  itemBuilder: (context) => [
                    for (final section in PortfolioSection.values)
                      PopupMenuItem(
                        value: section,
                        height: 50,
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: section == activeSection ? 18 : 5,
                              height: 2,
                              color: section == activeSection
                                  ? AppColors.accent
                                  : AppColors.textMuted,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                content
                                    .navigationLabel(section.name)
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: section == activeSection
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.borderStrong),
                      borderRadius: BorderRadius.circular(AppLayout.radius),
                    ),
                    child: const Center(
                      child: AppIcon(
                        'widgets',
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
