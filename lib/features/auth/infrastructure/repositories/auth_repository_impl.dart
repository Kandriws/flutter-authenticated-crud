import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepositoryImpl({AuthDataSource? authDataSource})
      : authDataSource = authDataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return authDataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return authDataSource.login(email, password);
  }

  @override
  Future<User> logout() {
    return authDataSource.logout();
  }

  @override
  Future<User> register(String fullname, String email, String password) {
    return authDataSource.register(fullname, email, password);
  }
}
