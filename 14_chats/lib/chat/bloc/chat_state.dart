part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({required this.messages});

  const ChatState.initial()
      : this(messages: const []);

  final List<Message> messages;

  @override
  List<Object?> get props => [messages];

  ChatState copyWith({
    List<Message>? messages
  }) {
    return ChatState(messages: messages ?? this.messages);
  }
}
