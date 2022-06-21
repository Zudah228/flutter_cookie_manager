import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferences_key.dart';

final sharedPreferencesRepositoryProvider =
    Provider<SharedPreferencesRepository>((_) => throw UnimplementedError());

class SharedPreferencesRepository {
  SharedPreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  Future<bool> save<T>(SharedPreferencesKey key, T value) async {
    if (value is int) {
      return _prefs.setInt(key.name, value);
    }
    if (value is double) {
      return _prefs.setDouble(key.name, value);
    }
    if (value is bool) {
      return _prefs.setBool(key.name, value);
    }
    if (value is String) {
      return _prefs.setString(key.name, value);
    }
    if (value is List<String>) {
      return _prefs.setStringList(key.name, value);
    }
    return false;
  }

  T? fetch<T>(SharedPreferencesKey key) {
    if (T == int) {
      return _prefs.getInt(key.name) as T?;
    }
    if (T == double) {
      return _prefs.getDouble(key.name) as T?;
    }
    if (T == bool) {
      return _prefs.getBool(key.name) as T?;
    }
    if (T == String) {
      return _prefs.getString(key.name) as T?;
    }
    if (T == List<String>) {
      return _prefs.getStringList(key.name) as T?;
    }
    throw UnsupportedError('Not support \'$T\'');
  }

  Future<bool> remove(SharedPreferencesKey key) => _prefs.remove(key.name);
}