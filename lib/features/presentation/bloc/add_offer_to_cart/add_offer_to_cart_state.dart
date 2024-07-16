part of 'add_offer_to_cart_bloc.dart';

abstract class AddOfferToCartState extends Equatable {
  const AddOfferToCartState();

  @override
  List<Object> get props => [];
}

class AddOfferToCartInitial extends AddOfferToCartState {}

class AddOfferToCartSuccess extends AddOfferToCartState {
  final String message;
  AddOfferToCartSuccess({
    required this.message,
  });
}

class AddOfferToCartLoading extends AddOfferToCartState {}

class AddOfferToCartError extends AddOfferToCartState {
  final String message;
  AddOfferToCartError({
    required this.message,
  });
}
