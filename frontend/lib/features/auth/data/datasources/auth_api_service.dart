import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response_model.dart';

class AuthApiService {
  final String baseUrl;
  final http.Client client;

  AuthApiService({required this.baseUrl, http.Client? client})
    : client = client ?? http.Client();

  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'player',
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'full_name': fullName,
              if (phone != null && phone.isNotEmpty) 'phone': phone,
              'role': role,
            }),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Registration timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return AuthResponseModel.fromJson(jsonData);
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['message'] ?? errorBody['error'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Login timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return AuthResponseModel.fromJson(jsonData);
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['message'] ??
            errorBody['error'] ??
            'Invalid email or password';
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      throw Exception('Connection error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
