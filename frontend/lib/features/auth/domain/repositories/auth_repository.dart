import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Register a new user
  Future<Either<Failure, Map<String, dynamic>>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'player',
  });

  /// Login with email and password
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  /// Logout and clear tokens
  Future<Either<Failure, void>> logout();

  /// Get current user from stored token
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get stored access token
  Future<String?> getAccessToken();

  /// Get stored refresh token
  Future<String?> getRefreshToken();
}
