part of 'get_category_bloc.dart';

abstract class GetCategoryState extends Equatable {
  const GetCategoryState();

  @override
  List<Object> get props => [];
}

class GetCategoryInitial extends GetCategoryState {}

class GetCategoryLoading extends GetCategoryState {}

class GetCategoryUpdating extends GetCategoryState {}

class GetCategorySuccess extends GetCategoryState {
  final DashBoardResponse response;
  GetCategorySuccess({
    required this.response,
  });
  @override
  List<Object> get props => [response];
}

class GetCategoryError extends GetCategoryState {
  final String message;
  GetCategoryError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
