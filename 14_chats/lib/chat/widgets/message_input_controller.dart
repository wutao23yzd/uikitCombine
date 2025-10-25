import 'package:chats/chat/model/message.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

typedef TextStyleBuilder = TextStyle? Function(
    BuildContext context,
    String text
);

typedef MessageValueListenableBuilder = ValueListenableBuilder<Message>;

class MessageTextFieldController extends TextEditingController {

  MessageTextFieldController({
    super.text,
    this.textPatternStyle
  });

  MessageTextFieldController.fromValue(
    super.value, {
    this.textPatternStyle
  }) : super.fromValue();

  final Map<RegExp, TextStyleBuilder>? textPatternStyle;
}

class MessageInputController extends ValueNotifier<Message> {

  factory MessageInputController({
    Message? message,
    Map<RegExp, TextStyleBuilder>? textPatternStyle
  }) {
    return MessageInputController._(
        initialMessage: message ?? Message(),
        textPatternStyle: textPatternStyle
    );
  }

  factory MessageInputController.fromText(
      String? text, {
      Map<RegExp, TextStyleBuilder>? textPatternStyle
  }) {
   return MessageInputController._(
        initialMessage: Message(message: text ?? ''),
        textPatternStyle: textPatternStyle
    );
  }

  MessageInputController._({
    required Message initialMessage,
    Map<RegExp, TextStyleBuilder>? textPatternStyle
  }) : _initialMessage = initialMessage,
      _textFieldController = MessageTextFieldController.fromValue(
        _textEditingValueFromMessage(initialMessage),
        textPatternStyle: textPatternStyle
      ),
      super(initialMessage) {
    _textFieldController.addListener(_textFieldListener);
  }

  MessageTextFieldController get textFieldController => _textFieldController;
  MessageTextFieldController _textFieldController;
  
  Message _initialMessage;

  static TextEditingValue _textEditingValueFromMessage(Message message) {
    final messageText = message.message;
    var textEditingValue = TextEditingValue.empty;
    if (messageText.isNotEmpty) {
      textEditingValue = TextEditingValue(
        text: messageText,
        selection: TextSelection.collapsed(offset: messageText.length)
      );
    }
    return textEditingValue;
  }
  
  void _textFieldListener() {
    final text = _textFieldController.text;
    message = message.copyWith(message: text);
  }

  Message get message => value;
  set message(Message message) => value = message;

  @override
  set value(Message message) {
    super.value = message;

    final messageText = message.message;
    final textFieldText = _textFieldController.text;
    if (messageText != textFieldText) {
      textEditingValue = _textEditingValueFromMessage(message);
    }
  }

  String get text => _textFieldController.text;

  set text(String text) {
    _textFieldController.text = text;
  }

  TextSelection get selection => _textFieldController.selection;

  set selection(TextSelection newSelection) {
    _textFieldController.selection = selection;
  }

  TextEditingValue get textEditingValue => _textFieldController.value;

  set textEditingValue(TextEditingValue value) {
    _textFieldController.value = value;
  }

  void reset({bool resetId = true}) {
    if (resetId) {
      final newId = Uuid().v4();
      _initialMessage = _initialMessage.copyWith(id: newId);
    }
    message = _initialMessage;
  }

  void resetAll({bool resetId = true}) {
    reset(resetId: resetId);
  }

  @override
  void dispose() {
    _textFieldController
    ..removeListener(_textFieldListener)
    ..dispose();
    super.dispose();
  }
}