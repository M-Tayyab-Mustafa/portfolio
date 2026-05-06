part of '_bloc.dart';

class ShellState {
  const ShellState({this.currentRoute = AppRoutes.about});

  final String currentRoute;

  ShellState copyWith({String? currentRoute}) {
    return ShellState(currentRoute: currentRoute ?? this.currentRoute);
  }
}
