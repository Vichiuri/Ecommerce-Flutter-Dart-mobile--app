part of 'new_arrivals_bloc.dart';

abstract class NewArrivalsEvent extends Equatable {
  const NewArrivalsEvent();

  @override
  List<Object> get props => [];
}

class GetNewArrivalePaginatedEvent extends NewArrivalsEvent {
  final int? page;
  final List<ProductModel> product;
  final double position;

  GetNewArrivalePaginatedEvent({
    this.page,
    required this.product,
    required this.position,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetNewArrivalePaginatedEvent &&
        other.page == page &&
        listEquals(other.product, product) &&
        other.position == position;
  }

  @override
  int get hashCode => page.hashCode ^ product.hashCode ^ position.hashCode;
}

class UpdateNewArrivals extends NewArrivalsEvent {
  final int? page;
  final List<ProductModel> product;
  final double position;

  UpdateNewArrivals({
    this.page,
    required this.product,
    required this.position,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateNewArrivals &&
        other.page == page &&
        listEquals(other.product, product) &&
        other.position == position;
  }

  @override
  int get hashCode => page.hashCode ^ product.hashCode ^ position.hashCode;
}
