class WrongCredentials implements Exception {}

class InvalidToken implements Exception {}

class ConnectionTimeout implements Exception {}

class CustomError implements Exception {
  final String message;
  final int statusCode;

  CustomError({
    required this.message,
    required this.statusCode,
  });
}
