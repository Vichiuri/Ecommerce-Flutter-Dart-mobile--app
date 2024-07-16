import 'dart:async';

import 'package:biz_mobile_app/features/domain/usecase/change_password.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'password_event.dart';
part 'password_state.dart';

@injectable
class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  PasswordBloc(this._password) : super(PasswordInitial());
  final ChangePassword _password;

  @override
  Stream<PasswordState> mapEventToState(
    PasswordEvent event,
  ) async* {
    if (event is ChangePasswordEventStarted) {
      yield PasswordLoading();
      final _res = await _password.call(
          ChangePasswordParams(oldPass: event.oldPass, newPass: event.newPass));
      yield _res.fold(
        (l) => PasswordError(l),
        (r) => PasswordSuccess(r),
      );
    }
  }
}
