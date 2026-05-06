part of '_bloc.dart';

abstract class ShellEvent {
  const ShellEvent();
}

class ShellStarted extends ShellEvent {
  const ShellStarted({required this.router, required this.scrollController});

  final GoRouter router;
  final ScrollController scrollController;
}

class ShellRouteChanged extends ShellEvent {
  const ShellRouteChanged();
}

class ShellScrolled extends ShellEvent {
  const ShellScrolled({this.viewportHeight});

  final double? viewportHeight;
}

class ShellSectionSelected extends ShellEvent {
  const ShellSectionSelected(this.route);

  final String route;
}
