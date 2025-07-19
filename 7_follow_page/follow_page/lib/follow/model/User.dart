class User {

  const User({
    required this.id,
    this.username,
    this.avatarUrl,
  });

  final String id;

  final String? username;

  final String? avatarUrl;
  
}