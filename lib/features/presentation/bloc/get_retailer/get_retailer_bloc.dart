import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:biz_mobile_app/features/domain/usecase/fetch_retailer.dart';

part 'get_retailer_event.dart';
part 'get_retailer_state.dart';

@injectable
class GetRetailerBloc extends Bloc<GetRetailerEvent, GetRetailerState> {
  GetRetailerBloc(
    this._retailer,
  ) : super(GetRetailerInitial());
  final FetchRetailer _retailer;

  @override
  Stream<GetRetailerState> mapEventToState(
    GetRetailerEvent event,
  ) async* {
    if (event is GetRetailerStarted) {
      yield GetRetailerLoading();
      final retailer = await _retailer.call(NoParams());
      yield retailer.fold(
        (l) => GetRetailerError(error: l),
        (r) => GetRetailerSuccess(retailer: r),
      );
    }
  }
}
