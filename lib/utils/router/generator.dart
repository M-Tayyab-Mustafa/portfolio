import '../export.dart';

class RouterGenerator {
  RouterGenerator._privateConstructor();
  static RouterGenerator? _instance;
  static RouterGenerator get instance => _instance ??= RouterGenerator._privateConstructor();
  GoRouter routerConfig = GoRouter(
    initialLocation: AppHelper.kDevice == Device.mobile || AppHelper.kDevice == Device.tab ? RouteName.splash : RouteName.home,
    routes: [
      Transition.screenFadeTransition(
        name: RouteName.splash,
        child: BlocProvider(
          create: (context) => SplashBloc(context: context),
          child: const SplashPage(),
        ),
      ),
      Transition.screenFadeTransition(
        name: RouteName.home,
        child: BlocProvider(
          create: (context) => HomeBloc(),
          child: const HomePage(),
        ),
      ),
    ],
  );
}
