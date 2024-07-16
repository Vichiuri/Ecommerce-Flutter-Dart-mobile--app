part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;
  // final String deviceId;

  AuthLogin({
    required this.email,
    required this.password,
    // required this.deviceId,
  });

  @override
  List<Object> get props => [
        email,
        password,
      ];
}

class AuthRegister extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPass;
  AuthRegister({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPass,
  });
  @override
  List<Object> get props => [email, password, name, confirmPass];
}
