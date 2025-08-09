
import 'package:feed_page/Feed/view/media_carousel.dart';
import 'package:feed_page/packages/app_ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PostMedia extends StatefulWidget {
  const PostMedia({
    required this.media,
    this.onPageChanged,
    this.autoHideCurrentIndex = false,
    super.key
  });

  final List<String> media;
  final ValueSetter<int>? onPageChanged;
  final bool autoHideCurrentIndex;

  @override
  State<PostMedia> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PostMedia> {

  bool get singleImage => widget.media.length == 1;
  bool get showMediaCount => !singleImage && widget.media.isNotEmpty;

  late ValueNotifier<int> _currentIndex;
  late ValueNotifier<bool> _showMediaCount;

  @override
  void initState() {
    super.initState();
    _currentIndex = ValueNotifier(0);
    _showMediaCount = ValueNotifier(!widget.autoHideCurrentIndex);
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    _showMediaCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final carousel = MediaCarousel(
      media: widget.media,
      onPageChanged: widget.onPageChanged,
      currentIndex: _currentIndex,
    );

    return Stack(
      children: [
        carousel,

      if (showMediaCount)
        _MediaCount(
          currentIndex: _currentIndex,
          showMediaCount: _showMediaCount, 
          meida: widget.media, 
          autoHideCurrentIndex: widget.autoHideCurrentIndex
        ),
      ],
    );
  }
}



class _MediaCount extends StatefulWidget {
  const _MediaCount({
    required this.currentIndex,
    required this.showMediaCount,
    required this.meida,
    required this.autoHideCurrentIndex
  });

  final ValueNotifier<int> currentIndex;
  final ValueNotifier<bool> showMediaCount;
  final List<String> meida;
  final bool autoHideCurrentIndex;

  @override
  State<_MediaCount> createState() => _MeidaWidgetState();
}

class _MeidaWidgetState extends State<_MediaCount> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      right: 12,
      child: AnimatedBuilder(
        animation: Listenable.merge([widget.showMediaCount, widget.currentIndex]), 
        builder: (context, child) {
          if(widget.autoHideCurrentIndex) {
            widget.showMediaCount.value = false;
          }
          return RepaintBoundary(
            child: _CurrentPostImageIndexOfTotal(
              total: widget.meida.length,
              currentIndex: widget.currentIndex.value + 1,
              showText: widget.showMediaCount.value,
            ),
          );
        }
      )
    );
  }
}

class _CurrentPostImageIndexOfTotal extends StatelessWidget {
  const _CurrentPostImageIndexOfTotal({
   required this.total,
   required this.currentIndex,
   required this.showText
  });

  final int currentIndex;
  final int total;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final text = '$currentIndex/$total';

    return AnimatedOpacity(
      opacity: showText ? 1 : 0, 
      duration: 150000.microseconds,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 12
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.black.withOpacity(0.8),
        ),
        child: Text(
          text,
          style: context.textTheme.bodyMedium?.apply(color: Colors.white),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}