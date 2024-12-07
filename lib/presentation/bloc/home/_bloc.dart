import '../../export.dart';
part '_event.dart';
part '_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState());
}
