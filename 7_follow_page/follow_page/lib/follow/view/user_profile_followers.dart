import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:follow_page/follow/bloc/bloc/user_profile_bloc.dart';
import 'package:follow_page/follow/view/user_profile_list_tile.dart';

class UserProfileFollowers extends StatefulWidget {
  const UserProfileFollowers({super.key});

  @override
  State<UserProfileFollowers> createState() => _UserProfileFollowersState();
}

class _UserProfileFollowersState extends State<UserProfileFollowers> with AutomaticKeepAliveClientMixin {


  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final followers = context.select((UserProfileBloc bloc) => bloc.state.followers);

    return CustomScrollView(
      cacheExtent: 2760,
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
        ),
        SliverList.builder(
          itemCount: followers.length,
          itemBuilder: (context, index) {
            final user = followers[index];
            return UserProfileListTile(user: user, follower: true);
          }
        )
      ],
    );
  }
}