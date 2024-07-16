import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/profile_response.dart';
import 'package:biz_mobile_app/features/domain/usecase/fetch_profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._profile) : super(ProfileInitial());
  final FetchProfile _profile;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is FetchProfileEventStarted) {
      yield ProfileLoading();
      final _res = await _profile.call(NoParams());
      yield _res.fold(
        (l) => ProfileError(message: l),
        (r) => ProfileSuccess(profile: r),
      );
    }
  }
}
