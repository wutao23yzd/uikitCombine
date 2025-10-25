


class User {
  const User({
    required this.username,
    required this.id,
    this.avatarUrl = 'https://img.freepik.com/premium-photo/cartoon-character-with-blue-shirt-glasses_561641-2084.jpg?size=626&ext=jpg'
  });
  final String id;
  final String username;
  final String avatarUrl;

  static User mock = User(username: '小帅', id: '1');
}