import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/constants/portfolio_local_content.dart';
import 'package:portfolio/data/models/portfolio_models.dart';
import 'package:portfolio/domain/repositories/portfolio_repository.dart';

sealed class PortfolioDataEvent {
  const PortfolioDataEvent();
}

final class PortfolioDataStarted extends PortfolioDataEvent {
  const PortfolioDataStarted();
}

final class PortfolioDataRetryRequested extends PortfolioDataEvent {
  const PortfolioDataRetryRequested();
}

final class _ProfileChanged extends PortfolioDataEvent {
  const _ProfileChanged(this.model);
  final PersonalProfile model;
}

final class _EmailJsChanged extends PortfolioDataEvent {
  const _EmailJsChanged(this.model);
  final EmailJsConfiguration model;
}

final class _LinksChanged extends PortfolioDataEvent {
  const _LinksChanged(this.model);
  final PortfolioLinks model;
}

final class _StatsChanged extends PortfolioDataEvent {
  const _StatsChanged(this.model);
  final StatsDocument model;
}

final class _ContactChannelsChanged extends PortfolioDataEvent {
  const _ContactChannelsChanged(this.model);
  final ContactChannelsDocument model;
}

final class _ExperiencesChanged extends PortfolioDataEvent {
  const _ExperiencesChanged(this.models);
  final List<ExperienceItem> models;
}

final class _ProjectsChanged extends PortfolioDataEvent {
  const _ProjectsChanged(this.models);
  final List<PortfolioProject> models;
}

final class _ServicesChanged extends PortfolioDataEvent {
  const _ServicesChanged(this.models);
  final List<ServiceItem> models;
}

final class _SkillGroupsChanged extends PortfolioDataEvent {
  const _SkillGroupsChanged(this.models);
  final List<SkillGroup> models;
}

final class _TestimonialsChanged extends PortfolioDataEvent {
  const _TestimonialsChanged(this.models);
  final List<TestimonialItem> models;
}

final class _PortfolioDataFailed extends PortfolioDataEvent {
  const _PortfolioDataFailed(this.error, {required this.blocksInitialRender});
  final Object error;
  final bool blocksInitialRender;
}

final class _PortfolioBackgroundDataRequested extends PortfolioDataEvent {
  const _PortfolioBackgroundDataRequested();
}

enum PortfolioDataStatus { initial, loading, loaded, failure }

class PortfolioDataState {
  const PortfolioDataState({
    this.status = PortfolioDataStatus.initial,
    PersonalProfile? profile,
    EmailJsConfiguration? emailJs,
    PortfolioLinks? links,
    StatsDocument? statsDocument,
    ContactChannelsDocument? contactChannelsDocument,
    List<ExperienceItem>? experiences,
    List<PortfolioProject>? projects,
    List<ServiceItem>? services,
    List<SkillGroup>? skillGroups,
    List<TestimonialItem>? testimonials,
    this.errorMessage,
  }) : _profile = profile,
       _emailJs = emailJs,
       _links = links,
       _statsDocument = statsDocument,
       _contactChannelsDocument = contactChannelsDocument,
       _experiences = experiences,
       _projects = projects,
       _services = services,
       _skillGroups = skillGroups,
       _testimonials = testimonials;

  final PortfolioDataStatus status;
  final PersonalProfile? _profile;
  final EmailJsConfiguration? _emailJs;
  final PortfolioLinks? _links;
  final StatsDocument? _statsDocument;
  final ContactChannelsDocument? _contactChannelsDocument;
  final List<ExperienceItem>? _experiences;
  final List<PortfolioProject>? _projects;
  final List<ServiceItem>? _services;
  final List<SkillGroup>? _skillGroups;
  final List<TestimonialItem>? _testimonials;
  final String? errorMessage;

  /// The minimum data required to render the home/hero experience.
  bool get isReady => _profile != null && _links != null;

  /// Whether every independently loaded portfolio section has responded.
  bool get isFullyLoaded =>
      isReady &&
      _emailJs != null &&
      _statsDocument != null &&
      _contactChannelsDocument != null &&
      _experiences != null &&
      _projects != null &&
      _services != null &&
      _skillGroups != null &&
      _testimonials != null;

