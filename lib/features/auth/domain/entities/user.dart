class User {
  final String id;
  final String fullname;
  final String email;
  final List<String> roles;
  final String token;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.roles,
    required this.token,
  });

  bool get isAdmin => roles.contains('admin');

}
