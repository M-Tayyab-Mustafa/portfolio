part of '_bloc.dart';

abstract class ContactEvent {
  const ContactEvent();
}

class SendMessageEvent extends ContactEvent {
  const SendMessageEvent();
}

class GitHubEvent extends ContactEvent {
  const GitHubEvent();
}

class LinkedinEvent extends ContactEvent {
  const LinkedinEvent();
}

class EmailEvent extends ContactEvent {
  const EmailEvent();
}
