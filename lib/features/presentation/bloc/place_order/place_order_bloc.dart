import 'dart:async';

import 'package:biz_mobile_app/features/domain/usecase/place_order.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'place_order_event.dart';
part 'place_order_state.dart';

@injectable
class PlaceOrderBloc extends Bloc<PlaceOrderEvent, PlaceOrderState> {
  PlaceOrderBloc(this._place) : super(PlaceOrderInitial());
  final PlaceOrder _place;

  @override
  Stream<PlaceOrderState> mapEventToState(
    PlaceOrderEvent event,
  ) async* {
    if (event is PlaceOrderStarted) {
      yield PlaceOrderLoading();
      final order = await _place
          .call(PlaceOrderParams(notes: event.notes, retId: event.retId));
      yield order.fold(
        (failure) => PlaceOrderError(message: failure),
        (success) => PlaceOrderSuccess(message: success.message ?? ""),
      );
    }
  }
}
