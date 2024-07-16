import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_recently_bought.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'recent_bought_event.dart';
part 'recent_bought_state.dart';

@injectable
class RecentBoughtBloc extends Bloc<RecentBoughtEvent, RecentBoughtState> {
  RecentBoughtBloc(this._get) : super(RecentBoughtInitial());
  final GetRecentlyBought _get;

  @override
  Stream<RecentBoughtState> mapEventToState(
    RecentBoughtEvent event,
  ) async* {
    if (event is RecentBoughtEventStarted) {
      yield RecentBoughtLoading();
      final _res = await _get.call(NoParams());
      yield _res.fold(
        (l) => RecentBoughtError(l),
        (r) => RecentBoughtSuccess(r),
      );
    }
    if (event is RecentBoughtEventUpdated) {
      // yield RecentBoughtLoading();
      final _res = await _get.call(NoParams());
      yield _res.fold(
        (l) => RecentBoughtError(l),
        (r) => RecentBoughtSuccess(r),
      );
    }
  }
}
