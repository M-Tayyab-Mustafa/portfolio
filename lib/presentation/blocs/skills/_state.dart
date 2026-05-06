part of '_bloc.dart';

class SkillsState {
  final List<SkillAnalyticEntity> analytics;
  final List<TechnicalSkillEntity> technicalSkills;
  final bool isLoading;

  const SkillsState({
    this.analytics = const [],
    this.technicalSkills = const [],
    this.isLoading = false,
  });

  SkillsState copyWith({
    List<SkillAnalyticEntity>? analytics,
    List<TechnicalSkillEntity>? technicalSkills,
    bool? isLoading,
  }) => SkillsState(
    analytics: analytics ?? this.analytics,
    technicalSkills: technicalSkills ?? this.technicalSkills,
    isLoading: isLoading ?? this.isLoading,
  );
}
