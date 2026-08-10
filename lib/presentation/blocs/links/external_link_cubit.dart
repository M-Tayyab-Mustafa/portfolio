import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/core/utils/link_launcher.dart';

class ExternalLinkState {
  const ExternalLinkState({this.feedbackId = 0, this.failureMessage});

  final int feedbackId;
  final String? failureMessage;
}

class ExternalLinkCubit extends Cubit<ExternalLinkState> {
  ExternalLinkCubit() : super(const ExternalLinkState());

  Future<void> open({
    required String url,
    required String label,
    required String failureTemplate,
  }) async {
    final opened = await LinkLauncher.open(url);
    if (opened || isClosed) return;
    emit(
      ExternalLinkState(
        feedbackId: state.feedbackId + 1,
        failureMessage: failureTemplate.replaceAll('{label}', label),
      ),
    );
  }

  Future<void> download({
    required String url,
    required String label,
    required String failureTemplate,
  }) async {
    final downloaded = await LinkLauncher.download(url);
    if (downloaded || isClosed) return;
    emit(
      ExternalLinkState(
        feedbackId: state.feedbackId + 1,
        failureMessage: failureTemplate.replaceAll('{label}', label),
      ),
    );
  }
}
