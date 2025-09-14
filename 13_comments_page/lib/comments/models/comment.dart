
import 'package:comments_page/comments/models/User.dart';

class Comment {

  const Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.createAt,
    required this.isLiked,
    required this.likesCount,
    this.repliedList
  });

  final String id;

  final PostAuthor author;

  final String content;

  final String createAt;

  final bool isLiked;

  final int likesCount;

  final List<Comment>? repliedList;

  static final commentList = <Comment> [
    Comment(id: "1",
        author: PostAuthor.randomConfirmed(),
        content: "你好",
        isLiked: false,
        likesCount: 0,
        createAt: "1分钟前"),
    Comment(id: "2",
        author: PostAuthor.randomConfirmed(),
        content: "@小明 好有趣啊",
        createAt: "5分钟前",
        isLiked: false,
        likesCount: 8,
        repliedList: [
          Comment(id: "1",
              author: PostAuthor.randomConfirmed(),
              content: "你在说什么",
              createAt: "1分钟前",
              isLiked: true,
              likesCount: 1),
          Comment(id: "1",
              author: PostAuthor.randomConfirmed(),
              content: "他在说你呢",
              createAt: "1分钟前",
              isLiked: false,
              likesCount: 0),
        ]),
    Comment(id: "3",
        author: PostAuthor.randomConfirmed(),
        content: "这里的风景真好看？",
        createAt: "1小时前",
        isLiked: true,
        likesCount: 10,
    ),
    Comment(id: "4",
        author: PostAuthor.randomConfirmed(),
        content: "@小明 好有趣啊",
        createAt: "5分钟前",
        isLiked: false,
        likesCount: 0,
    ),
    Comment(id: "5",
        author: PostAuthor.randomConfirmed(),
        content: "come in @Tom",
        createAt: "1天前",
        isLiked: false,
        likesCount: 0,
    ),
  ];
}