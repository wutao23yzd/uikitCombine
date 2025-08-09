import 'package:feed_page/Feed/widgets/feed_page_controller.dart';
import 'package:feed_page/generated/assets.gen.dart';
import 'package:feed_page/packages/app_ui/app_theme.dart';
import 'package:feed_page/packages/app_ui/viewable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class DividerBlock extends StatefulWidget {
  const DividerBlock({
    required this.feedPageController,
    super.key
  });

  final FeedPageController feedPageController;

  @override
  State<DividerBlock> createState() => _DividerBlockState();
}

class _DividerBlockState extends State<DividerBlock> with SingleTickerProviderStateMixin {
  final _dividerBlockKey = GlobalKey();

  late AnimationController _controller;
  Duration? _animationDuration;

  FeedPageController get feedPageController => widget.feedPageController;
  bool get hasPlayedAnimation => feedPageController.hasPlayedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  void _onLoaded(LottieComposition composition) {
    _animationDuration ??= composition.duration;
    if (hasPlayedAnimation) {
       _controller.value = feedPageController.animationValue;
    }
  }

  void _playAnimation() {
    if (!hasPlayedAnimation) {
      Future<void>.delayed(
        250.ms,
        () => feedPageController.hasPlayedAnimation = true,
      );
      feedPageController.animationValue = 1;
      _controller
        ..duration = _animationDuration
        ..forward();
    };
  }

  void _ensureBlockVisible() {
    if (hasPlayedAnimation) return;
    Scrollable.ensureVisible(
      _dividerBlockKey.currentContext!,
      duration: 450.ms,
      curve: Easing.legacyDecelerate,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _dividerBlockKey,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Viewable(
          itemKey: const ValueKey('dividerBlock_topAnimatedDivider'), 
          onSeen: _ensureBlockVisible,
          child: ListenableBuilder(
            listenable: feedPageController, 
            builder: (_, _) {
              return AnimatedShimmerDivider(
                hasPlayedAnimation: hasPlayedAnimation,
              );
            }
          )
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            children: [
              DefaultTextStyle.merge(
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(color: Colors.black),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Viewable(
                          itemKey: const ValueKey('dividerBLock_invisibleCheckIconBox'), 
                          onSeen: _playAnimation,
                          child: const SizedBox(height: 30, width: 30,)
                        ),
                        Lottie.asset(
                          Assets.animations.checkedAnimation,
                          fit: BoxFit.cover,
                          frameRate: const FrameRate(64),
                          controller: _controller,
                          onLoaded: _onLoaded
                        )
                      ],
                    ),
                    Text(
                      "您都看完了",
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "您已看完过去 3 天的所有新帖子",
                      style: context.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    )
                  ],
                )
              )
            ],
          ),
        ),
        ListenableBuilder(
          listenable: feedPageController, 
          builder: (_, _) {
            return AnimatedShimmerDivider(
              hasPlayedAnimation: hasPlayedAnimation,
            );
          }
        )
      ],
    );
  }
}

class AnimatedShimmerDivider extends StatefulWidget {
  const AnimatedShimmerDivider({
    required this.hasPlayedAnimation,
    super.key
  });

  final bool hasPlayedAnimation;

  @override
  State<AnimatedShimmerDivider> createState() => _AnimatedShimmerDividerState();
}

class _AnimatedShimmerDividerState extends State<AnimatedShimmerDivider> with SingleTickerProviderStateMixin {
  late AnimationController _controller;


  static const primaryGradient = <Color>[
    Color(0xFF833AB4),
    Color(0xFFF77737),
    Color(0xFFE1306C),
    Color(0xFFC13584),
    Color(0xFF833AB4),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant AnimatedShimmerDivider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hasPlayedAnimation != widget.hasPlayedAnimation) {
      _controller.loop(count: 1);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return const Divider(color: Color.fromARGB(255, 224, 224, 224))
        .animate(value: 1, controller: _controller, autoPlay: false)
        .shimmer(
      duration: 2200.ms,
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      colors: [Colors.grey, ...primaryGradient]
    );
  }
}