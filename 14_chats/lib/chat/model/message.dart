import 'package:chats/chat/model/User.dart';
import 'package:equatable/equatable.dart';
import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';

enum MessageType {

  text('text'),

  image('image');

  const MessageType(this.value);

  final String value;
}

class Message extends Equatable {

  Message({
    String? id,
    this.sender,
    this.message = '',
    this.type = MessageType.text,
    DateTime? createAt,
    this.post,
    this.caption
  }) : id = id ?? const Uuid().v4(),
        createAt = createAt ?? Jiffy.now().dateTime;

  final String id;

  final User? sender;

  final String message;

  final MessageType type;

  final DateTime createAt;

  final String? post;

  final String? caption;

  static final messageList = <Message>[
    Message(
        sender: User.mock,
        message: "你好",
        createAt: DateTime.now().subtract(
            Duration(minutes: 5)
        )
    ),
    Message(
        sender: User.mock,
        message: "你好",
        createAt: DateTime.now().subtract(
            Duration(minutes: 2)
        ),
        post: 'assets/images/leader.jpeg',
        caption: '我们应该怎么告别呢，就像当初见面那样~'
    )
  ];

  @override
  List<Object?> get props => [id, sender, type, message, createAt, post, caption];

  Message copyWith({
    String? id,
    User? sender,
    String? message,
    MessageType? type,
    DateTime? createAt,
    String? post,
    String? caption
  }) {
    return Message(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      type: type ?? this.type,
      createAt: createAt ?? this.createAt,
      post: post ?? this.post,
      caption: caption ?? this.caption
    );
  }
}