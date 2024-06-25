import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static init() async {
    await dotenv.load(fileName: '.env');
  }

  static String apiUrl = dotenv.env['API_URL'] ?? 'Not found';
}
