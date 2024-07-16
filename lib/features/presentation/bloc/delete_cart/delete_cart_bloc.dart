import 'dart:async';

import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';
import 'package:biz_mobile_app/features/domain/usecase/add_single_to_cart.dart';
import 'package:biz_mobile_app/features/domain/usecase/delete_cart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'delete_cart_event.dart';
part 'delete_cart_state.dart';

@injectable
class DeleteCartBloc extends Bloc<DeleteCartEvent, DeleteCartState> {
  DeleteCartBloc(this.deleteCart) : super(DeleteCartInitial());
  final DeleteCart deleteCart;

  @override
  Stream<DeleteCartState> mapEventToState(
    DeleteCartEvent event,
  ) async* {
    if (event is DeleteCartPressed) {
      yield DeleteCartLoading();
      final result = await deleteCart.call(AddSingleToCartParams(
        prodId: event.orderId,
        product: event.prod,
        ret: event.ret,
      ));
      yield result.fold(
        (l) => DeleteCartError(message: l),
        (r) => DeleteCartSuccess(message: r.message!, id: event.orderId),
      );
    }
  }
}
