
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:follow_page/follow/bloc/bloc/user_profile_bloc.dart';
import 'package:follow_page/follow/view/user_profile_list_tile.dart';

class UserProfileFollowing extends StatefulWidget {
  const UserProfileFollowing({super.key});

  @override
  State<UserProfileFollowing> createState() => _UserProfileFollowingState();
}

class _UserProfileFollowingState extends State<UserProfileFollowing> with AutomaticKeepAliveClientMixin {


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final followings = context.select((UserProfileBloc bloc) => bloc.state.followings);

    return CustomScrollView(
      cacheExtent: 2760,
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
        ),
        SliverList.builder(
          itemCount: followings.length,
          itemBuilder: (context, index) {
            final user = followings[index];
            return UserProfileListTile(user: user, follower: false);
          }
        )
      ],
    );
  }

}