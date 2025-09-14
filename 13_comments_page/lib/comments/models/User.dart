import 'dart:math';

import 'package:flutter/cupertino.dart';

const _confirmedUsers = <User>[
  User(
    id: '462738c5-5369-4590-818d-ac883ffa4424',
    avatarUrl:
    'https://img.freepik.com/premium-photo/cartoon-character-with-blue-shirt-glasses_561641-2084.jpg?size=626&ext=jpg',
    username: '小明'
  ),
  User(
    id: 'a0ee0d08-cb0e-4ba6-9401-b47a2a66cdc1',
    avatarUrl:
    'https://img.freepik.com/free-photo/3d-rendering-zoom-call-avatar_23-2149556778.jpg?size=626&ext=jpg',
    username: '汤姆'
  ),
];

class User {
  const User ({
    required this.id,
    this.avatarUrl,
    this.username
  });

  final String id;
  final String? avatarUrl;
  final String? username;
}

class PostAuthor{

  const PostAuthor({
    required this.id,
    required this.username,
    required this.avatarUrl
  });

  factory PostAuthor.randomConfirmed({
    String? id,
    String? avatarUrl,
    String? username
  }) {
    final randomConfirmedUser = _confirmedUsers[Random().nextInt(_confirmedUsers.length)];
    return PostAuthor(
        id: id ?? randomConfirmedUser.id,
        username: username ?? randomConfirmedUser.username!,
        avatarUrl: avatarUrl ?? randomConfirmedUser.avatarUrl!
    );
  }

  final String id;

  final String username;

  final String avatarUrl;
}