import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

part '_event.dart';
part '_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  AboutBloc({required GetAboutUseCase getAbout})
    : _getAbout = getAbout,
      super(const AboutState()) {
    on<AboutStarted>(_onStarted);
    on<ContactMe>(_onContactMe);
    on<ViewAllProjects>(_onViewAllProjects);
  }

  final GetAboutUseCase _getAbout;

  Future<void> _onStarted(AboutStarted event, Emitter<AboutState> emit) async {
    emit(state.copyWith(isLoading: true));
    final about = await _getAbout();
    emit(state.copyWith(about: about, isLoading: false));
  }

  void _onContactMe(ContactMe event, Emitter<AboutState> emit) =>
      event.context.go(AppRoutes.contact);

  void _onViewAllProjects(ViewAllProjects event, Emitter<AboutState> emit) =>
      event.context.go(AppRoutes.allProjects);
}
