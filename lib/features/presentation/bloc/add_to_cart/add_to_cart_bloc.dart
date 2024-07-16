import 'dart:async';

import 'package:biz_mobile_app/features/domain/usecase/add_single_to_cart.dart';
import 'package:biz_mobile_app/features/domain/usecase/add_to_cart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';

part 'add_to_cart_event.dart';
part 'add_to_cart_state.dart';

@injectable
class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  AddToCartBloc(this._add, this._addSingle) : super(AddToCartInitial());
  final AddToCart _add;
  final AddSingleToCart _addSingle;

  @override
  Stream<AddToCartState> mapEventToState(
    AddToCartEvent event,
  ) async* {
    if (event is AddToCartStarted) {
      yield AddToCartLoading();
      final added = await _add.call(
        AddToCartParams(
          qty: event.qty,
          action: event.action,
          prodId: event.prodId,
          product: event.product,
        ),
      );

      yield added.fold((failure) => AddToCartError(message: failure),
          (success) => AddToCartSuccess(message: success.message ?? ""));
    }
    if (event is AddToCartSingle) {
      yield AddToCartLoading();
      final added = await _addSingle.call(AddSingleToCartParams(
        prodId: event.prodId,
        product: event.product,
      ));

      yield added.fold((failure) => AddToCartError(message: failure),
          (success) => AddToCartSuccess(message: success.message ?? ""));
    }
  }
}
