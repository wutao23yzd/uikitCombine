import 'package:comments_page/app_ui/app_theme.dart';
import 'package:comments_page/comments/models/comment.dart';
import 'package:comments_page/comments/view/comments_page.dart';
import 'package:flutter/material.dart';

class UserComment extends StatelessWidget {
  const UserComment({
    required this.comment,
    required this.isReplied,
    super.key
  });

  final Comment comment;
  final bool isReplied;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        right: 12,
        left: isReplied ? 64 : 12
      ),
      horizontalTitleGap: 12,
      titleAlignment: ListTileTitleAlignment.titleHeight,
      isThreeLine: true,
      leading: CircleAvatar(
        radius: 18,
        backgroundImage: ResizeImage.resizeIfNeeded(
            108,
            108,
            NetworkImage(comment.author.avatarUrl)
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${comment.author.username} ',
            style: context.textTheme.labelLarge?.copyWith(color: Colors.black),
          ),
          Text(
            comment.createAt,
            overflow: TextOverflow.visible,
            style: context.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: buildHighlightedText(comment, context),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              final commentInputController =
                  CommentsPage.of(context).commentInputController;
              commentInputController.setReplyingTo(
                  commentId:  comment.id,
                  username: comment.author.username);
            },
            child:  Text(
              '回复',
              style: context.textTheme.labelMedium?.copyWith(color: Colors.grey),
            ),
          )

        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            comment.isLiked ? Icons.favorite : Icons.favorite_outline,
            color: comment.isLiked ? Colors.red : Colors.grey,
            size: 22
          ),
          Text(
            "${comment.likesCount}",
            style: context.textTheme.titleMedium?.copyWith(
              color: Colors.grey,
              fontSize: 14,
              overflow: TextOverflow.visible
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

List<String> getAllMentions(String text) {
  final regexp = RegExp(r'@[a-zA-Z0-9\p{L}\p{N}_.-]+', unicode: true);

  final mentions = <String>[];

  regexp.allMatches(text).forEach((match) {
    if (match.group(0) == null) return;
    mentions.add(match.group(0)!);
  });

  return mentions;
}

String cleanText(String text) {
  text = text.replaceAllMapped(
      RegExp(r'[\w\u4e00-\u9fa5]@+', unicode: true),
      (m) => "${m[0]?.split('').join(" ")}"
  );

  return text;
}

RichText buildHighlightedText(Comment comment, BuildContext context) {
  final commentMessage = cleanText(comment.content);

  final validMentions = <String>['@'];

  final mentions = getAllMentions(commentMessage);

  final textSpans = <TextSpan>[];
  final userIds = <String, String>{};

  commentMessage.split(' ').forEach((value) {
    if (mentions.contains(value) &&
        value.characters.contains(validMentions.first)) {
        userIds.putIfAbsent(value, () => value);
        textSpans.add(
          TextSpan(
            text: '$value ',
            style: context.textTheme.bodySmall?.copyWith(
              color: Color.fromARGB(255, 100, 181, 246),
              fontWeight: FontWeight.w700
            )
          )
        );
    } else {
      textSpans.add(TextSpan(
          text: '$value ',
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.black
          ))
      );
    }
  });

  return RichText(text: TextSpan(children: textSpans));
}
