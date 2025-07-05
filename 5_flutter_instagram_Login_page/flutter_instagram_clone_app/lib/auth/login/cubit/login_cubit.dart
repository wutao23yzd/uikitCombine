import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_instagram_clone_app/packages/authRepository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    {required AuthRepository authRepository}
  ) : _authRepository = authRepository,
      super(const LoginState.initial());

  final AuthRepository _authRepository;
  void changePasswordVisibility() => emit(state.copyWith(showPassword: !state.showPassword));

  void onEmailChanged(String newValue) {
      final newScreenState = state.copyWith(email: newValue);
      emit(newScreenState);
  }

  void onEmailUnfocused() {

  }

  void onPasswordChanged(String newValue) {
      final newScreenState = state.copyWith(password: newValue);
      emit(newScreenState);
  }

  void onPasswordUnfocused() {

  }

  void idle() {
    const initialState = LoginState.initial();
    emit(initialState);
  }

  Future<void> submit() async {
    emit(state.copyWith(status: LogInSubmissionStatus.idle));
    if (state.email.isEmpty || state.password.isEmpty) {
        emit(state.copyWith(
          status: LogInSubmissionStatus.error,
          message: 'Email and password cannot be empty',
        ));
      return;
    }

    final newState = state.copyWith(status: LogInSubmissionStatus.loading);
    emit(newState);

    try {
      await _authRepository.login(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LogInSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(
        status: LogInSubmissionStatus.error,
        message: 'Login failed, please try again.',
      ));
    }
  }

}
