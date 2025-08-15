import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reel_views/packages/app_ui/app_theme.dart';
import 'package:reel_views/reels/model/post_reel_block.dart';
import 'package:reel_views/reels/reel/widgets/running_text.dart';
import 'package:reel_views/reels/reel/widgets/vertical_button.dart';

class VerticalButtons extends StatelessWidget {
  const VerticalButtons(this.block, {super.key});

  final PostReelBlock block;

  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: const EdgeInsets.only(right: 12, bottom: 94),
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const VerticalGroup(
              icon: Icons.favorite_outline,
              size: 30,
              statisticCount: 30,
            ),

            const SizedBox(height: 16),

            VerticalGroup(
              statisticCount: 2,
              child: SvgPicture.asset(
                'assets/icons/chat_circle.svg',
                width: 30,
                height: 30,
                colorFilter: const ColorFilter.mode(
                  Colors.white, 
                  BlendMode.srcIn
                ),
              )
            ),

            const SizedBox(height: 16),

            const VerticalGroup(
              icon: Icons.near_me_outlined,
              size: 30,
              withStatistic: false,
            ),

           const SizedBox(height: 16),

           const VerticalGroup(
              icon: Icons.more_vert_sharp,
              withStatistic: false,
            ),

           const SizedBox(height: 16),

           Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Colors.white),
                image: DecorationImage(
                  image: ResizeImage.resizeIfNeeded(
                    30, 
                    30, 
                    NetworkImage(block.author.avatarUrl)
                  )
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ReelAuthorListTile extends StatelessWidget {
  const ReelAuthorListTile({
    required this.block,
    super.key
  });

  final PostReelBlock block;

  @override
  Widget build(BuildContext context) {
    final author = block.author;

    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(author.avatarUrl),
        ),

        const SizedBox(width: 8),

        Flexible(
          flex: 4,
          child: Text.rich(
            TextSpan(
              text: author.username
            ),
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white
            ),
            overflow: TextOverflow.ellipsis,
          )
        ),
      ],
    );
  }
}

class ReelCaption extends StatelessWidget {
  const ReelCaption({
    required this.caption,
    super.key
  });

  final String caption;

  @override
  Widget build(BuildContext context) {
    return Text(
      caption,
      style: context.textTheme.titleSmall?.copyWith(),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ReelParticipants extends StatelessWidget {
  const ReelParticipants({required this.participant, super.key});

  final String participant;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 58, 58, 58),
              border: Border.all(color: Color.fromARGB(45, 250, 250, 250)),
              borderRadius: const BorderRadius.all(Radius.circular(16))
            ),
            child: Row(
              children: [
                const Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.music_note_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  )
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 6,
                  child: RunningText(
                    text: '$participant • 原音乐',
                    velocity: 40,
                    style: context.textTheme.bodyMedium?.apply(
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis
                    ),
                  )
                )
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        DecoratedBox(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 58, 58, 58),
            border: Border.all(color: Color.fromARGB(45, 250, 250, 250)),
            borderRadius: const BorderRadius.all(Radius.circular(16))
          ),
          child: Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    participant,
                    style: context.textTheme.bodyMedium?.apply(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}