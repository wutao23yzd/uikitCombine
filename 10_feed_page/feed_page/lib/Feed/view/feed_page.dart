import 'package:feed_page/Feed/bloc/feed_bloc.dart';
import 'package:feed_page/Feed/view/post_large.dart';
import 'package:feed_page/Feed/widgets/divider_block.dart';
import 'package:feed_page/Feed/widgets/feed_app_bar.dart';
import 'package:feed_page/Feed/widgets/feed_page_controller.dart';
import 'package:feed_page/packages/app_ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return const FeedView();
  }
}

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(const FeedRecommendedPostsPageRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: FeedAppBar(innerBoxIsScrolled: innerBoxIsScrolled),
              ),
            ];
          },
          body: const FeedBody(),
        ),
      ),
    ).withSystemNavigationBarTheme();
  }
}

class FeedBody extends StatelessWidget {
  const FeedBody({super.key});

  @override
  Widget build(BuildContext context) {
    final feedPageController = FeedPageController();

    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.blocks.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index >= state.blocks.length) {
              return DividerBlock(feedPageController: feedPageController);
            } else {
              final block = state.blocks[index];
              return PostLarge(block: block);
            }
          },
        );
      },
    );
  }
}
