import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/usecase/confirm_delivery.dart';
import 'package:biz_mobile_app/features/domain/usecase/delete_order.dart';
import 'package:biz_mobile_app/features/domain/usecase/reorder.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'delete_order_event.dart';
part 'delete_order_state.dart';

@injectable
class DeleteOrderBloc extends Bloc<DeleteOrderEvent, DeleteOrderState> {
  DeleteOrderBloc(this._order, this._delivery, this._reOrderl)
      : super(DeleteOrderInitial());
  final DeleteOrder _order;
  final ConfirmDelivery _delivery;
  final ReOrder _reOrderl;

  @override
  Stream<DeleteOrderState> mapEventToState(
    DeleteOrderEvent event,
  ) async* {
    if (event is DeleteOrderStarted) {
      yield DeleteOrderLoading();
      final res = await _order.call(ParamsId(id: event.orderId));
      yield res.fold(
        (l) => DeleteOrderError(l),
        (r) => DeleteOrderSuccess(message: r),
      );
    }
    if (event is ConfirmDeliveryEvent) {
      yield DeleteOrderLoading();
      final res = await _delivery.call(ParamsId(id: event.orderId));
      yield res.fold(
        (l) => DeleteOrderError(l),
        (r) => DeleteOrderSuccess(message: r),
      );
    }
    if (event is ReOrderEvent) {
      yield DeleteOrderLoading();
      final res = await _reOrderl.call(ParamsId(id: event.orderId));
      yield res.fold(
        (l) => DeleteOrderError(l),
        (r) => DeleteOrderSuccess(message: r),
      );
    }
  }
}
