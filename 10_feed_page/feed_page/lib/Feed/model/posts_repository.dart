
import 'dart:math' as math;
import 'package:feed_page/Feed/model/PostBlock.dart';

class PostsRepository {
  static final recommendedPosts = <PostBlock>[
    PostBlock(
      id: "0", 
      author: PostAuthor.randomConfirmed(),
      media: ['https://img.freepik.com/free-photo/morskie-oko-tatry_1204-510.jpg?size=626&ext=jpg'], 
      caption: '你好，世界'),

    PostBlock(
      id: "1", 
      author: PostAuthor.randomConfirmed(), 
      media: [
        'https://img.freepik.com/free-photo/magical-shot-dolomite-mountains-fanes-sennes-prags-national-park-italy-during-summer_181624-43445.jpg?size=626&ext=jpg',
        'https://img.freepik.com/free-photo/morskie-oko-tatry_1204-510.jpg?size=626&ext=jpg'
        ], 
      caption: '送你一朵小红花🌹，奖励你有勇气主动来和我说话'),

    PostBlock(
      id: "2", 
      author: PostAuthor.randomConfirmed(), 
      media: ['https://img.freepik.com/free-photo/landscape-morning-fog-mountains-with-hot-air-balloons-sunrise_335224-794.jpg?size=626&ext=jpg'], 
      caption: '愿世界和平'
    ),

    PostBlock(
      id: "3", 
      author: PostAuthor.randomConfirmed(), 
      media: ['https://img.freepik.com/premium-photo/clouds-is-top-wooden-boat-crystal-lake-with-majestic-mountain-reflection-water-chapel-is-right-coast_146671-14200.jpg?size=626&ext=jpg'], 
      caption: '你好，世界'
    ),

  ];
}