  bool get hasEmailJs => _emailJs != null;
  bool get hasStats => _statsDocument != null;
  bool get hasContactChannels => _contactChannelsDocument != null;
  bool get hasExperiences => _experiences != null;
  bool get hasProjects => _projects != null;
  bool get hasServices => _services != null;
  bool get hasSkillGroups => _skillGroups != null;
  bool get hasTestimonials => _testimonials != null;

  PersonalProfile get profile => _profile!;
  EmailJsConfiguration get emailJs =>
      _emailJs ??
      const EmailJsConfiguration(
        serviceId: '',
        templateId: '',
        publicKey: '',
        nameParameter: '',
        emailParameter: '',
        subjectParameter: '',
        messageParameter: '',
      );
  PortfolioLinks get links => _links!;
  List<StatItem> get stats => _statsDocument?.items ?? const [];
  List<ContactChannel> get contactChannels =>
      _contactChannelsDocument?.items ?? const [];
  List<ExperienceItem> get experiences => _experiences ?? const [];
  List<PortfolioProject> get projects => _projects ?? const [];
  List<ServiceItem> get services => _services ?? const [];
  List<SkillGroup> get skillGroups => _skillGroups ?? const [];
  List<TestimonialItem> get testimonials => _testimonials ?? const [];

  List<SocialLink> get socials =>
      PortfolioLocalContent.socials(links: links, email: profile.email);

  String link(String key) => links.valueFor(key);

  String navigationLabel(String sectionName) {
    return PortfolioLocalContent.navigationLabels.valueFor(sectionName);
  }

  SectionHeading heading(String sectionName) {
    return PortfolioLocalContent.sectionHeadings.valueFor(sectionName);
  }

  String categoryLabel(ProjectCategory category) => category.label;

