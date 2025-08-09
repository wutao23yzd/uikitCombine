

import 'package:feed_page/Feed/model/PostBlock.dart';
import 'package:feed_page/Feed/view/carousel_dot_indicator.dart';
import 'package:feed_page/generated/assets.gen.dart';
import 'package:feed_page/packages/app_ui/app_theme.dart';
import 'package:flutter/material.dart';

class PostFooter extends StatelessWidget {
  const PostFooter({
    required this.block,
    required this.indicatorValue,
    super.key
  });

  final PostBlock block;
  final ValueNotifier<int> indicatorValue;

  @override
  Widget build(BuildContext context) {

    final author = block.author;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_outline, size: 30,),

                      const SizedBox(width: 16),

                      Transform.flip(
                        flipX: true,
                        child: Assets.icons.chatCircle.svg(
                          height: 30,
                          width: 30,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      const Icon(
                        Icons.near_me_outlined,
                        size: 30,
                      )
                    ],
                  ),
                )
              ),

              if (block.media.length > 1)
                ValueListenableBuilder(
                  valueListenable: indicatorValue, 
                  builder: (context, index, child) {
                    return CarouselDotIndicator(
                      mediaCount: block.media.length, 
                      activeMediaIndex: index);
                },
            ),

              const Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.bookmark_outline_rounded,
                    size: 30,
                  ),
                )
              )
            ],
          ),
        ),

        const SizedBox(height: 8,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(text: '被 '),
                          TextSpan(
                            text: "美国队长",
                            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
                          ),
                          const TextSpan(text: ' '),
                          const TextSpan(text: '和'),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: "3个其他人",
                            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
                          ),
                           const TextSpan(text: '喜欢'),
                        ]
                      )
                    )
                  )
                ],
              ),

              Text.rich(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "${author.username} ",
                      style: context.textTheme.titleMedium
                    ),
                    TextSpan(
                      text: block.caption,
                      style: context.textTheme.bodyMedium
                    )
                  ]
                )
              ),

              Text(
                '1小时前',
                overflow: TextOverflow.visible,
                style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 8,)
            ],
          ),
        )
      ],
    );
  }
}