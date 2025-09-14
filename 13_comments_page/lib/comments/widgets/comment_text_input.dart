import 'package:comments_page/app_ui/app_theme.dart';
import 'package:comments_page/comments/view/comments_page.dart';
import 'package:flutter/material.dart';

class CommentTextField extends StatefulWidget {
  const CommentTextField({
    required this.controller,
    super.key
  });

  final DraggableScrollableController controller;

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  List<String> get commentEmojies =>
      ['🩷', '🙌', '🔥', '👏🏻', '😢', '😍', '😮', '😂'];
  @override
  Widget build(BuildContext context) {

    final commentInputController = CommentsPage.of(context).commentInputController;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListenableBuilder(
              listenable: commentInputController,
              builder: (context, child) {
                return Offstage(
                  offstage: !commentInputController.isReplying,
                  child: ListTile(
                    tileColor: Color.fromARGB(255, 224, 224, 224),
                    title: Text(
                      "回复：${commentInputController.replyingUsername ?? "未知"}",
                      style: context.textTheme.bodyMedium?.apply(color: Colors.grey),
                    ),
                    trailing: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: commentInputController.clear,
                      child: const Icon(Icons.cancel, color: Colors.grey),
                    ),
                  ),
                );
              }
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: commentEmojies.map(
                      (emoji) => Flexible(
                          child: FittedBox(
                            child: TextEmoji(
                              emoji: emoji,
                              onEmojiTap: commentInputController.onEmojiTap,
                            ),
                          ),
                      ),
                  ).toList(),
                ),
                SafeArea(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    titleAlignment: ListTileTitleAlignment.titleHeight,
                    horizontalTitleGap: 12,
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundImage: ResizeImage.resizeIfNeeded(
                          null,
                          null,
                          NetworkImage("https://img.freepik.com/free-photo/3d-rendering-zoom-call-avatar_23-2149556778.jpg?size=626&ext=jpg")
                      ),
                    ),
                    subtitle: TextFormField(
                      controller: commentInputController.commentTextController,
                      focusNode: commentInputController.commentFocusNode,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.newline,
                      autofillHints: const [AutofillHints.username],
                      style: TextStyle(
                        color: Colors.black
                      ),
                      decoration: InputDecoration(
                        hintText: "添加评论",
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide.none
                        ),
                        contentPadding: EdgeInsets.zero
                      ),
                    ),
                    trailing: ListenableBuilder(
                        listenable: commentInputController.commentTextController,
                        builder: (context, _) {
                          if (commentInputController.commentTextController.text.trim().isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (commentInputController.commentTextController.value.text.isEmpty) {
                                return;
                              }
                            },
                            child: Text(
                              '发布',
                              style: context.textTheme.bodyLarge?.apply(color: Color(0xFF3898EC)),
                            ),
                          );
                        }
                    ),
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TextEmoji extends StatelessWidget {
  const TextEmoji({
    required this.emoji,
    required this.onEmojiTap,
    super.key
  });

  final String emoji;
  final ValueSetter<String> onEmojiTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onEmojiTap(emoji),
      child: Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Text(
          emoji,
          style: context.textTheme.displayMedium,
        ),
      ),
    );
  }
}

