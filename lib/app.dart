import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/domain/repositories/portfolio_repository.dart';
import 'package:portfolio/presentation/blocs/content/portfolio_content_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends StatelessWidget {
  const App({required this.repository, super.key});

  final PortfolioRepository repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (context) =>
            PortfolioContentBloc(context.read<PortfolioRepository>())
              ..add(const PortfolioContentStarted()),
        child: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Muhammad Tayyab — Senior Flutter Developer',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        breakpoints: const [
          Breakpoint(start: 0, end: 899, name: MOBILE),
          Breakpoint(start: 900, end: 1199, name: TABLET),
          Breakpoint(start: 1200, end: 1599, name: DESKTOP),
          Breakpoint(start: 1600, end: double.infinity, name: 'WIDE_DESKTOP'),
        ],
        child: child!,
      ),
    );
  }
}
