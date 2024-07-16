part of 'all_category_bloc.dart';

abstract class AllCategoryState extends Equatable {
  const AllCategoryState();

  @override
  List<Object> get props => [];
}

class AllCategoryInitial extends AllCategoryState {}

class AllCategoryLoading extends AllCategoryState {}

class AllCategoryError extends AllCategoryState {
  final String error;
  AllCategoryError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}

class AllCategorySuccess extends AllCategoryState {
  final List<CategoryModel> categories;
  final int? currentPage;
  final int? lastPage;
  AllCategorySuccess({
    required this.categories,
    this.currentPage,
    this.lastPage,
  });
  @override
  List<Object> get props => [categories];
}
