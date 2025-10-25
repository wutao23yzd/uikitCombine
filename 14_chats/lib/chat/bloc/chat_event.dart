part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class ChatMessagesRequested extends ChatEvent {
  const ChatMessagesRequested();
}

final class ChatSendMessageRequested extends ChatEvent {
  const ChatSendMessageRequested({
    required this.message
  });
  final Message message;
}