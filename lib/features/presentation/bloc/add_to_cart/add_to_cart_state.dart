part of 'add_to_cart_bloc.dart';

abstract class AddToCartState extends Equatable {
  const AddToCartState();

  @override
  List<Object> get props => [];
}

class AddToCartInitial extends AddToCartState {
  @override
  List<Object> get props => [];
}

class AddToCartLoading extends AddToCartState {
  @override
  List<Object> get props => [];
}

class AddToCartSuccess extends AddToCartState {
  final String message;

  AddToCartSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class AddToCartError extends AddToCartState {
  final String message;

  AddToCartError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
