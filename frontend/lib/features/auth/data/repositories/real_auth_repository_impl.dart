import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/real_auth_api_service.dart';

/// Real Repository Implementation - Connects to Backend API
class RealAuthRepositoryImpl implements AuthRepository {
  final RealAuthApiService apiService;
  final SharedPreferences sharedPreferences;

  static const String _keyToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUser = 'user_data';

  RealAuthRepositoryImpl({
    required this.apiService,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'player',
  }) async {
    try {
      final result = await apiService.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );

      if (result['success'] == true) {
        // Save token and user data
        await sharedPreferences.setString(_keyToken, result['token']);
        await sharedPreferences.setString(_keyUser, result['user'].toString());

        return Right({
          'user': User.fromJson(result['user']),
          'accessToken': result['token'],
          'refreshToken': result['token'], // Backend uses same token
          'expiresIn': 900,
        });
      } else {
        return Left(ValidationFailure(result['message']));
      }
    } catch (e) {
      return Left(ServerFailure('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await apiService.login(email: email, password: password);

      if (result['success'] == true) {
        // Save token and user data
        await sharedPreferences.setString(_keyToken, result['token']);
        await sharedPreferences.setString(_keyUser, result['user'].toString());

        return Right({
          'user': User.fromJson(result['user']),
          'accessToken': result['token'],
          'refreshToken': result['token'],
          'expiresIn': 900,
        });
      } else {
        return Left(AuthenticationFailure(result['message']));
      }
    } catch (e) {
      return Left(ServerFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        await apiService.logout(token);
      }

      // Clear local storage
      await sharedPreferences.remove(_keyToken);
      await sharedPreferences.remove(_keyRefreshToken);
      await sharedPreferences.remove(_keyUser);

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to logout: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final token = await getAccessToken();
      if (token == null) {
        return const Right(null);
      }

      final user = await apiService.getCurrentUser(token);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    if (token == null) return false;

    // Check if backend is reachable and token is valid
    final user = await apiService.getCurrentUser(token);
    return user != null;
  }

  @override
  Future<String?> getAccessToken() async {
    return sharedPreferences.getString(_keyToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return sharedPreferences.getString(_keyRefreshToken);
  }
}
