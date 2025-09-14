import 'package:comments_page/comments/models/comment.dart';
import 'package:comments_page/comments/widgets/user_comment.dart';
import 'package:flutter/material.dart';

class CommentView extends StatelessWidget {
  const CommentView({
    required this.comment,
    required this.isReplied,
    super.key
  });

  final Comment comment;
  final bool isReplied;

  @override
  Widget build(BuildContext context) {
    return CommentGroup(comment: comment, isReplied: isReplied);
  }
}

class CommentGroup extends StatelessWidget {
  const CommentGroup({
    required this.comment,
    required this.isReplied,
    super.key
  });

  final Comment comment;
  final bool isReplied;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserComment(
            comment: comment,
            isReplied: isReplied,
        ),
        if (!isReplied) RepliedComments(comment: comment)
      ],
    );
  }
}

class RepliedComments extends StatefulWidget {
  const RepliedComments({
    required this.comment,
    super.key
  });

  final Comment comment;

  @override
  State<RepliedComments> createState() => _RepliedCommentsState();
}

class _RepliedCommentsState extends State<RepliedComments> {
  @override
  Widget build(BuildContext context) {

    final List<Comment>? repliedComments = widget.comment.repliedList;
    if (repliedComments == null) return const SizedBox.shrink();
    return Column(
      children: repliedComments
          .map((repliedComment) {
            return CommentView(comment: repliedComment, isReplied: true);
        }
      ).toList()
    );
  }
}

