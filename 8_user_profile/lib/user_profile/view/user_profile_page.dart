import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:user_profile/app/generated/assets.gen.dart';
import 'package:user_profile/packages/app_ui/app_scaffold.dart';
import 'package:user_profile/packages/app_ui/text_style_extension.dart';
import 'package:user_profile/user_profile/bloc/user_profile_bloc.dart';
import 'package:user_profile/user_profile/widgets/empty_post.dart';
import 'package:user_profile/user_profile/widgets/user_profile_app_bar.dart'
    show UserProfileAppBar;
import 'package:user_profile/user_profile/widgets/user_profile_header.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(),
      child: const UserProfileView(),
    );
  }
}

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView>
    with SingleTickerProviderStateMixin {
  late ScrollController _nestedScrollController;

  @override
  void initState() {
    super.initState();
    _nestedScrollController = ScrollController();
  }

  @override
  void dispose() {
    _nestedScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _nestedScrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: MultiSliver(
                  children: [
                    const UserProfileAppBar(),
                    const UserProfileHeader(),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        const TabBar(
                          tabs: [
                            Tab(
                              icon: Icon(Icons.grid_on),
                              iconMargin: EdgeInsets.zero,
                            ),
                            Tab(
                              icon: Icon(Icons.person_outline),
                              iconMargin: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [PostsPage(), UserProfileMentionedPostsPage()],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: 7,
          itemBuilder: (context, index) {
            return PostSmallImage(index: index);
          },
        ),
      ],
    );
  }
}

class PostSmallImage extends StatelessWidget {
  const PostSmallImage({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final screenWidth = (MediaQuery.of(context).size.width - 2.0) / 3;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    final size = min((screenWidth * pixelRatio) ~/ 1, 1920);

    var path = Assets.lib.assets.images.image1.path;
    if (index == 1) {
      path = Assets.lib.assets.images.image2.path;
    } else if (index == 2) {
       path = Assets.lib.assets.images.image3.path;
    } else if (index == 3) {
      path = Assets.lib.assets.images.image4.path;
    } else if (index == 4) {
       path = Assets.lib.assets.images.image5.path;
    }  else if (index == 5) {
      path = Assets.lib.assets.images.image6.path;
    } else if (index == 6) {
       path = Assets.lib.assets.images.image7.path;
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      width: size.toDouble(),
      height: size.toDouble(),
    );
  }
}

class UserProfileMentionedPostsPage extends StatelessWidget {
  const UserProfileMentionedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        const EmptyPosts(icon: Icons.person_pin_outlined),
      ],
    );
  }
}
