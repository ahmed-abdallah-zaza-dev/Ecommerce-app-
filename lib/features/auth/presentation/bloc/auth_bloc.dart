import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/get_token_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/logout_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;
  final GetTokenUseCase getTokenUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.getTokenUseCase,
    required this.getCurrentUserUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signUpUseCase(
      SignUpParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(SignUpSuccess(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await logoutUseCase(const NoParams());
    emit(Unauthenticated());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getTokenUseCase(const NoParams());
    await result.fold(
      (failure) async => emit(Unauthenticated()),
      (token) async {
        if (token != null && token.isNotEmpty) {
          final userResult = await getCurrentUserUseCase(const NoParams());
          userResult.fold(
            (failure) => emit(Unauthenticated()),
            (user) {
              if (user != null) {
                emit(Authenticated(user));
              } else {
                emit(Unauthenticated());
              }
            },
          );
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resetPasswordUseCase(
      ResetPasswordParams(email: event.email),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(ResetPasswordSuccess()),
    );
  }
}
