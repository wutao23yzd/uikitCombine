

import 'package:feed_page/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class FeedAppBar extends StatelessWidget {
  const FeedAppBar({required this.innerBoxIsScrolled, super.key});

  final bool innerBoxIsScrolled;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(right: 12),
      sliver: SliverAppBar(
        centerTitle: false,
        forceElevated: innerBoxIsScrolled,
        title:  Assets.images.instagramTextLogo.svg(
          height: 50,
          width: 50,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(
            Colors.black,
            BlendMode.srcIn,
          ),
        ),
        floating: true,
        snap: true,
        actions: [],
      ),
    );
  }
}