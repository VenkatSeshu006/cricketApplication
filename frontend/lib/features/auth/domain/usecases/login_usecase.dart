import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String email,
    required String password,
  }) async {
    // Validate input
    if (email.isEmpty || !_isValidEmail(email)) {
      return const Left(ValidationFailure('Please enter a valid email'));
    }

    if (password.isEmpty || password.length < 6) {
      return const Left(ValidationFailure('Password must be at least 6 characters'));
    }

    return await repository.login(email: email, password: password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
