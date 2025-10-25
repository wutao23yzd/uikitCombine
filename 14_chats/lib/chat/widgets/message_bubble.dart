import 'package:chats/chat/widgets/message_conent.dart';
import 'package:flutter/material.dart';
import 'package:chats/chat/model/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    this.borderRaidus,
    super.key
  });

  final Message message;
  final BorderRadiusGeometry Function({required bool isMine})? borderRaidus;
  @override
  Widget build(BuildContext context) {

    final message = this.message;
    final isMine = message.sender == null;
    final messageAlignment = isMine ? Alignment.topRight : Alignment.topLeft;

    return GestureDetector(
      child: FractionallySizedBox(
        alignment: messageAlignment,
        widthFactor: 0.85,
        child: Align(
          alignment: messageAlignment,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRaidus?.call(isMine: isMine) ??
                        const BorderRadius.all(Radius.circular(22)),
                  )
              ),
              child: RepaintBoundary(
                child: MessageBubbleContent(
                    message: message
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
