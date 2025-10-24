import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';

  AuthLocalDataSource({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  // Token Management
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await secureStorage.write(key: _accessTokenKey, value: accessToken);
    await secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await secureStorage.delete(key: _accessTokenKey);
    await secureStorage.delete(key: _refreshTokenKey);
  }

  // User Data Management
  Future<void> saveUserData({
    required String userId,
    required String email,
  }) async {
    await sharedPreferences.setString(_userIdKey, userId);
    await sharedPreferences.setString(_userEmailKey, email);
  }

  String? getUserId() {
    return sharedPreferences.getString(_userIdKey);
  }

  String? getUserEmail() {
    return sharedPreferences.getString(_userEmailKey);
  }

  Future<void> clearUserData() async {
    await sharedPreferences.remove(_userIdKey);
    await sharedPreferences.remove(_userEmailKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    await clearTokens();
    await clearUserData();
  }
}
