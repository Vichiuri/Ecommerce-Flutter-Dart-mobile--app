part of 'search_product_bloc.dart';

abstract class SearchProductState extends Equatable {
  const SearchProductState();

  @override
  List<Object> get props => [];
}

class SearchProductInitial extends SearchProductState {}

class SearchProductLoading extends SearchProductState {}

class SearchProductSuccess extends SearchProductState {
  final List<ProductModel> products;

  SearchProductSuccess(this.products);
  @override
  List<Object> get props => [products];
}

class SearchProductError extends SearchProductState {
  final String message;
  @override
  List<Object> get props => [message];
  SearchProductError(this.message);
}
