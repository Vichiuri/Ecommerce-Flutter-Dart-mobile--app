part of 'fetch_by_category_bloc.dart';

abstract class FetchByCategoryEvent extends Equatable {
  const FetchByCategoryEvent();

  @override
  List<Object> get props => [];
}

class FetchByCategoryStarted extends FetchByCategoryEvent {
  final int categoryId;
  final List<ProductModel> product;

  FetchByCategoryStarted({
    required this.categoryId,
    required this.product,
  });
  @override
  List<Object> get props => [categoryId, product];
}

class UpdateCategoryStarted extends FetchByCategoryEvent {
  final int categoryId;

  UpdateCategoryStarted({
    required this.categoryId,
  });
  @override
  List<Object> get props => [categoryId];
}

class FetchByCategoryPaginated extends FetchByCategoryEvent {
  final int categoryId;
  final List<ProductModel> product;
  final int? page;

  FetchByCategoryPaginated({
    required this.categoryId,
    required this.product,
    this.page,
  });
  @override
  List<Object> get props => [categoryId, product];
}
