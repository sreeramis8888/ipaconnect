import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ipaconnect/src/data/utils/globals.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      await _storage.delete(key: key);
      return null;
    }
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}

Future<void> loadSecureData() async {
  final savedToken = await SecureStorage.read('token') ?? '';
  final savedLoggedIn = (await SecureStorage.read('LoggedIn')) == 'true';
  final savedId = await SecureStorage.read('id') ?? '';
  final savedFcmToken = await SecureStorage.read('fcmToken') ?? '';

  // Only set LoggedIn to true if we have valid token, id, and LoggedIn flag
  token = savedToken;
  id = savedId;
  fcmToken = savedFcmToken;
  LoggedIn = savedLoggedIn && token.isNotEmpty && id.isNotEmpty;

  // If LoggedIn is true but token or id is empty, sync the LoggedIn flag
  if (LoggedIn && (token.isEmpty || id.isEmpty)) {
    LoggedIn = false;
    await SecureStorage.write('LoggedIn', 'false');
  }
}

Future<void> saveSecureData() async {
  await SecureStorage.write('token', token);
  await SecureStorage.write('LoggedIn', LoggedIn.toString());
  await SecureStorage.write('id', id);
  await SecureStorage.write('fcmToken', fcmToken);
}
