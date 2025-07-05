import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_instagram_clone_app/auth/login/cubit/login_cubit.dart';
import 'package:flutter_instagram_clone_app/auth/login/model/user.dart';
import 'package:flutter_instagram_clone_app/packages/authRepository/auth_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository,
        super(const AppState.unauthenticated()) {
    on<AppLogoutRequested>(_onAppLogoutRequested);
    on<AppUserChanged>(_onUserChanged);

    _userSub = _authRepository.user.listen(_userChanged, onError: addError);
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User> _userSub;

  void _userChanged(User user) => add(AppUserChanged(user));
  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final user = event.user;
    switch (state.status) {
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
        return user == User.empty
            ? emit(const AppState.unauthenticated())
            : emit(AppState.authenticated(user));
    }
  }

  Future<void> _onAppLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) async {
     await _authRepository.logout();
  }

  @override
  Future<void> close() {
    _userSub.cancel();
    return super.close();
  }
}
