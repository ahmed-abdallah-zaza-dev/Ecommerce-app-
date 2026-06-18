import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordSuccess extends AuthState {}

class SignUpSuccess extends AuthState {
  final User user;

  const SignUpSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
