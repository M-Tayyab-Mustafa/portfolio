part of 'package:portfolio/utils/utils_exports.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final routerConfig = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: AppRoutes.about,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ShellBloc()),
          BlocProvider(create: (_) => AboutBloc(getAbout: Injection.getAbout)),
          BlocProvider(
            create: (_) => SkillsBloc(
              getSkillAnalytics: Injection.getSkillAnalytics,
              getTechnicalSkills: Injection.getTechnicalSkills,
            ),
          ),
          BlocProvider(
            create: (_) =>
                ExperienceBloc(getExperiences: Injection.getExperiences),
          ),
          BlocProvider(
            create: (_) => ProjectsBloc(
              getFeaturedProjects: Injection.getFeaturedProjects,
              getAllProjects: Injection.getAllProjects,
            ),
          ),
          BlocProvider(create: (_) => ContactBloc()),
        ],
        child: const ShellPage(),
      ),
      routes: [
        GoRoute(path: AppRoutes.about, pageBuilder: (_, _) => _page()),
        GoRoute(path: AppRoutes.skills, pageBuilder: (_, _) => _page()),
        GoRoute(path: AppRoutes.experience, pageBuilder: (_, _) => _page()),
        GoRoute(path: AppRoutes.projects, pageBuilder: (_, _) => _page()),
        GoRoute(path: AppRoutes.contact, pageBuilder: (_, _) => _page()),
      ],
    ),
    GoRoute(
      path: AppRoutes.allProjects,
      pageBuilder: (_, _) => MaterialPage(
        child: BlocProvider(
          create: (_) => ProjectsBloc(
            getFeaturedProjects: Injection.getFeaturedProjects,
            getAllProjects: Injection.getAllProjects,
          ),
          child: const AllProjectsPage(),
        ),
      ),
    ),
  ],
);

NoTransitionPage _page() => const NoTransitionPage(child: SizedBox.shrink());
