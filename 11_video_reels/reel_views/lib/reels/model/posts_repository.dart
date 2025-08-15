

import 'package:reel_views/reels/model/post_reel_block.dart';

class PostsRepository {

  static final recommendedReels = [
    PostReelBlock(
      author: PostAuthor.randomConfirmed(),
      id: "1", 
      caption: "送你一朵小红花", 
      media: 'assets/video/Butterfly-209.mp4'
    ),

    PostReelBlock(
      author: PostAuthor.randomConfirmed(),
      id: "2", 
      caption: "风景这边独好", 
      media: 'assets/video/fj1.mp4'
    ),

    PostReelBlock(
      author: PostAuthor.randomConfirmed(),
      id: "3", 
      caption: "出去散散心", 
      media: 'assets/video/fj2.mp4'
    ),

    PostReelBlock(
      author: PostAuthor.randomConfirmed(),
      id: "4", 
      caption: "今天的天气真好", 
      media: 'assets/video/fj3.mp4'
    ),
  ];
}