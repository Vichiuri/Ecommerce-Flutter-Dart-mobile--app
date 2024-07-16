part of 'delete_cart_bloc.dart';

abstract class DeleteCartEvent extends Equatable {
  const DeleteCartEvent();

  @override
  List<Object> get props => [];
}

class DeleteCartPressed extends DeleteCartEvent {
  final int orderId;
  final ProductModel prod;
  final int? ret;

  DeleteCartPressed({
    required this.orderId,
    required this.prod,
    required this.ret,
  });

  @override
  List<Object> get props => [orderId, prod];
}
