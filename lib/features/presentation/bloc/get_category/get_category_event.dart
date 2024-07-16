part of 'get_category_bloc.dart';

abstract class GetCategoryEvent extends Equatable {
  const GetCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryStarted extends GetCategoryEvent {
  final int? page;
  GetCategoryStarted({
    this.page,
  });
  @override
  List<Object> get props => [page ?? 0];
}

class GetCategoryUpdate extends GetCategoryEvent {
  final int? page;
  GetCategoryUpdate({
    this.page,
  });
  @override
  List<Object> get props => [page ?? 0];
}

class GetCategorySingleEvent extends GetCategoryEvent {
  final int categoryId;
  GetCategorySingleEvent({
    required this.categoryId,
  });
  @override
  List<Object> get props => [categoryId];
}
