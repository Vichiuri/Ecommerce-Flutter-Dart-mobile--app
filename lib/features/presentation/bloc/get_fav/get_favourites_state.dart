part of 'get_favourites_bloc.dart';

abstract class GetFavouritesState extends Equatable {
  const GetFavouritesState();

  @override
  List<Object> get props => [];
}

class GetFavouritesInitial extends GetFavouritesState {}

class GetFavouritesLoading extends GetFavouritesState {}

class GetFavouritesUpdating extends GetFavouritesState {}

class GetFavouritesPaginating extends GetFavouritesState {}

class GetFavouritesSuccess extends GetFavouritesState {
  final List<ProductModel> products;
  final int? lastPage;
  final int? currentPage;
  GetFavouritesSuccess({
    required this.products,
    required this.lastPage,
    required this.currentPage,
  });

  @override
  List<Object> get props => [products];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetFavouritesSuccess &&
        listEquals(other.products, products) &&
        other.lastPage == lastPage &&
        other.currentPage == currentPage;
  }

  @override
  int get hashCode =>
      products.hashCode ^ lastPage.hashCode ^ currentPage.hashCode;
}

class GetFavouritesError extends GetFavouritesState {
  final String message;

  GetFavouritesError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class GetFavouritesPaginatedError extends GetFavouritesState {
  final String message;

  GetFavouritesPaginatedError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
