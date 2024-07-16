part of 'password_bloc.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object> get props => [];
}

class PasswordInitial extends PasswordState {}

class PasswordLoading extends PasswordState {}

class PasswordSuccess extends PasswordState {
  final String message;

  PasswordSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class PasswordError extends PasswordState {
  final String message;

  PasswordError(this.message);
  @override
  List<Object> get props => [message];
}
