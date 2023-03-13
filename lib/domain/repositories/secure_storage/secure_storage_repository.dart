import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'secure_storage_key.dart';

final secureStorageRepositoryProvider =
    Provider((_) => SecureStorageRepository(const FlutterSecureStorage()));

class SecureStorageRepository {
  SecureStorageRepository(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  Future<void> save(SecureStorageKey key, String value) async {
    await _secureStorage.write(key: key.keyName, value: value);
  }

  Future<String?> fetch(SecureStorageKey key) async {
    return _secureStorage.read(key: key.keyName);
  }

  Future<void> delete(SecureStorageKey key) async {
    await _secureStorage.delete(key: key.keyName);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
