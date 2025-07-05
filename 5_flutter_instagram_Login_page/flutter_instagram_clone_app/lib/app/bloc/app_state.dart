part of 'app_bloc.dart';


enum AppStatus {

  authenticated,

  unauthenticated,
}

class AppState extends Equatable {
  const AppState({
    this.user = User.empty,
    this.status = AppStatus.unauthenticated,
  });

  const AppState.authenticated(User user)
      : this(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated()
      : this(status: AppStatus.unauthenticated, user: User.empty);

  final AppStatus status;
  final User user;

  AppState copyWith({
    User? user,
    AppStatus? status,
  }) {
    return AppState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status, user];
}
