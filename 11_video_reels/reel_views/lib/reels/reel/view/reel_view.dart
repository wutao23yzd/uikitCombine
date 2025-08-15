

import 'package:flutter/material.dart';
import 'package:reel_views/reels/model/post_reel_block.dart';
import 'package:reel_views/reels/reel/widgets/inline_video.dart';
import 'package:reel_views/reels/reel/widgets/num_duration_extension.dart';
import 'package:reel_views/reels/reel/widgets/video_info.dart';
import 'package:video_player/video_player.dart';

class Reel extends StatefulWidget {
  const Reel({
    required this.block,
    required this.play,
    super.key
  });

  final PostReelBlock block;
  final bool play;

  @override
  State<Reel> createState() => _ReelState();
}

class _ReelState extends State<Reel> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.block.media);
  }

  @override
  void dispose() {
    _videoController
      .pause()
      .then((_) => Future<void>.delayed(2.seconds, _videoController.dispose));


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final block = widget.block;

    return Stack(
      children: [
        InlineVideo(
          shouldPlay: widget.play, 
          videoPlayerController: _videoController,
          stackedWidget: Stack(
            children: [
              VerticalButtons(block),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 94,
                  left: 16
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      width:  MediaQuery.sizeOf(context).width * 0.8
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReelAuthorListTile(block: block),
                        const SizedBox(height: 12),
                        ReelCaption(caption: block.caption),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 32,
                          child: ReelParticipants(
                            participant: block.author.username
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}