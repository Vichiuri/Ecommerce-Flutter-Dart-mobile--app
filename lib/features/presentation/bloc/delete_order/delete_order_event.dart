part of 'delete_order_bloc.dart';

abstract class DeleteOrderEvent extends Equatable {
  const DeleteOrderEvent();

  @override
  List<Object> get props => [];
}

class DeleteOrderStarted extends DeleteOrderEvent {
  final int orderId;
  DeleteOrderStarted({
    required this.orderId,
  });
  @override
  List<Object> get props => [orderId];
}

class ConfirmDeliveryEvent extends DeleteOrderEvent {
  final int orderId;
  ConfirmDeliveryEvent({
    required this.orderId,
  });
  @override
  List<Object> get props => [orderId];
}

class ReOrderEvent extends DeleteOrderEvent {
  final int orderId;
  ReOrderEvent({
    required this.orderId,
  });
  @override
  List<Object> get props => [orderId];
}
