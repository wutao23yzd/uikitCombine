

import 'package:feed_page/Feed/model/PostBlock.dart';
import 'package:feed_page/Feed/view/media_carousel.dart';
import 'package:feed_page/Feed/view/post_footer.dart';
import 'package:feed_page/Feed/view/post_header.dart';
import 'package:feed_page/Feed/view/post_media.dart';
import 'package:feed_page/packages/app_ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PostLarge extends StatefulWidget {
  const PostLarge({
    required this.block,
    super.key
  });

  final PostBlock block;
  @override
  State<PostLarge> createState() => _PostLargeState();
}

class _PostLargeState extends State<PostLarge> {
  late ValueNotifier<int> _indicatorValue;

  @override
  void initState() {
    super.initState();
    _indicatorValue = ValueNotifier(0);
  }

  @override
  void dispose() {
    _indicatorValue.dispose();
    super.dispose();
  }

  void _updateCurrentIndex(int index) => _indicatorValue.value = index;

  @override
  Widget build(BuildContext context) {

    Widget postHeader({Color? color}) => PostHeader(
      block: widget.block,
      color: color,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        postHeader(),
        PostMedia(
          media: widget.block.media,
          onPageChanged: _updateCurrentIndex,
        ),
        PostFooter(
          block: widget.block,
          indicatorValue: _indicatorValue,
        )
      ],
    );
  }
}