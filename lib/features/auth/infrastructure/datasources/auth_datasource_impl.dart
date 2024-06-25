import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ));
      final user = UserMapper.fromJson(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: 'Invalid token',
          statusCode: 401,
        );
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(
          message: 'Connection timeout',
          statusCode: 408,
        );
      }

      throw CustomError(
        message: e.response?.data['message'] ?? 'An error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      return UserMapper.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw WrongCredentials();
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeout();
      }

      throw CustomError(
        message: e.response?.data['message'] ?? 'An error occurred',
        statusCode: e.response?.statusCode ?? 500,
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<User> register(String fullname, String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
