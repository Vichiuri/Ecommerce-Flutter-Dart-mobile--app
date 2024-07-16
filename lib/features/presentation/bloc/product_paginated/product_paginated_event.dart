part of 'product_paginated_bloc.dart';

abstract class ProductPaginatedEvent extends Equatable {
  const ProductPaginatedEvent();

  @override
  List<Object> get props => [];
}

class GetProductPaginatedEvent extends ProductPaginatedEvent {
  final int? page;
  final List<ProductModel> product;
  final double position;
  final int? maxPrice;
  final int? minPrice;
  final bool isNewArrival;
  final int? catId;

  GetProductPaginatedEvent({
    this.page,
    required this.product,
    required this.position,
    this.maxPrice,
    this.minPrice,
    this.isNewArrival = false,
    this.catId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetProductPaginatedEvent &&
        other.page == page &&
        listEquals(other.product, product) &&
        other.position == position &&
        other.maxPrice == maxPrice &&
        other.minPrice == minPrice &&
        other.isNewArrival == isNewArrival &&
        other.catId == catId;
  }

  @override
  int get hashCode {
    return page.hashCode ^
        product.hashCode ^
        position.hashCode ^
        maxPrice.hashCode ^
        minPrice.hashCode ^
        isNewArrival.hashCode ^
        catId.hashCode;
  }
}

class GetProductPaginatedUpdate extends ProductPaginatedEvent {
  final int? page;
  final List<ProductModel> product;
  final double position;

  GetProductPaginatedUpdate({
    this.page,
    required this.product,
    required this.position,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetProductPaginatedUpdate &&
        other.page == page &&
        listEquals(other.product, product) &&
        other.position == position;
  }

  @override
  int get hashCode => page.hashCode ^ product.hashCode ^ position.hashCode;
}

// class GetNewArrivalePaginatedEvent extends ProductPaginatedEvent {
//   final int? page;
//   final List<ProductModel> product;
//   final double position;

//   GetNewArrivalePaginatedEvent({
//     this.page,
//     required this.product,
//     required this.position,
//   });

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is GetNewArrivalePaginatedEvent &&
//         other.page == page &&
//         listEquals(other.product, product) &&
//         other.position == position;
//   }

//   @override
//   int get hashCode => page.hashCode ^ product.hashCode ^ position.hashCode;
// }
