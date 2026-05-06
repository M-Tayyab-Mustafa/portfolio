import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

part '_event.dart';
part '_state.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  ExperienceBloc({required GetExperiencesUseCase getExperiences})
    : _getExperiences = getExperiences,
      super(const ExperienceState()) {
    on<ExperienceStarted>(_onStarted);
  }

  final GetExperiencesUseCase _getExperiences;

  Future<void> _onStarted(
    ExperienceStarted event,
    Emitter<ExperienceState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final experiences = await _getExperiences();
    emit(state.copyWith(experiences: experiences, isLoading: false));
  }
}
