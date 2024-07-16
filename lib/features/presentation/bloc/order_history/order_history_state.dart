part of 'order_history_bloc.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryUpdating extends OrderHistoryState {}

class OrderHistorySuccess extends OrderHistoryState {
  final List<RetailOrdersModel> retailOrder;
  final int lastPage;
  final int currentPage;

  OrderHistorySuccess({
    required this.retailOrder,
    required this.lastPage,
    required this.currentPage,
  });
  @override
  List<Object> get props => [currentPage, lastPage, retailOrder];
}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  OrderHistoryError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
