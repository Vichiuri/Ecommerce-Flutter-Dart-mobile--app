part of 'delete_cart_bloc.dart';

abstract class DeleteCartState extends Equatable {
  const DeleteCartState();

  @override
  List<Object> get props => [];
}

class DeleteCartInitial extends DeleteCartState {}

class DeleteCartLoading extends DeleteCartState {}

class DeleteCartSuccess extends DeleteCartState {
  final String message;
  final int id;
  DeleteCartSuccess({
    required this.message,
    required this.id,
  });
  @override
  List<Object> get props => [message, id];
}

class DeleteCartError extends DeleteCartState {
  final String message;
  DeleteCartError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
