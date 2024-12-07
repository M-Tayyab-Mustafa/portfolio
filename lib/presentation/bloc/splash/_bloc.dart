import '../../export.dart';
part '_event.dart';
part '_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final BuildContext context;
  SplashBloc({required this.context}) : super(SplashState()) {
    on<InitializeEvent>(_initializeEvent);

    add(InitializeEvent());
  }

  FutureOr<void> _initializeEvent(InitializeEvent event, Emitter<SplashState> emit) async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      context.pushReplacementNamed(RouteName.home);
    }
  }
}
