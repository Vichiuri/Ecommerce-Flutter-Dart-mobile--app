part of 'get_cart_quantity_bloc.dart';

abstract class GetCartQuantityState extends Equatable {
  const GetCartQuantityState();

  @override
  List<Object> get props => [];
}

class GetCartQuantityInitial extends GetCartQuantityState {}

class GetCartQuantitySuccess extends GetCartQuantityState {
  final CartQuantity cartQuantity;
  GetCartQuantitySuccess({
    required this.cartQuantity,
  });
  @override
  List<Object> get props => [cartQuantity];
}

class GetCartQuantityLoading extends GetCartQuantityState {}

class GetCartQuantityError extends GetCartQuantityState {
  final String message;

  GetCartQuantityError(this.message);
}
