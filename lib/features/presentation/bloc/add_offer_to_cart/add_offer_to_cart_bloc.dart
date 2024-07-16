import 'dart:async';

import 'package:biz_mobile_app/features/domain/usecase/add_offer_to_cart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'add_offer_to_cart_event.dart';
part 'add_offer_to_cart_state.dart';

@injectable
class AddOfferToCartBloc
    extends Bloc<AddOfferToCartEvent, AddOfferToCartState> {
  AddOfferToCartBloc(this._cart) : super(AddOfferToCartInitial());
  final AddOfferToCart _cart;

  @override
  Stream<AddOfferToCartState> mapEventToState(
    AddOfferToCartEvent event,
  ) async* {
    if (event is AddOfferToCartStarted) {
      yield AddOfferToCartLoading();
      final result = await _cart
          .call(AddOfferToCartParam(offerId: event.offerId, qty: event.qty));
      yield result.fold(
        (l) => AddOfferToCartError(message: l),
        (r) => AddOfferToCartSuccess(message: r.message ?? "Added to Cart"),
      );
    }
  }
}
