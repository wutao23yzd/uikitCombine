

import 'dart:math';

class PostBlock {

  const PostBlock({
    required this.id,
    required this.author,
    required this.media,
    required this.caption
  });

  final String id;

  final PostAuthor author;
  
  final List<String> media;

  final String caption;
}

class User {
  const User ({
    required this.id,
    this.email,
    this.username,
    this.fullName,
    this.avatarUrl
  });

  final String? email;

  final String id;

  final String? username;

  final String? fullName;

  final String? avatarUrl;
}

const _confirmedUsers = <User> [
  User(
    id: '462738c5-5369-4590-818d-ac883ffa4424',
    avatarUrl:
        'https://img.freepik.com/premium-photo/cartoon-character-with-blue-shirt-glasses_561641-2084.jpg?size=626&ext=jpg',
    email: 'emilzulufov@gmail.com',
    username: '小帅',
    fullName: '小帅',
  ),
  User(
    id: 'a0ee0d08-cb0e-4ba6-9401-b47a2a66cdc1',
    avatarUrl:
        'https://img.freepik.com/free-photo/3d-rendering-zoom-call-avatar_23-2149556778.jpg?size=626&ext=jpg',
    email: 'emilzulufov.commercial@gmail.com',
    username: '奥德彪',
    fullName: '奥德彪',
  ),
];


class PostAuthor {
  const PostAuthor({
    required this.id,
    required this.avatarUrl,
    required this.username
  });

  factory PostAuthor.randomConfirmed({
    String? id,
    String? avatarUrl,
    String? username
  }) {
    final randomConfirmedUser = _confirmedUsers[Random().nextInt(_confirmedUsers.length)];
    return PostAuthor(
      id: id ?? randomConfirmedUser.id, 
      avatarUrl: avatarUrl ?? randomConfirmedUser.avatarUrl!, 
      username: username ?? randomConfirmedUser.username!);
  }

  final String id;

  final String username;

  final String avatarUrl;
}