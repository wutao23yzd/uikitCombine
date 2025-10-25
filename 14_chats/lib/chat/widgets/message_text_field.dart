import 'package:chats/chat/bloc/chat_bloc.dart';
import 'package:chats/chat/model/message.dart';
import 'package:chats/chat/widgets/message_input_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatMessageTextField extends StatelessWidget {
  const ChatMessageTextField({
    required this.itemScrollController,
    required this.focusNode,
    required this.messageInputController,
    super.key
  });

  final MessageInputController messageInputController;
  final FocusNode focusNode;
  final ItemScrollController itemScrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: ChatMessageTextFieldInput(
                      focusNode: focusNode,
                      itemScrollController: itemScrollController,
                      messageInputController: messageInputController
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}


class ChatMessageTextFieldInput extends StatefulWidget {
  const ChatMessageTextFieldInput({
    required this.focusNode,
    required this.itemScrollController,
    required this.messageInputController,
    super.key
  });

  final MessageInputController messageInputController;
  final FocusNode focusNode;
  final ItemScrollController itemScrollController;

  @override
  State<ChatMessageTextFieldInput> createState() => _ChatMessageTextFieldInputState();
}

class _ChatMessageTextFieldInputState extends State<ChatMessageTextFieldInput> with WidgetsBindingObserver {

  MessageInputController get _effectiveController => widget.messageInputController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.focusNode.addListener(_focusNodeListener);
  }

  @override
  void didUpdateWidget(covariant ChatMessageTextFieldInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode.removeListener(_focusNodeListener);
      widget.focusNode.addListener(_focusNodeListener);
    }
  }

  void _onSend() {

    void sendMessage(Message message) {
      context.read<ChatBloc>().add(ChatSendMessageRequested(message: message));
    }
    if (_effectiveController.message.message.trim().isEmpty) return;
    final message = _effectiveController.message.copyWith(
        createAt: DateTime.now()
    );
    sendMessage(message);
    setState(_effectiveController.resetAll);
    widget.focusNode.requestFocus();
    Future<void>.delayed(
        Duration(microseconds: 150000),
          () => widget.itemScrollController.scrollTo(
        index: 0,
        duration: Duration(microseconds: 350000),
        curve: Curves.easeIn,
      ),
    );
  }
  
  Widget sendMessageButton() {
    return GestureDetector(
      onTap: () {
        _onSend();
      },
      child: const FittedBox(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.send),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _effectiveController,
        builder: (context, value, child) {
          return Column(
            children: [
              TextFormField(
                controller: _effectiveController.textFieldController,
                focusNode: widget.focusNode,
                keyboardType: TextInputType.multiline,
                onFieldSubmitted: (_) {
                  _onSend.call();
                },
                maxLines: 5,
                minLines: 1,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  color: Colors.black
                ),
                decoration: InputDecoration(
                  hintText: "说点什么...",
                  prefixIcon: const Icon(Icons.emoji_emotions_outlined),
                  suffixIcon: _effectiveController.text.trim().isEmpty
                      ? null
                      : sendMessageButton(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 224, 224, 224),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4
                  )
                ),
              )
            ],
          );
        }
    );
  }

  void _focusNodeListener() {

  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_focusNodeListener);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
