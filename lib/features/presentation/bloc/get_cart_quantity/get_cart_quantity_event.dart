part of 'get_cart_quantity_bloc.dart';

abstract class GetCartQuantityEvent extends Equatable {
  const GetCartQuantityEvent();

  @override
  List<Object> get props => [];
}

class GetCartQuantityStarted extends GetCartQuantityEvent {}
