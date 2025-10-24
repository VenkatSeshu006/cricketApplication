import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_auth_service.dart';

/// Mock Repository Implementation - No Backend Required!
class AuthRepositoryImpl implements AuthRepository {
  final MockAuthService mockAuthService;

  AuthRepositoryImpl({required this.mockAuthService});

  @override
  Future<Either<Failure, Map<String, dynamic>>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'player',
  }) async {
    try {
      final user = await mockAuthService.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        role: role,
      );

      return Right({
        'user': user,
        'accessToken': 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
        'refreshToken': 'mock-refresh-token',
        'expiresIn': 900,
      });
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await mockAuthService.login(email, password);

      if (user == null) {
        return const Left(AuthenticationFailure('Login failed'));
      }

      return Right({
        'user': user,
        'accessToken': 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
        'refreshToken': 'mock-refresh-token',
        'expiresIn': 900,
      });
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await mockAuthService.logout();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to logout: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await mockAuthService.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await mockAuthService.isLoggedIn();
  }

  @override
  Future<String?> getAccessToken() async {
    return 'mock-token';
  }

  @override
  Future<String?> getRefreshToken() async {
    return 'mock-refresh-token';
  }
}
