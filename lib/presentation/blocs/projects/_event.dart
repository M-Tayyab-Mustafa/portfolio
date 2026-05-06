part of '_bloc.dart';

abstract class ProjectsEvent {
  const ProjectsEvent();
}

class ProjectsStarted extends ProjectsEvent {
  const ProjectsStarted();
}

class FetchAllProjects extends ProjectsEvent {
  const FetchAllProjects();
}

class ViewAllProjects extends ProjectsEvent {
  final BuildContext context;
  const ViewAllProjects({required this.context});
}
