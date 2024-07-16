import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/usecase/filter_orders.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_order_history.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/models/RetailOrder/retail_order_model.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

@injectable
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  OrderHistoryBloc(this._get, this._filter) : super(OrderHistoryInitial());
  final GetOrderHistory _get;
  final FilterOrders _filter;

  @override
  Stream<OrderHistoryState> mapEventToState(
    OrderHistoryEvent event,
  ) async* {
    if (event is GetOrderHistoryStarted) {
      yield OrderHistoryLoading();
      final res = await _get.call(ParamsIdNullable(id: event.page));
      yield res.fold(
        (l) => OrderHistoryError(message: l),
        (r) => OrderHistorySuccess(
          retailOrder: [...event.retOrder, ...r.retailOrders],
          currentPage: r.currentPage,
          lastPage: r.lastPage,
        ),
      );
    }
    if (event is GetOrderHistoryUpdated) {
      yield OrderHistoryUpdating();
      final res = await _get.call(ParamsIdNullable(id: 1));
      yield* res.fold(
        (l) async* {
          yield OrderHistoryError(message: l);
        },
        (r) async* {
          yield OrderHistorySuccess(
            retailOrder: [...event.retOrder, ...r.retailOrders],
            currentPage: r.currentPage,
            lastPage: r.lastPage,
          );
        },
      );
    }
    if (event is FilterOrderHistoryEvent) {
      yield OrderHistoryLoading();
      final res = await _filter.call(FilterOrderParams(
        id: event.id,
        status: event.status,
        timeStampFrom: event.timeStampFrom,
        timeStampTo: event.timeStampTo,
      ));
      yield res.fold(
        (l) => OrderHistoryError(message: l),
        (r) => OrderHistorySuccess(
          retailOrder: r.retailOrders,
          currentPage: r.currentPage,
          lastPage: r.lastPage,
        ),
      );
    }
  }
}
