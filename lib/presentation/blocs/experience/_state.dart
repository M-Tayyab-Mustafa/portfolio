part of '_bloc.dart';

class ExperienceState {
  final List<ExperienceEntity> experiences;
  final bool isLoading;

  const ExperienceState({this.experiences = const [], this.isLoading = false});

  ExperienceState copyWith({
    List<ExperienceEntity>? experiences,
    bool? isLoading,
  }) => ExperienceState(
    experiences: experiences ?? this.experiences,
    isLoading: isLoading ?? this.isLoading,
  );
}
