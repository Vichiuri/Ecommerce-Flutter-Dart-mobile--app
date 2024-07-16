import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';

@lazySingleton
class GetPaginatedProduct
    extends UseCase<DashBoardResponse, GetPaginatedProductParams> {
  GetPaginatedProduct(this._repository);

  @override
  Future<Either<String, DashBoardResponse>> call(GetPaginatedProductParams p) {
    return _repository.fetchPaginatedProduct(
        page: p.page,
        maxPrice: p.maxPrice,
        minPrice: p.minPrice,
        isNewArrival: p.isNewArrival,
        catId: p.catId);
  }

  final Repository _repository;
}

class GetPaginatedProductParams {
  final int? maxPrice;
  final int? page;
  final int? minPrice;
  final bool isNewArrival;
  final int? catId;
  GetPaginatedProductParams({
    this.maxPrice,
    required this.page,
    this.minPrice,
    required this.isNewArrival,
    this.catId,
  });

  GetPaginatedProductParams copyWith({
    int? maxPrice,
    int? page,
    int? minPrice,
    bool? isNewArrival,
    int? catId,
  }) {
    return GetPaginatedProductParams(
      maxPrice: maxPrice ?? this.maxPrice,
      page: page ?? this.page,
      minPrice: minPrice ?? this.minPrice,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      catId: catId ?? this.catId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetPaginatedProductParams &&
        other.maxPrice == maxPrice &&
        other.page == page &&
        other.minPrice == minPrice &&
        other.isNewArrival == isNewArrival &&
        other.catId == catId;
  }

  @override
  int get hashCode {
    return maxPrice.hashCode ^
        page.hashCode ^
        minPrice.hashCode ^
        isNewArrival.hashCode ^
        catId.hashCode;
  }

  @override
  String toString() {
    return 'GetPaginatedProductParams(maxPrice: $maxPrice, page: $page, minPrice: $minPrice, isNewArrival: $isNewArrival, catId: $catId)';
  }
}
