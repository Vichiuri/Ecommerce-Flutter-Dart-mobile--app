part of 'search_product_bloc.dart';

abstract class SearchProductEvent extends Equatable {
  const SearchProductEvent();

  @override
  List<Object> get props => [];
}

class SearchProductStarted extends SearchProductEvent {
  final String query;
  final int? maxPrice;
  final int? minPrice;
  final bool isNewArrival;
  final int? catId;

  @override
  List<Object> get props => [query];

  SearchProductStarted({
    required this.query,
    this.maxPrice,
    this.minPrice,
    this.isNewArrival = false,
    this.catId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchProductStarted &&
        other.query == query &&
        other.maxPrice == maxPrice &&
        other.minPrice == minPrice &&
        other.isNewArrival == isNewArrival &&
        other.catId == catId;
  }

  @override
  int get hashCode {
    return query.hashCode ^
        maxPrice.hashCode ^
        minPrice.hashCode ^
        isNewArrival.hashCode ^
        catId.hashCode;
  }

  @override
  String toString() {
    return 'SearchProductStarted(query: $query, maxPrice: $maxPrice, minPrice: $minPrice, isNewArrival: $isNewArrival, catId: $catId)';
  }
}
