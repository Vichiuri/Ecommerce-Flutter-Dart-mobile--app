part of 'single_product_bloc.dart';

abstract class SingleProductState extends Equatable {
  const SingleProductState();

  @override
  List<Object> get props => [];
}

class SingleProductInitial extends SingleProductState {}

class SingleProductLoading extends SingleProductState {}

class SingleProductSuccess extends SingleProductState {
  final SingleProductResponse response;
  SingleProductSuccess({
    required this.response,
  });
  @override
  List<Object> get props => [response];
}

class SingleProductError extends SingleProductState {
  final String message;

  @override
  List<Object> get props => [message];
  SingleProductError({
    required this.message,
  });
}
