import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../domain/entities/user.dart';

class RealAuthApiService {
  final http.Client client;

  RealAuthApiService({http.Client? client}) : client = client ?? http.Client();

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConfig.authRegisterUrl),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
          'user': data['data']['user'],
          'token': data['data']['access_token'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConfig.authLoginUrl),
        headers: ApiConfig.headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Login successful',
          'user': data['data']['user'],
          'token': data['data']['access_token'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  /// Get current user
  Future<User?> getCurrentUser(String token) async {
    try {
      final response = await client.get(
        Uri.parse(ApiConfig.authMeUrl),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Logout user
  Future<bool> logout(String token) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConfig.authLogoutUrl),
        headers: ApiConfig.authHeaders(token),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Check backend health
  Future<bool> checkHealth() async {
    try {
      final response = await client.get(
        Uri.parse(ApiConfig.healthUrl),
        headers: ApiConfig.headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
