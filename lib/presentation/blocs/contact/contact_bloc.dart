import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/domain/services/contact_message_sender.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';

sealed class ContactEvent {
  const ContactEvent();
}

final class ContactNameChanged extends ContactEvent {
  const ContactNameChanged(this.value);
  final String value;
}

final class ContactEmailChanged extends ContactEvent {
  const ContactEmailChanged(this.value);
  final String value;
}

final class ContactSubjectChanged extends ContactEvent {
  const ContactSubjectChanged(this.value);
  final String value;
}

final class ContactMessageChanged extends ContactEvent {
  const ContactMessageChanged(this.value);
  final String value;
}

final class ContactSubmitted extends ContactEvent {
  const ContactSubmitted();
}

final class ContactConfigurationChanged extends ContactEvent {
  const ContactConfigurationChanged(this.configuration);
  final ContactConfiguration configuration;
}

enum ContactSubmissionStatus { idle, submitting, success, failure }

class ContactConfiguration {
  const ContactConfiguration({
    required this.emailJs,
    required this.nameLabel,
    required this.emailLabel,
    required this.subjectLabel,
    required this.messageLabel,
    required this.requiredTemplate,
    required this.minimumTemplate,
    required this.emailRequiredMessage,
    required this.emailInvalidMessage,
    required this.successMessage,
    required this.failureMessage,
  });

  factory ContactConfiguration.fromContent(PortfolioContent content) {
    return ContactConfiguration(
      emailJs: content.emailJs,
      nameLabel: 'Full name',
      emailLabel: 'Email address',
      subjectLabel: 'Subject',
      messageLabel: 'Message',
      requiredTemplate: '{field} is required.',
      minimumTemplate: '{field} must be at least {minimum} characters.',
      emailRequiredMessage: 'Email address is required.',
      emailInvalidMessage: 'Enter a valid email address.',
      successMessage: 'Message sent successfully. I’ll get back to you soon.',
      failureMessage:
          'The message could not be sent. You can write directly to ${content.profile.email}.',
    );
  }

  final EmailJsConfiguration emailJs;
  final String nameLabel;
  final String emailLabel;
  final String subjectLabel;
  final String messageLabel;
  final String requiredTemplate;
  final String minimumTemplate;
  final String emailRequiredMessage;
  final String emailInvalidMessage;
  final String successMessage;
  final String failureMessage;
}

class ContactState {
  const ContactState({
    required this.configuration,
    this.name = '',
    this.email = '',
    this.subject = '',
    this.message = '',
    this.nameError,
    this.emailError,
    this.subjectError,
    this.messageError,
    this.hasSubmitted = false,
    this.status = ContactSubmissionStatus.idle,
    this.feedbackId = 0,
    this.feedbackMessage,
    this.formRevision = 0,
  });

  final ContactConfiguration configuration;
  final String name;
  final String email;
  final String subject;
  final String message;
  final String? nameError;
  final String? emailError;
  final String? subjectError;
  final String? messageError;
  final bool hasSubmitted;
  final ContactSubmissionStatus status;
  final int feedbackId;
  final String? feedbackMessage;
  final int formRevision;

  bool get isSubmitting => status == ContactSubmissionStatus.submitting;

