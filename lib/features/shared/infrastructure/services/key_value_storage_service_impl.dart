import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future<SharedPreferences> getSharedPreference() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getKeyValue<T>(String key) async {
    final preferences = await getSharedPreference();

    switch (T) {
      case String:
        return preferences.getString(key) as T?;
      case int:
        return preferences.getInt(key) as T?;
      case double:
        return preferences.getDouble(key) as T?;
      case bool:
        return preferences.getBool(key) as T?;
      case List<String>:
        return preferences.getStringList(key) as T?;
      default:
        throw Exception('Type not supported');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final preferences = await getSharedPreference();
    return preferences.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final preferences = await getSharedPreference();

    switch (T) {
      case String:
        await preferences.setString(key, value as String);
        break;
      case int:
        await preferences.setInt(key, value as int);
        break;
      case double:
        await preferences.setDouble(key, value as double);
        break;
      case bool:
        await preferences.setBool(key, value as bool);
        break;
      case List<String>:
        await preferences.setStringList(key, value as List<String>);
        break;
      default:
        throw Exception('Type not supported');
    }
  }
}
