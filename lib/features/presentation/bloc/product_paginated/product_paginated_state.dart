part of 'product_paginated_bloc.dart';

abstract class ProductPaginatedState extends Equatable {
  const ProductPaginatedState();

  @override
  List<Object> get props => [];
}

class ProductPaginatedInitial extends ProductPaginatedState {}

class ProductPaginatedLoading extends ProductPaginatedState {
  final String message;
  ProductPaginatedLoading({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ProductPaginatedUpdating extends ProductPaginatedState {
  final String message;
  ProductPaginatedUpdating({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ProductPaginatedSuccess extends ProductPaginatedState {
  @override
  List<Object> get props => [response];
  final DashBoardResponse response;
  final double position;
  final List<ProductModel> products;
  ProductPaginatedSuccess(
      {required this.response, required this.position, required this.products});
}

class ProductPaginatedError extends ProductPaginatedState {
  @override
  List<Object> get props => [position, error];
  final double position;
  final String error;
  ProductPaginatedError({
    required this.position,
    required this.error,
  });
}