  PortfolioDataState copyWith({
    PortfolioDataStatus? status,
    PersonalProfile? profile,
    EmailJsConfiguration? emailJs,
    PortfolioLinks? links,
    StatsDocument? statsDocument,
    ContactChannelsDocument? contactChannelsDocument,
    List<ExperienceItem>? experiences,
    List<PortfolioProject>? projects,
    List<ServiceItem>? services,
    List<SkillGroup>? skillGroups,
    List<TestimonialItem>? testimonials,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PortfolioDataState(
      status: status ?? this.status,
      profile: profile ?? _profile,
      emailJs: emailJs ?? _emailJs,
      links: links ?? _links,
      statsDocument: statsDocument ?? _statsDocument,
      contactChannelsDocument:
          contactChannelsDocument ?? _contactChannelsDocument,
      experiences: experiences ?? _experiences,
      projects: projects ?? _projects,
      services: services ?? _services,
      skillGroups: skillGroups ?? _skillGroups,
      testimonials: testimonials ?? _testimonials,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class PortfolioDataBloc extends Bloc<PortfolioDataEvent, PortfolioDataState> {
  PortfolioDataBloc(this._repository) : super(const PortfolioDataState()) {
    on<PortfolioDataStarted>(_onStarted);
    on<PortfolioDataRetryRequested>(_onRetryRequested);
    on<_PortfolioBackgroundDataRequested>(_onBackgroundDataRequested);
    on<_ProfileChanged>(
      (event, emit) => _emitModel(emit, state.copyWith(profile: event.model)),
    );
    on<_EmailJsChanged>(
      (event, emit) => _emitModel(emit, state.copyWith(emailJs: event.model)),
    );
    on<_LinksChanged>(
      (event, emit) => _emitModel(emit, state.copyWith(links: event.model)),
    );
    on<_StatsChanged>(
      (event, emit) =>
          _emitModel(emit, state.copyWith(statsDocument: event.model)),
    );
    on<_ContactChannelsChanged>(
      (event, emit) => _emitModel(
        emit,
        state.copyWith(contactChannelsDocument: event.model),
      ),
    );
    on<_ExperiencesChanged>(
      (event, emit) =>
          _emitModel(emit, state.copyWith(experiences: event.models)),
    );
    on<_ProjectsChanged>(
      (event, emit) => _emitModel(emit, state.copyWith(projects: event.models)),
    );
    on<_ServicesChanged>(
      (event, emit) => _emitModel(emit, state.copyWith(services: event.models)),
    );
    on<_SkillGroupsChanged>(
      (event, emit) =>
          _emitModel(emit, state.copyWith(skillGroups: event.models)),
    );
    on<_TestimonialsChanged>(
      (event, emit) =>
          _emitModel(emit, state.copyWith(testimonials: event.models)),
    );
    on<_PortfolioDataFailed>(_onFailed);
  }

  final PortfolioRepository _repository;
  final List<StreamSubscription<Object?>> _subscriptions = [];
  bool _backgroundStarted = false;

  Future<void> _onStarted(
    PortfolioDataStarted event,
    Emitter<PortfolioDataState> emit,
  ) async {
    await _subscribe(emit);
  }

  Future<void> _onRetryRequested(
    PortfolioDataRetryRequested event,
    Emitter<PortfolioDataState> emit,
  ) async {
    await _subscribe(emit);
  }

  Future<void> _subscribe(Emitter<PortfolioDataState> emit) async {
    emit(state.copyWith(status: PortfolioDataStatus.loading, clearError: true));
    await _cancelSubscriptions();
    _backgroundStarted = false;

    void onError(Object error, StackTrace stackTrace) {
      if (!isClosed) {
        add(_PortfolioDataFailed(error, blocksInitialRender: true));
      }
    }

    _subscriptions.addAll([
      _repository.watchProfile().listen(
        (model) => add(_ProfileChanged(model)),
        onError: onError,
      ),
      _repository.watchLinks().listen(
        (model) => add(_LinksChanged(model)),
        onError: onError,
      ),
    ]);
    if (state.isReady) _scheduleBackgroundData();
  }

  void _onBackgroundDataRequested(
    _PortfolioBackgroundDataRequested event,
    Emitter<PortfolioDataState> emit,
  ) {
    if (_backgroundStarted) return;
    _backgroundStarted = true;

    void onError(Object error, StackTrace stackTrace) {
      if (!isClosed) {
        add(_PortfolioDataFailed(error, blocksInitialRender: false));
      }
    }

    _subscriptions.addAll([
      _repository.watchEmailJsConfiguration().listen(
        (model) => add(_EmailJsChanged(model)),
        onError: onError,
      ),
      _repository.watchStats().listen(
        (model) => add(_StatsChanged(model)),
        onError: onError,
      ),
      _repository.watchServices().listen(
        (models) => add(_ServicesChanged(models)),
        onError: onError,
      ),
      _repository.watchSkillGroups().listen(
        (models) => add(_SkillGroupsChanged(models)),
        onError: onError,
      ),
      _repository.watchContactChannels().listen(
        (model) => add(_ContactChannelsChanged(model)),
        onError: onError,
      ),
      _repository.watchExperiences().listen(
        (models) => add(_ExperiencesChanged(models)),
        onError: onError,
      ),
      _repository.watchProjects().listen(
        (models) => add(_ProjectsChanged(models)),
        onError: onError,
      ),
      _repository.watchTestimonials().listen(
        (models) => add(_TestimonialsChanged(models)),
        onError: onError,
      ),
    ]);
  }

  void _emitModel(Emitter<PortfolioDataState> emit, PortfolioDataState next) {
    final becameReady = !state.isReady && next.isReady;
    emit(
      next.copyWith(
        status: next.isFullyLoaded
            ? PortfolioDataStatus.loaded
            : PortfolioDataStatus.loading,
        clearError: true,
      ),
    );
    if (becameReady) _scheduleBackgroundData();
  }

  void _scheduleBackgroundData() {
    // Give Flutter a frame to paint Home before starting non-critical reads.
    Timer(const Duration(milliseconds: 100), () {
      if (!isClosed) add(const _PortfolioBackgroundDataRequested());
    });
  }

  void _onFailed(_PortfolioDataFailed event, Emitter<PortfolioDataState> emit) {
    if (!event.blocksInitialRender && state.isReady) return;
    emit(
      state.copyWith(
        status: PortfolioDataStatus.failure,
        errorMessage: _messageFor(event.error),
      ),
    );
  }

  String _messageFor(Object error) {
    if (error is PortfolioDataNotFoundException) {
      return 'Required portfolio data is missing from Firestore.';
    }
    if (error is FormatException) {
      return 'The portfolio data in Firestore has an invalid schema.';
    }
    if (error is PortfolioRepositoryInitializationException) {
      return error.message;
    }
    return 'The portfolio data could not be loaded from Firestore.';
  }

  Future<void> _cancelSubscriptions() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }

  @override
  Future<void> close() async {
    await _cancelSubscriptions();
    return super.close();
  }
}