  ContactState copyWith({
    ContactConfiguration? configuration,
    String? name,
    String? email,
    String? subject,
    String? message,
    String? nameError,
    String? emailError,
    String? subjectError,
    String? messageError,
    bool clearNameError = false,
    bool clearEmailError = false,
    bool clearSubjectError = false,
    bool clearMessageError = false,
    bool? hasSubmitted,
    ContactSubmissionStatus? status,
    int? feedbackId,
    String? feedbackMessage,
    int? formRevision,
  }) {
    return ContactState(
      configuration: configuration ?? this.configuration,
      name: name ?? this.name,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      nameError: clearNameError ? null : nameError ?? this.nameError,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      subjectError: clearSubjectError
          ? null
          : subjectError ?? this.subjectError,
      messageError: clearMessageError
          ? null
          : messageError ?? this.messageError,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      status: status ?? this.status,
      feedbackId: feedbackId ?? this.feedbackId,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
      formRevision: formRevision ?? this.formRevision,
    );
  }
}

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc(
    ContactConfiguration configuration, {
    required ContactMessageSender messageSender,
  }) : _messageSender = messageSender,
       super(ContactState(configuration: configuration)) {
    on<ContactNameChanged>(_onNameChanged);
    on<ContactEmailChanged>(_onEmailChanged);
    on<ContactSubjectChanged>(_onSubjectChanged);
    on<ContactMessageChanged>(_onMessageChanged);
    on<ContactSubmitted>(_onSubmitted);
    on<ContactConfigurationChanged>(_onConfigurationChanged);
  }

  final ContactMessageSender _messageSender;

  void _onNameChanged(ContactNameChanged event, Emitter<ContactState> emit) {
    final error = state.hasSubmitted
        ? _required(event.value, state.configuration.nameLabel, 3)
        : null;
    emit(
      state.copyWith(
        name: event.value,
        nameError: error,
        clearNameError: error == null,
        status: ContactSubmissionStatus.idle,
      ),
    );
  }

  void _onEmailChanged(ContactEmailChanged event, Emitter<ContactState> emit) {
    final error = state.hasSubmitted ? _email(event.value) : null;
    emit(
      state.copyWith(
        email: event.value,
        emailError: error,
        clearEmailError: error == null,
        status: ContactSubmissionStatus.idle,
      ),
    );
  }

  void _onSubjectChanged(
    ContactSubjectChanged event,
    Emitter<ContactState> emit,
  ) {
    final error = state.hasSubmitted
        ? _required(event.value, state.configuration.subjectLabel, 4)
        : null;
    emit(
      state.copyWith(
        subject: event.value,
        subjectError: error,
        clearSubjectError: error == null,
        status: ContactSubmissionStatus.idle,
      ),
    );
  }

  void _onMessageChanged(
    ContactMessageChanged event,
    Emitter<ContactState> emit,
  ) {
    final error = state.hasSubmitted
        ? _required(event.value, state.configuration.messageLabel, 10)
        : null;
    emit(
      state.copyWith(
        message: event.value,
        messageError: error,
        clearMessageError: error == null,
        status: ContactSubmissionStatus.idle,
      ),
    );
  }

  Future<void> _onSubmitted(
    ContactSubmitted event,
    Emitter<ContactState> emit,
  ) async {
    if (state.isSubmitting) return;

    final nameError = _required(state.name, state.configuration.nameLabel, 3);
    final emailError = _email(state.email);
    final subjectError = _required(
      state.subject,
      state.configuration.subjectLabel,
      4,
    );
    final messageError = _required(
      state.message,
      state.configuration.messageLabel,
      10,
    );
    final valid = [
      nameError,
      emailError,
      subjectError,
      messageError,
    ].every((error) => error == null);

    emit(
      state.copyWith(
        nameError: nameError,
        emailError: emailError,
        subjectError: subjectError,
        messageError: messageError,
        clearNameError: nameError == null,
        clearEmailError: emailError == null,
        clearSubjectError: subjectError == null,
        clearMessageError: messageError == null,
        hasSubmitted: true,
        status: valid
            ? ContactSubmissionStatus.submitting
            : ContactSubmissionStatus.idle,
      ),
    );
    if (!valid) return;

    try {
      await _messageSender.send(
        configuration: state.configuration.emailJs,
        senderName: state.name.trim(),
        senderEmail: state.email.trim(),
        subject: state.subject.trim(),
        message: state.message.trim(),
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          name: '',
          email: '',
          subject: '',
          message: '',
          clearNameError: true,
          clearEmailError: true,
          clearSubjectError: true,
          clearMessageError: true,
          hasSubmitted: false,
          status: ContactSubmissionStatus.success,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: state.configuration.successMessage,
          formRevision: state.formRevision + 1,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ContactSubmissionStatus.failure,
          feedbackId: state.feedbackId + 1,
          feedbackMessage: state.configuration.failureMessage,
        ),
      );
    }
  }

  void _onConfigurationChanged(
    ContactConfigurationChanged event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(configuration: event.configuration));
  }

  String? _required(String raw, String label, int minimum) {
    final value = raw.trim();
    if (value.isEmpty) {
      return state.configuration.requiredTemplate.replaceAll('{field}', label);
    }
    if (value.length < minimum) {
      return state.configuration.minimumTemplate
          .replaceAll('{field}', label)
          .replaceAll('{minimum}', '$minimum');
    }
    return null;
  }

  String? _email(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return state.configuration.emailRequiredMessage;
    final valid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
    return valid ? null : state.configuration.emailInvalidMessage;
  }
}
