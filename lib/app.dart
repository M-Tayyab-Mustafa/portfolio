import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/routing/app_router.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/domain/repositories/portfolio_repository.dart';
import 'package:portfolio/presentation/blocs/portfolio_data/portfolio_data_bloc.dart';
import 'package:portfolio/presentation/pages/splash/portfolio_splash_page.dart';
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
            PortfolioDataBloc(context.read<PortfolioRepository>())
              ..add(const PortfolioDataStarted()),
        child: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  bool _splashAnimationCompleted = false;

  void _onSplashAnimationComplete() {
    if (_splashAnimationCompleted || !mounted) return;
    setState(() => _splashAnimationCompleted = true);
  }

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
          Breakpoint(start: 0, end: 599, name: MOBILE),
          Breakpoint(start: 600, end: 1199, name: TABLET),
          Breakpoint(start: 1200, end: 1599, name: DESKTOP),
          Breakpoint(start: 1600, end: double.infinity, name: 'WIDE_DESKTOP'),
        ],
        child: BlocBuilder<PortfolioDataBloc, PortfolioDataState>(
          builder: (context, state) {
            if (state.isReady && _splashAnimationCompleted) return child!;
            return PortfolioSplashPage(
              errorMessage: state.status == PortfolioDataStatus.failure
                  ? state.errorMessage
                  : null,
              onAnimationComplete: _onSplashAnimationComplete,
              onRetry: () => context.read<PortfolioDataBloc>().add(
                const PortfolioDataRetryRequested(),
              ),
            );
          },
        ),
      ),
    );
  }
}
