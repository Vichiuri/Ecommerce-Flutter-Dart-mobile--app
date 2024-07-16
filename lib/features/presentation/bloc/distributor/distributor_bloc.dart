import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/data/responses/DistributorResponse.dart';
import 'package:biz_mobile_app/features/domain/usecase/change_distributor.dart';
import 'package:biz_mobile_app/features/domain/usecase/fetch_distributor.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'distributor_event.dart';
part 'distributor_state.dart';

@injectable
class DistributorBloc extends Bloc<DistributorEvent, DistributorState> {
  DistributorBloc(this._get, this._change) : super(DistributorInitial());
  final FetchDistributor _get;
  final ChangeDistributor _change;

  @override
  Stream<DistributorState> mapEventToState(
    DistributorEvent event,
  ) async* {
    if (event is FetchDistributorEvent) {
      yield DistributorLoading();
      final _dist = await _get.call(ParamsStringNullable(string: event.query));
      yield _dist.fold(
        (l) => DistributorError(message: l),
        (r) => DistributorSuccess(response: r),
      );
    }
    if (event is UpdateDistributorEvent) {
      // yield DistributorLoading();
      final _dist = await _get.call(ParamsStringNullable());
      yield _dist.fold(
        (l) => DistributorError(message: l),
        (r) => DistributorSuccess(response: r),
      );
    }
    if (event is ChangeDistributorEvent) {
      yield ChangeDistributorLoading();
      final _dist = await _change.call(ParamsId(id: event.distributorId));
      yield _dist.fold(
        (l) => DistributorError(message: l),
        (r) => ChangeDistributorSuccess(response: "Change Success"),
      );
    }
  }
}
