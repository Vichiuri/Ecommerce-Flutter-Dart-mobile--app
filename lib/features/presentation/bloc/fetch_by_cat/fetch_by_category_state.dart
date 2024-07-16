part of 'fetch_by_category_bloc.dart';

abstract class FetchByCategoryState extends Equatable {
  const FetchByCategoryState();

  @override
  List<Object> get props => [];
}

class FetchByCategoryInitial extends FetchByCategoryState {}

class FetchByCategoryLoading extends FetchByCategoryState {}

class FetchByCategoryError extends FetchByCategoryState {
  final String error;

  FetchByCategoryError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class FetchByCategorySuccess extends FetchByCategoryState {
  final List<ProductModel> product;
  final int? lastPage;
  final int? currentPage;

  FetchByCategorySuccess({
    required this.product,
    this.lastPage,
    this.currentPage,
  });
  @override
  List<Object> get props => [product];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FetchByCategorySuccess &&
        listEquals(other.product, product) &&
        other.lastPage == lastPage &&
        other.currentPage == currentPage;
  }

  @override
  int get hashCode =>
      product.hashCode ^ lastPage.hashCode ^ currentPage.hashCode;
}
