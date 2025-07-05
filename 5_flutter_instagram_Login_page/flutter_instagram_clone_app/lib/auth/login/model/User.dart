class User {

  const User({
    required this.id,
    required this.email,
    required this.password
  });

  final String id;
  final String email;
  final String? password;

  static const User empty = User(id: '', email: '', password: null);
}
