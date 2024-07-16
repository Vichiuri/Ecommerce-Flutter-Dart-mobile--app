part of 'delete_order_bloc.dart';

abstract class DeleteOrderState extends Equatable {
  const DeleteOrderState();

  @override
  List<Object> get props => [];
}

class DeleteOrderInitial extends DeleteOrderState {}

class DeleteOrderLoading extends DeleteOrderState {}

class DeleteOrderSuccess extends DeleteOrderState {
  final String message;
  DeleteOrderSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class DeleteOrderError extends DeleteOrderState {
  final String message;

  DeleteOrderError(this.message);
  @override
  List<Object> get props => [message];
}
