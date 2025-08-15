import 'package:flutter/material.dart';
import 'package:reel_views/reels/reel/widgets/num_duration_extension.dart';
import 'package:video_player/video_player.dart';

class InlineVideo extends StatefulWidget {
  const InlineVideo({
    required this.shouldPlay,
    required this.stackedWidget,
    required this.videoPlayerController,
    super.key
  });

  final bool shouldPlay;
  final Widget stackedWidget;
  final VideoPlayerController videoPlayerController;

  @override
  State<InlineVideo> createState() => _InlineVideoState();
}

class _InlineVideoState extends State<InlineVideo> with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initialzeController();
  }

  @override
  void didUpdateWidget(covariant InlineVideo oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.shouldPlay == widget.shouldPlay) {
      return;
    }
    _togglePlayer();
  }

  void _initialzeController() {
    _controller = widget.videoPlayerController;
    _controller.initialize().then((_) async {
      if (!mounted) return;
      setState(_togglePlayer);
    });
  }

  void _togglePlayer() {
    void enablePlayer() {
      _controller
        ..play()
        ..setLooping(true);
    }

    if (widget.shouldPlay) {
      return enablePlayer();
    } else {
      _controller
        ..pause()
        ..seekTo(Duration.zero);
    }
  }

  @override
  void dispose() {
    _controller
    .pause()
    .then((_) => Future<void>.delayed(2.seconds, _controller.dispose));
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
          children: [
            Align(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child:VideoPlayer(_controller)
              ),
            ),
            widget.stackedWidget
          ],
        );
  }
}