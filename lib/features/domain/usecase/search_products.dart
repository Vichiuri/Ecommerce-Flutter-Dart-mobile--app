import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';

@lazySingleton
class SearchProducts extends UseCase<DashBoardResponse, SearchProductParams> {
  SearchProducts(this._repository);

  @override
  Future<Either<String, DashBoardResponse>> call(SearchProductParams p) {
    return _repository.searchProducts(
      query: p.query,
      maxPrice: p.maxPrice,
      minPrice: p.minPrice,
      isNewArrival: p.isNewArrival,
      catId: p.catId,
    );
  }

  final Repository _repository;
}

class SearchProductParams {
  final String query;
  final int? maxPrice;
  final int? minPrice;
  final bool isNewArrival;
  final int? catId;
  SearchProductParams({
    required this.query,
    this.maxPrice,
    this.minPrice,
    required this.isNewArrival,
    this.catId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchProductParams &&
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

  SearchProductParams copyWith({
    String? query,
    int? maxPrice,
    int? minPrice,
    bool? isNewArrival,
    int? catId,
  }) {
    return SearchProductParams(
      query: query ?? this.query,
      maxPrice: maxPrice ?? this.maxPrice,
      minPrice: minPrice ?? this.minPrice,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      catId: catId ?? this.catId,
    );
  }

  @override
  String toString() {
    return 'SearchProductParams(query: $query, maxPrice: $maxPrice, minPrice: $minPrice, isNewArrival: $isNewArrival, catId: $catId)';
  }
}
