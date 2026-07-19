import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/domain/repositories/portfolio_repository.dart';
import 'package:portfolio/shared/models/portfolio_models.dart';

sealed class PortfolioContentEvent {
  const PortfolioContentEvent();
}

final class PortfolioContentStarted extends PortfolioContentEvent {
  const PortfolioContentStarted();
}

final class PortfolioContentRetryRequested extends PortfolioContentEvent {
  const PortfolioContentRetryRequested();
}

final class _PortfolioContentReceived extends PortfolioContentEvent {
  const _PortfolioContentReceived(this.content);
  final PortfolioContent content;
}

final class _PortfolioContentFailed extends PortfolioContentEvent {
  const _PortfolioContentFailed(this.error);
  final Object error;
}

enum PortfolioContentStatus { initial, loading, loaded, failure }

class PortfolioContentState {
  const PortfolioContentState({
    this.status = PortfolioContentStatus.initial,
    this.content,
    this.errorMessage,
  });

  final PortfolioContentStatus status;
  final PortfolioContent? content;
  final String? errorMessage;
}

class PortfolioContentBloc
    extends Bloc<PortfolioContentEvent, PortfolioContentState> {
  PortfolioContentBloc(this._repository)
    : super(const PortfolioContentState()) {
    on<PortfolioContentStarted>(_onStarted);
    on<PortfolioContentRetryRequested>(_onRetryRequested);
    on<_PortfolioContentReceived>(_onContentReceived);
    on<_PortfolioContentFailed>(_onContentFailed);
  }

  final PortfolioRepository _repository;
  StreamSubscription<PortfolioContent>? _subscription;

  Future<void> _onStarted(
    PortfolioContentStarted event,
    Emitter<PortfolioContentState> emit,
  ) async {
    await _subscribe(emit);
  }

  Future<void> _onRetryRequested(
    PortfolioContentRetryRequested event,
    Emitter<PortfolioContentState> emit,
  ) async {
    await _subscribe(emit);
  }

  Future<void> _subscribe(Emitter<PortfolioContentState> emit) async {
    emit(
      PortfolioContentState(
        status: PortfolioContentStatus.loading,
        content: state.content,
      ),
    );
    await _subscription?.cancel();
    _subscription = _repository.watchContent().listen(
      (content) {
        if (!isClosed) add(_PortfolioContentReceived(content));
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!isClosed) add(_PortfolioContentFailed(error));
      },
    );
  }

  void _onContentReceived(
    _PortfolioContentReceived event,
    Emitter<PortfolioContentState> emit,
  ) {
    emit(
      PortfolioContentState(
        status: PortfolioContentStatus.loaded,
        content: event.content,
      ),
    );
  }

  void _onContentFailed(
    _PortfolioContentFailed event,
    Emitter<PortfolioContentState> emit,
  ) {
    emit(
      PortfolioContentState(
        status: PortfolioContentStatus.failure,
        content: state.content,
        errorMessage: _messageFor(event.error),
      ),
    );
  }

  String _messageFor(Object error) {
    if (error is PortfolioContentNotFoundException) {
      return 'The portfolio content document is missing from Firestore.';
    }
    if (error is FormatException) {
      return 'The portfolio content in Firestore has an invalid schema.';
    }
    if (error is PortfolioRepositoryInitializationException) {
      return error.message;
    }
    return 'The portfolio content could not be loaded from Firestore.';
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
