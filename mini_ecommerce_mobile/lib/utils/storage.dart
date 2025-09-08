import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  // Local storage ✔️ as mentioned in task
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'token';

  static Future<void> saveToken(String token) async =>
      await _storage.write(key: _keyToken, value: token);

  static Future<String?> getToken() async =>
      await _storage.read(key: _keyToken);

  static Future<void> deleteToken() async =>
      await _storage.delete(key: _keyToken);
}
