part of '_bloc.dart';

abstract class AboutEvent {
  const AboutEvent();
}

class AboutStarted extends AboutEvent {
  const AboutStarted();
}

class ContactMe extends AboutEvent {
  final BuildContext context;
  const ContactMe({required this.context});
}

class ViewAllProjects extends AboutEvent {
  final BuildContext context;
  const ViewAllProjects({required this.context});
}
