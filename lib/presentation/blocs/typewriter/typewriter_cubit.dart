import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class TypewriterState {
  const TypewriterState({
    required this.roles,
    required this.roleIndex,
    required this.characterCount,
    required this.isDeleting,
  });

  final List<String> roles;
  final int roleIndex;
  final int characterCount;
  final bool isDeleting;

  String get visibleText {
    if (roles.isEmpty) return '';
    final role = roles[roleIndex.clamp(0, roles.length - 1)];
    return role.substring(0, characterCount.clamp(0, role.length));
  }
}

class TypewriterCubit extends Cubit<TypewriterState> {
  TypewriterCubit(List<String> roles, {required bool reducedMotion})
    : _reducedMotion = reducedMotion,
      super(_initialState(roles, reducedMotion)) {
    if (!_reducedMotion && roles.isNotEmpty) {
      _schedule(const Duration(milliseconds: 320));
    }
  }

  bool _reducedMotion;
  Timer? _timer;

  static TypewriterState _initialState(List<String> roles, bool reducedMotion) {
    final normalized = List<String>.unmodifiable(
      roles.where((role) => role.isNotEmpty),
    );
    return TypewriterState(
      roles: normalized,
      roleIndex: 0,
      characterCount: reducedMotion && normalized.isNotEmpty
          ? normalized.first.length
          : 0,
      isDeleting: false,
    );
  }

  void replaceRoles(List<String> roles) {
    _timer?.cancel();
    emit(_initialState(roles, _reducedMotion));
    if (!_reducedMotion && state.roles.isNotEmpty) {
      _schedule(const Duration(milliseconds: 320));
    }
  }

  void setReducedMotion(bool reducedMotion) {
    if (_reducedMotion == reducedMotion) return;
    _reducedMotion = reducedMotion;
    _timer?.cancel();
    emit(_initialState(state.roles, reducedMotion));
    if (!reducedMotion && state.roles.isNotEmpty) {
      _schedule(const Duration(milliseconds: 320));
    }
  }

  void _schedule(Duration duration) {
    _timer?.cancel();
    _timer = Timer(duration, _tick);
  }

  void _tick() {
    if (isClosed || _reducedMotion || state.roles.isEmpty) return;
    final role = state.roles[state.roleIndex];

    if (!state.isDeleting && state.characterCount < role.length) {
      emit(
        TypewriterState(
          roles: state.roles,
          roleIndex: state.roleIndex,
          characterCount: state.characterCount + 1,
          isDeleting: false,
        ),
      );
      _schedule(const Duration(milliseconds: 92));
      return;
    }
    if (!state.isDeleting) {
      emit(
        TypewriterState(
          roles: state.roles,
          roleIndex: state.roleIndex,
          characterCount: state.characterCount,
          isDeleting: true,
        ),
      );
      _schedule(const Duration(milliseconds: 1350));
      return;
    }
    if (state.characterCount > 0) {
      emit(
        TypewriterState(
          roles: state.roles,
          roleIndex: state.roleIndex,
          characterCount: state.characterCount - 1,
          isDeleting: true,
        ),
      );
      _schedule(const Duration(milliseconds: 42));
      return;
    }

    emit(
      TypewriterState(
        roles: state.roles,
        roleIndex: (state.roleIndex + 1) % state.roles.length,
        characterCount: 0,
        isDeleting: false,
      ),
    );
    _schedule(const Duration(milliseconds: 240));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
