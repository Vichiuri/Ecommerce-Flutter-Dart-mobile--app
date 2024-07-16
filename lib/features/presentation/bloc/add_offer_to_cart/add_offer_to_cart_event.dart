part of 'add_offer_to_cart_bloc.dart';

abstract class AddOfferToCartEvent extends Equatable {
  const AddOfferToCartEvent();

  @override
  List<Object> get props => [];
}

class AddOfferToCartStarted extends AddOfferToCartEvent {
  final int offerId;
  final int qty;
  AddOfferToCartStarted({
    required this.offerId,
    required this.qty,
  });
}
