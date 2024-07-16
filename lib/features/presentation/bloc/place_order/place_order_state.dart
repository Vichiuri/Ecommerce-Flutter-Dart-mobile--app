part of 'place_order_bloc.dart';

abstract class PlaceOrderState extends Equatable {
  const PlaceOrderState();

  @override
  List<Object> get props => [];
}

class PlaceOrderInitial extends PlaceOrderState {}

class PlaceOrderLoading extends PlaceOrderState {}

class PlaceOrderSuccess extends PlaceOrderState {
  final String message;

  PlaceOrderSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class PlaceOrderError extends PlaceOrderState {
  final String message;

  PlaceOrderError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
