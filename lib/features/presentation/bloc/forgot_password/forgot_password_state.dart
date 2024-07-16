part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;
  ForgotPasswordSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ForgotPasswordError extends ForgotPasswordState {
  @override
  List<Object> get props => [message];
  final String message;
  ForgotPasswordError({
    required this.message,
  });
}
