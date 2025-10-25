import 'package:chats/app_ui/app_theme.dart';
import 'package:chats/chat/bloc/chat_bloc.dart';
import 'package:chats/chat/model/User.dart';
import 'package:chats/chat/model/message.dart';
import 'package:chats/chat/widgets/message_bubble.dart';
import 'package:chats/chat/widgets/message_input_controller.dart';
import 'package:chats/chat/widgets/message_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(const ChatMessagesRequested()),
      child: ChatView(),
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late MessageInputController _messageInputController;
  late FocusNode _focusNode;

  late ItemScrollController _itemScrollController;
  late ItemPositionsListener _itemPositionsListener;
  late ScrollOffsetController _scrollOffsetController;
  late ScrollOffsetListener _scrollOffsetListener;

  @override
  void initState() {
    super.initState();
    _messageInputController = MessageInputController();
    _focusNode = FocusNode();

    _itemScrollController = ItemScrollController();
    _itemPositionsListener = ItemPositionsListener.create();
    _scrollOffsetController = ScrollOffsetController();
    _scrollOffsetListener = ScrollOffsetListener.create();
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: ChatAppBar(participant: User.mock),
        body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: BlocBuilder<ChatBloc, ChatState>(
                        builder: (context, state) {

                          final messages = state.messages;
                          return ChatMessagesListView(
                              messages: messages,
                            itemScrollController: _itemScrollController,
                            itemPositionsListener: _itemPositionsListener,
                            scrollOffsetController: _scrollOffsetController,
                            scrollOffsetListener: _scrollOffsetListener,
                          );
                        }
                    )
                ),
                ChatMessageTextField(
                    itemScrollController: _itemScrollController,
                    focusNode: _focusNode,
                    messageInputController: _messageInputController
                )
              ],
            )
        ),
      ).withSystemNavigationBarTheme(context),
    );
  }
}

class ChatMessagesListView extends StatefulWidget {
  const ChatMessagesListView({
    required this.messages,
    required this.itemScrollController,
    required this.itemPositionsListener,
    required this.scrollOffsetController,
    required this.scrollOffsetListener,
    super.key
  });

  final List<Message> messages;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final ScrollOffsetController scrollOffsetController;
  final ScrollOffsetListener scrollOffsetListener;

  @override
  State<ChatMessagesListView> createState() => _ChatMessagesListViewState();
}

class _ChatMessagesListViewState extends State<ChatMessagesListView> {
  late ValueNotifier<bool> _showScrollToBottom;

  List<Message> get messages => widget.messages;

  @override
  void initState() {
    super.initState();
    _showScrollToBottom = ValueNotifier(false);

    didUpdateWidget(widget);
  }

  @override
  void dispose() {
    _showScrollToBottom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/chat_background_light_overlay.png'),
              fit: BoxFit.cover,
            )
        ),
        NotificationListener(
            onNotification: (notification) {
              if (notification is UserScrollNotification) {
                if (notification.direction == ScrollDirection.forward) {
                  _showScrollToBottom.value = false;
                } else if (notification.direction == ScrollDirection.reverse) {
                  _showScrollToBottom.value = true;
                }
              }

              return false;
            },
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: ScrollablePositionedList.separated(
                      itemCount: messages.length,
                      reverse: true,
                      itemScrollController: widget.itemScrollController,
                      itemPositionsListener: widget.itemPositionsListener,
                      scrollOffsetController: widget.scrollOffsetController,
                      scrollOffsetListener: widget.scrollOffsetListener,
                      itemBuilder: (context, index) {

                        final isFirst = messages.length - 1 - index == messages.length - 1;
                        final isLast = messages.length - 1 - index <= 0;
                        final isPreviousLast = messages.length - index > messages.length - 1;

                        final message = messages[messages.length - 1 - index];
                        final nextMessage = isLast ? null : messages[messages.length - 2 - index];
                        final previousMessage = isPreviousLast ? null : messages[messages.length - index];

                        final isNextUserSame = nextMessage != null && message.sender?.id == nextMessage.sender?.id;
                        final isPreviousUserSame = previousMessage != null && message.sender?.id == previousMessage.sender?.id;

                        bool checkTimeDifference(DateTime date1, DateTime date2) {
                          return !Jiffy.parseFromDateTime(date1).isSame(Jiffy.parseFromDateTime(date2), unit: Unit.minute);
                        }

                        var hasTimeDifferenceWithNext = false;
                        if (nextMessage != null) {
                          hasTimeDifferenceWithNext = checkTimeDifference(message.createAt, nextMessage.createAt);
                        }

                        var hasTimeDifferenceWithPrevious = false;
                        if (previousMessage != null) {
                          hasTimeDifferenceWithPrevious = checkTimeDifference(message.createAt, previousMessage.createAt);
                        }

                        final padding = isFirst
                            ? const EdgeInsets.only(bottom: 12)
                            : isLast
                                ? const EdgeInsets.only(top: 12)
                                : null;

                        final messageWidget = MessageBubble(
                          key: ValueKey(message.id),
                          message: message,
                          borderRaidus: ({ required isMine }) {
                            return BorderRadius.only(
                              topLeft: isMine
                                  ? const Radius.circular(22)
                                  : (isNextUserSame && !hasTimeDifferenceWithNext)
                                  ? const Radius.circular(4)
                                  : const Radius.circular(22),
                              topRight: !isMine
                                  ? const Radius.circular(22)
                                  : (isNextUserSame && !hasTimeDifferenceWithNext)
                                  ? const Radius.circular(4)
                                  : const Radius.circular(22),
                              bottomLeft: isMine
                                  ? const Radius.circular(22)
                                  : (isPreviousUserSame &&
                                  !hasTimeDifferenceWithPrevious)
                                  ? const Radius.circular(4)
                                  : Radius.zero,
                              bottomRight: !isMine
                                  ? const Radius.circular(22)
                                  : (isPreviousUserSame &&
                                  !hasTimeDifferenceWithPrevious)
                                  ? const Radius.circular(4)
                                  : Radius.zero,
                            );
                          },
                        );
                        return Padding(
                          padding: padding ?? EdgeInsets.zero,
                          child: messageWidget,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8);
                      }),
                )
              ],
            )
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _showScrollToBottom,
          child: ScrollToBottomButton(
            scrollToBottom: () {
              widget.itemScrollController.scrollTo(
                index: 0,
                duration: Duration(microseconds: 150000),
                curve: Curves.easeIn,
              );
              _showScrollToBottom.value = false;
            },
          ),
          builder: (context, show, child) {
            return Positioned(
              right: 0,
              bottom: 0,
              child: AnimatedScale(
                scale: show ? 1 : 0,
                curve: Curves.bounceInOut,
                duration: Duration(microseconds: 150000),
                child: child,
              ),
            );
          },
        ),
      ],
    );
  }
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    required this.participant,
    super.key
  });

  final User participant;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leadingWidth: 36,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(participant.username),
        subtitle: Text('在线'),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white,
          foregroundImage: ResizeImage.resizeIfNeeded(
              156,
              156, 
              NetworkImage(participant.avatarUrl)
          ),
        ),
      ),
      bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Divider(
              height: 2,
              thickness: 2,
              color: Color.fromARGB(255, 224, 224, 224)
          )
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class ScrollToBottomButton extends StatelessWidget {
  const ScrollToBottomButton({
    required this.scrollToBottom,
    super.key
  });

  final VoidCallback scrollToBottom;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      shape: const CircleBorder(),
      onPressed: scrollToBottom,
      backgroundColor: Colors.white,
      child: const Icon(Icons.arrow_downward_rounded),
    );
  }
}
