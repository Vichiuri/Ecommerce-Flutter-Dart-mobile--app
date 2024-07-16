import 'dart:async';

import 'package:biz_mobile_app/features/domain/usecase/check_auth_user.dart';
import 'package:biz_mobile_app/features/domain/usecase/logout.dart';
import 'package:biz_mobile_app/features/domain/usecase/send_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/CheckFirstTime.dart';
import '../../../domain/usecase/FetchLocalUser.dart';
import '../../../domain/usecase/SaveFirstTime.dart';

part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(
    this._logout,
    this._user,
    this._location, {
    required this.checkFirstTime,
    required this.fetchLocalUser,
    required this.saveFirstTime,
  }) : super(SplashInitial());

  final CheckFirstTime checkFirstTime;
  final FetchLocalUser fetchLocalUser;
  final SaveFirstTime saveFirstTime;
  final Logout _logout;
  final CheckAuthUser _user;
  final SendLocation _location;

  @override
  Stream<SplashState> mapEventToState(
    SplashEvent event,
  ) async* {
    if (event is CheckFirstTimeEvent) {
      final isFirstTime = await checkFirstTime(NoParams());
      if (isFirstTime) {
        yield SplashToIntro();
      } else {
        final checkAuthEither = await _user(NoParams());
        yield* checkAuthEither.fold((l) async* {
          yield SplashToLogin();
        }, (user) async* {
          if (user) {
            await _location.call(NoParams());
            yield SplashToHome();
          } else {
            yield SplashToLogin();
          }
        });
      }
    }
    if (event is SaveFirstTimeEvent) {
      final firstTimeEither = await saveFirstTime(NoParams());
      yield* firstTimeEither.fold((failure) async* {
        yield SplashIntroErrorState(
          message: failure,
        );
      }, (success) async* {
        yield SplashToLogin();
      });
    }
    if (event is LogoutEvent) {
      yield SplashLoading();
      final _loggedOut = await _logout.call(NoParams());
      yield _loggedOut.fold(
        (l) => SplashToLogin(),
        (r) => SplashToLogin(),
      );
    }
  }
}
