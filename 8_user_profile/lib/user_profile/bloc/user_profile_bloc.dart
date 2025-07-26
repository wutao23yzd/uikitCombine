import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(const UserProfileState.initial()) {
    on<UserProfileEvent>((event, emit) {
     
    });
  }
}
