import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/mock_auth_service.dart';
import '../data/datasources/real_auth_api_service.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/real_auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../presentation/bloc/auth_bloc.dart';

/// Dependency Injection - Supports both Mock and Real API
class DependencyInjection {
  static late SharedPreferences _sharedPreferences;

  // Toggle between mock and real API
  static const bool useMockData = false; // Set to false to use real backend

  // Initialize async dependencies
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Mock Data Source
  static MockAuthService get mockAuthService =>
      MockAuthService(_sharedPreferences);

  // Real API Service
  static RealAuthApiService get realAuthApiService => RealAuthApiService();

  // Repositories (choose based on useMockData flag)
  static AuthRepository get authRepository => useMockData
      ? AuthRepositoryImpl(mockAuthService: mockAuthService)
      : RealAuthRepositoryImpl(
          apiService: realAuthApiService,
          sharedPreferences: _sharedPreferences,
        );

  // Use Cases
  static LoginUseCase get loginUseCase => LoginUseCase(authRepository);
  static RegisterUseCase get registerUseCase => RegisterUseCase(authRepository);
  static LogoutUseCase get logoutUseCase => LogoutUseCase(authRepository);

  // BLoC
  static AuthBloc get authBloc => AuthBloc(
    loginUseCase: loginUseCase,
    registerUseCase: registerUseCase,
    logoutUseCase: logoutUseCase,
    authRepository: authRepository,
  );
}
