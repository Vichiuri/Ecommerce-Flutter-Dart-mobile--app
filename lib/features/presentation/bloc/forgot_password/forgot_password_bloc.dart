import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/usecase/forgot_password.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

@injectable
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc(this._pass) : super(ForgotPasswordInitial());
  final ForgotPassword _pass;

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is ForgotPasswordPressed) {
      yield ForgotPasswordLoading();
      final _res = await _pass.call(ParamsString(string: event.email));
      yield _res.fold(
        (l) => ForgotPasswordError(message: l),
        (r) => ForgotPasswordSuccess(message: r),
      );
    }
  }
}
