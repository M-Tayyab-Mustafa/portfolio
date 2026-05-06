part of '_bloc.dart';

abstract class ExperienceEvent {
  const ExperienceEvent();
}

class ExperienceStarted extends ExperienceEvent {
  const ExperienceStarted();
}
