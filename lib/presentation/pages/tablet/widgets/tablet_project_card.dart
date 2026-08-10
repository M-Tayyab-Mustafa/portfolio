import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_spacing.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/presentation/blocs/navigation/portfolio_navigation_cubit.dart';
import 'package:portfolio/presentation/widgets/app_icon.dart';
import 'package:portfolio/presentation/widgets/portfolio_image.dart';

class TabletProjectCard extends StatelessWidget {
  const TabletProjectCard({required this.project, super.key});

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open ${project.title} case study',
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppLayout.radius),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.read<PortfolioNavigationCubit>().openCaseStudy(
            project.slug,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: AppColors.elevatedSurface,
                      child: project.imageUrl.trim().isEmpty
                          ? Center(
                              child: AppIcon(
                                project.iconName,
                                size: 34,
                                color: AppColors.accent,
                              ),
                            )
                          : PortfolioImage(
                              source: project.imageUrl,
                              fit: BoxFit.cover,
                              semanticLabel: '${project.title} preview',
                            ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xB8080808)],
                          stops: [.52, 1],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      bottom: 13,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.background.withValues(alpha: .88),
                          border: Border.all(color: AppColors.borderStrong),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          child: Text(
                            project.category.label.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: 'monospace',
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(19),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontSize: 17, height: 1.2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: .1),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: .28),
                            ),
                          ),
                          child: const Center(
                            child: AppIcon(
                              'arrowLongRight',
                              size: 16,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      project.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    if (project.tags.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final tag in project.tags.take(3))
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                child: Text(
                                  tag.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontFamily: 'monospace',
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
