import 'package:bloc/bloc.dart';
import 'package:chats/chat/model/message.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState.initial()) {
    on<ChatMessagesRequested>(_onMessagesRequested);
    on<ChatSendMessageRequested>(_onSendMessageRequested);
  }

  void _onMessagesRequested(
      ChatMessagesRequested event,
      Emitter<ChatState> emit) {
    List<Message> messages = Message.messageList;
    emit(state.copyWith(messages: messages));
  }


  void _onSendMessageRequested(
      ChatSendMessageRequested event,
      Emitter<ChatState> emit) {
    List<Message> messages = List.from(state.messages);
    messages.add(event.message);
    emit(state.copyWith(messages: messages));
  }
}
