import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'player',
  }) async {
    // Validate input
    if (email.isEmpty || !_isValidEmail(email)) {
      return const Left(ValidationFailure('Please enter a valid email'));
    }

    if (password.isEmpty || password.length < 6) {
      return const Left(
        ValidationFailure('Password must be at least 6 characters'),
      );
    }

    if (fullName.isEmpty || fullName.length < 2) {
      return const Left(ValidationFailure('Please enter a valid full name'));
    }

    if (phone != null && phone.isNotEmpty && !_isValidPhone(phone)) {
      return const Left(ValidationFailure('Please enter a valid phone number'));
    }

    return await repository.register(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      role: role,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
  }
}
