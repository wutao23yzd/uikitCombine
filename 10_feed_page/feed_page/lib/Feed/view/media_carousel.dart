

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:feed_page/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

class MediaCarousel extends StatefulWidget {
  const MediaCarousel({
    required this.media,
    this.onPageChanged,
    this.currentIndex,
    super.key
  });


  final List<String> media;
  final ValueSetter<int>? onPageChanged;
   final ValueNotifier<int>? currentIndex;

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  @override
  Widget build(BuildContext context) {
    return _carousel();
  }

  Widget _carousel() {
  return CarouselSlider.builder(
    itemCount: widget.media.length,
    itemBuilder: (context, index, realIndex) {
      final url = widget.media[index];
      return _MediaCarouseImage(url: url);
    },
    options: CarouselOptions(
      aspectRatio: 1,
      viewportFraction: 1.0,
      enableInfiniteScroll: false,
      onPageChanged: (index, reason) {
        widget.currentIndex?.value = index;
        widget.onPageChanged!(index);
      },
    ),
  );
}
}

class _MediaCarouseImage extends StatelessWidget {
  const _MediaCarouseImage({
    required this.url,
    super.key
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    final thumbnailWidth = min((screenWidth * pixelRatio) ~/ 1, 1920);
    final thumbnailHeight = min((thumbnailWidth * (16 / 9)).toInt(), 1080);
    
    return OctoImage(
      image: CachedNetworkImageProvider(url),
      fit: BoxFit.cover,
      memCacheWidth: thumbnailWidth,
      memCacheHeight: thumbnailHeight
    );
  }
}