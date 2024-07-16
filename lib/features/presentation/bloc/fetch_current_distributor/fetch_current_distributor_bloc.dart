import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';
import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_current_distributer.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'fetch_current_distributor_event.dart';
part 'fetch_current_distributor_state.dart';

@injectable
class FetchCurrentDistributorBloc
    extends Bloc<FetchCurrentDistributorEvent, FetchCurrentDistributorState> {
  FetchCurrentDistributorBloc(this._distributor)
      : super(FetchCurrentDistributorInitial());
  final GetCurrentDistributor _distributor;

  @override
  Stream<FetchCurrentDistributorState> mapEventToState(
    FetchCurrentDistributorEvent event,
  ) async* {
    if (event is FetchCurrentStarted) {
      yield FetchCurrentDistributorLoading();
      final result = await _distributor.call(NoParams());
      yield result.fold(
        (l) => FetchCurrentDistributorError(message: l),
        (r) => FetchCurrentDistributorSuccess(
            distributor: r.singleDist, retailerModel: r.singleRet),
      );
    }
  }
}
