import 'package:portfolio/domain/domain_exports.dart';
import 'package:portfolio/utils/exports.dart';

part '_event.dart';
part '_state.dart';

class SkillsBloc extends Bloc<SkillsEvent, SkillsState> {
  SkillsBloc({
    required GetSkillAnalyticsUseCase getSkillAnalytics,
    required GetTechnicalSkillsUseCase getTechnicalSkills,
  }) : _getSkillAnalytics = getSkillAnalytics,
       _getTechnicalSkills = getTechnicalSkills,
       super(const SkillsState()) {
    on<SkillsStarted>(_onStarted);
  }

  final GetSkillAnalyticsUseCase _getSkillAnalytics;
  final GetTechnicalSkillsUseCase _getTechnicalSkills;

  Future<void> _onStarted(
    SkillsStarted event,
    Emitter<SkillsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final results = await Future.wait([
      _getSkillAnalytics(),
      _getTechnicalSkills(),
    ]);
    emit(
      state.copyWith(
        analytics: results[0] as List<SkillAnalyticEntity>,
        technicalSkills: results[1] as List<TechnicalSkillEntity>,
        isLoading: false,
      ),
    );
  }
}
