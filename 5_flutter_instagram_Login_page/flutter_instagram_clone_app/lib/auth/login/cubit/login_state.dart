part of 'login_cubit.dart';

typedef LoginErrorMessage = String;

enum LogInSubmissionStatus {

  idle,

  loading,

  success,

  error;

  bool get isSuccess => this == LogInSubmissionStatus.success;
  bool get isLoading => this == LogInSubmissionStatus.loading;
  bool get isError => this == LogInSubmissionStatus.error;
}

final class LoginState extends Equatable {
  const LoginState._({
    required this.status,
    required this.email,
    required this.password,
    required this.showPassword,
    this.message
  });

  const LoginState.initial()
      : this._(
        status: LogInSubmissionStatus.idle,
        email: '', 
        password: '',
        showPassword: false
        );
  
  final LogInSubmissionStatus status;
  final String email;
  final String password;
  final bool showPassword;
  final LoginErrorMessage? message;

  @override
  List<Object?> get props => [status, email, password, showPassword, message];

  LoginState copyWith({
    LogInSubmissionStatus? status,
    String? email,
    String? password,
    bool? showPassword,
    String? message
  }) {
    return LoginState._(
      status: status ?? this.status, 
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      message: message
    );
  }
}

final loginSubmissionStatusMessage =
    <LogInSubmissionStatus, String>{
  LogInSubmissionStatus.error: '请检查是否输入用户名和密码',
};
