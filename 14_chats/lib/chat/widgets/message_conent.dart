
import 'package:chats/app_ui/app_theme.dart';
import 'package:chats/chat/model/message.dart';
import 'package:chats/chat/widgets/message_bubble_background.dart';
import 'package:chats/chat/widgets/message_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubbleContent extends StatelessWidget {
  const MessageBubbleContent({
    required this.message,
    super.key
  });

  final Message message;

  @override
  Widget build(BuildContext context) {

    final isMine = message.sender == null;

    final effectiveTextColor = isMine ? Colors.white : Colors.black;

    final hasPost = message.post != null;

    return MessageBubbleBackground(
      colors: [
          if (!isMine) ...[
            Colors.white
          ] else
            ...[
              Color.fromARGB(255, 226, 128, 53),
              Color.fromARGB(255, 228, 96, 182),
              Color.fromARGB(255, 107, 73, 195),
              Color.fromARGB(255, 78, 173, 195),
            ]
        ],
      child: switch (hasPost) {
        true =>
            MessageSharePost(
              message: message,
              effectiveTextColor: effectiveTextColor
            ),
        false =>
            MessageConentView(
              message: message,
              effectiveTextColor: effectiveTextColor,
              isMine: isMine,
            ),
      }
    );
  }
}

class MessageConentView extends StatelessWidget {
  const MessageConentView({
    required this.message,
    required this.effectiveTextColor,
    required this.isMine,
    super.key
  });

  final Message message;
  final Color effectiveTextColor;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextMessageWidget(
                  text: message.message,
                  spacing: 12,
                  textStyle: context.textTheme.bodyLarge?.apply(color: effectiveTextColor),
                  child: MessageStatuses(
                      message: message
                  )
              )
            ],
          ),
        )
      ],
    );
  }
}

class MessageStatuses extends StatelessWidget {
  const MessageStatuses({
    required this.message,
    super.key
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    final isMine = message.sender == null;
    final effectiveSecondaryTextColor = isMine ? Colors.white : Colors.grey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat.Hm.call('zh_CN').format(message.createAt),
          style: context.textTheme.bodySmall?.apply(color: effectiveSecondaryTextColor),
        ),
        SizedBox(width: 4),
        Icon(
          Icons.check,
          size: 18,
          color: effectiveSecondaryTextColor,
        )
      ],
    );
  }
}

class MessageSharePost extends StatelessWidget {
  const MessageSharePost({
    required this.effectiveTextColor,
    required this.message,
    super.key
  });

  final Color effectiveTextColor;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final participant = message.sender;
    final caption = message.caption ?? '';
    final post = message.post ?? '';
    
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              horizontalTitleGap: 8,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                foregroundImage: ResizeImage.resizeIfNeeded(
                    156,
                    156,
                    NetworkImage(participant?.avatarUrl ?? "")
                ),
              ),
              title: Text(
                participant?.username ?? '',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: effectiveTextColor
                ),
              ),
            ),
            MessagePostImage(name: post),
            if (caption.trim().isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text.rich(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: message.sender?.username,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: effectiveTextColor
                        )
                      ),
                      const WidgetSpan(
                          child: SizedBox(width: 4)
                      ),
                      TextSpan(
                        text: caption,
                        style: context.textTheme.bodyLarge?.apply(color: effectiveTextColor)
                      )
                    ]
                  )
                ),
              )

          ],
        ),
        Positioned.fill(
          right: 12,
          bottom: 4,
          child: Align(
            alignment: Alignment.bottomRight,
            child: MessageStatuses(message: message),
          )
        )
      ],
    );
  }
}

class MessagePostImage extends StatelessWidget {
  const MessagePostImage({
    required this.name,
    super.key
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final ctx_screenWidth = MediaQuery.of(context).size.width;
    final screenWidth = (ctx_screenWidth * .85) - 12 * 2;
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);

    final thumbnailWidth = (screenWidth * pixelRatio) ~/ 1;
    return AspectRatio(
      aspectRatio: 1,
      child: Image.asset(
        name,
        fit: BoxFit.cover,
        width: thumbnailWidth.toDouble(),
        height: thumbnailWidth.toDouble(),
      ),
    );
  }

}






