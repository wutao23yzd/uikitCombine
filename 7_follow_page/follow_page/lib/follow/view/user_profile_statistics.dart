

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:follow_page/app_scaffold.dart';
import 'package:follow_page/follow/bloc/bloc/user_profile_bloc.dart';
import 'package:follow_page/follow/view/user_profile_followers.dart';
import 'package:follow_page/follow/view/user_profile_following.dart';

class UserProfileStatistics extends StatefulWidget {
  const UserProfileStatistics({
    required this.tabIndex,
    super.key
  });

  final int tabIndex;

  @override
  State<UserProfileStatistics> createState() => _UserProfileStatisticsState();
}

class _UserProfileStatisticsState extends State<UserProfileStatistics> with TickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _tabController.animateTo(widget.tabIndex);
    });

  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: UserProfileStatisticsAppBar(controller: _tabController),
            )
          ];
        }, 
        body: TabBarView(
          controller: _tabController,
          children: [
            UserProfileFollowers(),
            UserProfileFollowing()
          ]
        )
      )
    );
  }
}


class UserProfileStatisticsAppBar extends StatelessWidget {
  const UserProfileStatisticsAppBar({
    required this.controller,
    super.key
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {

    final followers = context.select((UserProfileBloc b) => b.state.followersCount);
    final followings = context.select((UserProfileBloc b) => b.state.followingsCount);
    final user = context.select((UserProfileBloc b) => b.state.user);

    return SliverAppBar(
      pinned: true,
      centerTitle: false,
      title: Text(user.username ?? ""),
      bottom: TabBar(
        indicatorWeight: 1,
        indicatorSize: TabBarIndicatorSize.tab,
        controller: controller,
        labelColor: context.adaptiveColor,
        labelStyle: context.theme.textTheme.bodyLarge,
        labelPadding: EdgeInsets.zero,
        unselectedLabelStyle: context.theme.textTheme.bodyLarge,
        unselectedLabelColor: Colors.grey,
        indicatorColor: context.adaptiveColor,
        tabs: [
          Tab(text: "$followers粉丝"),
          Tab(text: "$followings关注"),
        ],
      ),
    );
  }
}