

import 'package:feed_page/Feed/model/PostBlock.dart';
import 'package:feed_page/generated/assets.gen.dart';
import 'package:feed_page/packages/app_ui/app_theme.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({
    required this.block,
    this.color,
    super.key
  });

  final PostBlock block;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final author = block.author;
    final color = this.color ?? Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: Colors.white,
                foregroundImage: ResizeImage.resizeIfNeeded(
                  54,
                  54,
                  NetworkImage(author.avatarUrl)//Assets.images.tony.provider(),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${author.username}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: context.textTheme.titleMedium?.apply(color: color),
                      ),
                      Assets.icons.verifiedUser.svg(
                        width: 18,
                        height: 18
                      )
                    ],
                  ),
                  Text(
                    '赞助',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: context.textTheme.bodyMedium?.apply(color: color),
                  )
                ],
              )
            ],
          ),
          Builder(
            builder: (_) {
              return Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 224, 224, 224)),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text(
                        '关注',
                        style: context.textTheme.labelLarge?.apply(color: Colors.black),
                      ),
                    )
                  ),

                  const SizedBox(width: 12),

                  Icon(
                    Icons.more_vert,
                    size: 24,
                    color: color
                  )
                ]
              );
            }
          )
        ],
      ),
    );
  }
}