import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/CheckAuthentication.dart';
import '../../../domain/usecase/login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._login, this._checkAuthentication) : super(AuthInitial());
  final Login _login;
  final CheckAuthentication _checkAuthentication;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthLogin) {
      yield AuthLoading();

      final _authenticated = _checkAuthentication.checkLoginAuthentication(
          event.email, event.password);
      yield* _authenticated.fold((failure) async* {
        String message = failure[1].toString();
        yield AuthError(message: message);
      }, (r) async* {
        final _logged = await _login.call(
          LoginParams(
            password: event.password,
            email: event.email,
            // deviceId: event.deviceId,
          ),
        );

        yield _logged.fold(
          (error) => AuthError(
            message: error,
            email: event.email,
            password: event.password,
          ),
          (response) {
            print("This is response");

            return AuthSuccess(salesman: response.salesmann);
          },
        );
      });
    } else if (event is AuthRegister) {}
  }
}
