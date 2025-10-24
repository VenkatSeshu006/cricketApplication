import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.authRepository,
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (data) => emit(
        AuthAuthenticated(user: data['user'], accessToken: data['accessToken']),
      ),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
      phone: event.phone,
      role: event.role,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (data) => emit(
        AuthAuthenticated(user: data['user'], accessToken: data['accessToken']),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isAuthenticated = await authRepository.isAuthenticated();

    if (isAuthenticated) {
      final result = await authRepository.getCurrentUser();
      result.fold((failure) => emit(const AuthUnauthenticated()), (user) {
        if (user != null) {
          authRepository.getAccessToken().then((token) {
            if (token != null) {
              emit(AuthAuthenticated(user: user, accessToken: token));
            } else {
              emit(const AuthUnauthenticated());
            }
          });
        } else {
          emit(const AuthUnauthenticated());
        }
      });
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
