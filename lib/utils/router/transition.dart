import '../export.dart';

class Transition {
  static int get _transitionDuration => 500;

  static GoRoute screenFadeTransition({
    required String name,
    required Widget child,
    List<RouteBase> routes = const <RouteBase>[],
    ExitCallback? onExit,
  }) {
    return GoRoute(
      name: name,
      path: name,
      routes: routes,
      onExit: onExit,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: Duration(milliseconds: _transitionDuration),
        reverseTransitionDuration: Duration(milliseconds: _transitionDuration),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
  }
}
