part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final bool salesman;
  AuthSuccess({
    required this.salesman,
  });
  @override
  List<Object> get props => [salesman];
}

class AuthError extends AuthState {
  final String message;
  final String? email;
  final String? password;

  AuthError({
    required this.message,
    this.email,
    this.password,
  });

  @override
  List<Object> get props => [message];
}
