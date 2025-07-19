part of 'user_profile_bloc.dart';

class UserProfileState extends Equatable {
  const UserProfileState._({
    required this.user,
    required this.followings,
    required this.followers,
    required this.followingsCount,
    required this.followersCount,
  });


  factory UserProfileState.initial() {
    // 👇 假数据
    final mockUser = User(id: 'me', username: '我自己', avatarUrl: null);

    final mockFollowers = List.generate(5, (index) {
      return User(
        id: 'follower_$index',
        username: '粉丝$index号',
        avatarUrl: 'https://picsum.photos/id/237/300/200',
      );
    });

    final mockFollowings = List.generate(3, (index) {
      return User(
        id: 'following_$index',
        username: '关注$index号',
        avatarUrl: 'https://picsum.photos/id/237/300/200',
      );
    });

    return UserProfileState._(
      user: mockUser,
      followers: mockFollowers,
      followings: mockFollowings,
      followersCount: mockFollowers.length,
      followingsCount: mockFollowings.length,
    );
  }

  final User user;
  final List<User> followings;
  final List<User> followers;
  final int followingsCount;
  final int followersCount;

  @override
  List<Object> get props => [
        user,
        followings,
        followers,
        followingsCount,
        followersCount,
  ];

  UserProfileState copyWith({
    User? user,
    List<User>? followings,
    List<User>? followers,
    int? followingsCount,
    int? followersCount,
  }) {
    return UserProfileState._(
      user: user ?? this.user,
      followings: followings ?? this.followings,
      followers: followers ?? this.followers,
      followingsCount: followingsCount ?? this.followingsCount,
      followersCount: followersCount ?? this.followersCount,
    );
  }

}
