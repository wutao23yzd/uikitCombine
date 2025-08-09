part of 'user_profile_bloc.dart';

class User {
  const User({required this.name, required this.fullName});

  final String name;
  final String fullName;
}

class UserProfileState extends Equatable {
  const UserProfileState._({
    required this.user,
    required this.postsCount,
    required this.followingsCount,
    required this.followersCount
  });

  const UserProfileState.initial()
    : this._(
        user:  const User(name: '钢铁侠', fullName: '钢铁侠·斯塔克'),
        postsCount: 7,
        followersCount: 10,
        followingsCount: 20
      );

  final User user;  
  final int postsCount;
  final int followingsCount;
  final int followersCount;

    @override
  List<Object> get props => [
    user,
    postsCount,
    followingsCount,
    followersCount,
  ];

  UserProfileState copyWith({
    User? user,
    int? postsCount,
    int? followingsCount,
    int? followersCount
  }) {
    return UserProfileState._(
      user: user ?? this.user,
      postsCount: postsCount ?? this.postsCount,
      followingsCount: followingsCount ?? this.followingsCount,
      followersCount: followersCount ?? this.followersCount
    );
  }

}
