import 'package:portfolio/presentation/widgets/button.dart';
import 'package:portfolio/presentation/widgets/image.dart';
import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});
  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return _MobileCard(project: project);
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      return _TabletCard(project: project);
    } else {
      return _WebCard(project: project);
    }
  }
}

class _WebCard extends StatelessWidget {
  const _WebCard({required this.project});
  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasImage = project.image.isNotEmpty;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16.r),
      ),
      child: SizedBox(
        width: 435.w,
        height: 550.h,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage)
                CImage(
                  height: 220.h,
                  width: double.infinity,
                  path: project.image,
                  fit: BoxFit.cover,
                ),
              Divider(thickness: 2, color: cs.inverseSurface),
              Expanded(
                child: Padding(
                  padding: context.edgeInsets(
                    top: 16,
                    horizontal: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontFamily: AppTextStyles.interFontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: context.edgeInsets(vertical: 10),
                          child: Text(
                            project.description,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      Padding(
                        padding: context.edgeInsets(bottom: 14, top: 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: project.skills.map((s) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                border: BoxBorder.all(color: cs.primary),
                              ),
                              child: Padding(
                                padding: context.edgeInsets(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  s,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontFamily:
                                            AppTextStyles.nimbusMonoFontFamily,
                                      ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      if (project.playStoreLink != null)
                        LinkButton(
                          title: 'VIEW ON PLAY STORE',
                          url: project.playStoreLink!,
                        )
                      else if (project.appStoreLink != null)
                        LinkButton(
                          title: 'VIEW ON APP STORE',
                          url: project.appStoreLink!,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabletCard extends StatelessWidget {
  const _TabletCard({required this.project});
  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasImage = project.image.isNotEmpty;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16.r),
      ),
      child: SizedBox(
        width: 340.w,
        height: 400.h,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage)
                CImage(
                  height: 180.h,
                  width: double.infinity,
                  path: project.image,
                  fit: BoxFit.cover,
                ),
              Divider(thickness: 2, color: cs.inverseSurface),
              Expanded(
                child: Padding(
                  padding: context.edgeInsets(
                    top: 12,
                    horizontal: 14,
                    bottom: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: AppTextStyles.interFontFamily,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: context.edgeInsets(vertical: 8),
                          child: Text(
                            project.description,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      Padding(
                        padding: context.edgeInsets(bottom: 12, top: 6),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: project.skills.map((s) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                border: BoxBorder.all(color: cs.primary),
                              ),
                              child: Padding(
                                padding: context.edgeInsets(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Text(
                                  s,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontFamily:
                                            AppTextStyles.nimbusMonoFontFamily,
                                      ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      if (project.playStoreLink != null)
                        LinkButton(
                          title: 'VIEW ON PLAY STORE',
                          url: project.playStoreLink!,
                        )
                      else if (project.appStoreLink != null)
                        LinkButton(
                          title: 'VIEW ON APP STORE',
                          url: project.appStoreLink!,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileCard extends StatelessWidget {
  const _MobileCard({required this.project});
  final ProjectEntity project;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
