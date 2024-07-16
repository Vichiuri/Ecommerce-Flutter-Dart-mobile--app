import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/usecase/usecase.dart';
import '../../data/responses/AuthResponse.dart';
import '../repositories/repository.dart';

@lazySingleton
class Login extends UseCase<AuthResponse, LoginParams> {
  Login(this._repository);

  @override
  Future<Either<String, AuthResponse>> call(LoginParams p) {
    return _repository.login(
      email: p.email,
      password: p.password,
      // deviceId: p.deviceId,
    );
  }

  final Repository _repository;
}

class LoginParams {
  final String email;
  final String password;
  // final String deviceId;

  LoginParams({
    required this.email,
    required this.password,
    // required this.deviceId,
  });

  LoginParams copyWith({
    String? email,
    String? password,
    // String? deviceId,
  }) {
    return LoginParams(
      email: email ?? this.email,
      password: password ?? this.password,
      // deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  String toString() => 'LoginParams(email: $email, password: $password, )';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginParams &&
        other.email == email &&
        other.password == password;
    // other.deviceId == deviceId;
  }

  @override
  int get hashCode =>
      email.hashCode ^ password.hashCode; /* ^ deviceId.hashCode;*/
}
