import '../../domain/domain.dart';

class UserMapper {
  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['fullName'],
      email: json['email'],
      roles: List<String>.from(json['roles'].map((role) => role)),
      token: json['token'] ?? '',
    );
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      'id': user.id,
      'name': user.fullname,
      'email': user.email,
      'token': user.token,
    };
  }
}
