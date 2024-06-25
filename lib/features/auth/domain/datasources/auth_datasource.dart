import '../entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> logout();
  Future<User> register(String fullname, String email, String password);
  Future<User> checkAuthStatus(String token);
}
