part of 'get_favourites_bloc.dart';

abstract class GetFavouritesEvent extends Equatable {
  const GetFavouritesEvent();

  @override
  List<Object> get props => [];
}

class GetFavouritesStarted extends GetFavouritesEvent {
  final int? page;
  final List<ProductModel> products;
  GetFavouritesStarted({
    required this.page,
    required this.products,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetFavouritesStarted &&
        other.page == page &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode => page.hashCode ^ products.hashCode;

  GetFavouritesStarted copyWith({
    int? page,
    List<ProductModel>? products,
  }) {
    return GetFavouritesStarted(
      page: page ?? this.page,
      products: products ?? this.products,
    );
  }
}

class GetFavouritePaginated extends GetFavouritesEvent {
  final int? page;
  final List<ProductModel> products;
  GetFavouritePaginated({
    required this.page,
    required this.products,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetFavouritePaginated &&
        other.page == page &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode => page.hashCode ^ products.hashCode;

  GetFavouritePaginated copyWith({
    int? page,
    List<ProductModel>? products,
  }) {
    return GetFavouritePaginated(
      page: page ?? this.page,
      products: products ?? this.products,
    );
  }
}

class GetFavouritesUpdated extends GetFavouritesEvent {}
