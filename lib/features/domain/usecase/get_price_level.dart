import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetPriceLevel extends UseCase<String, GetPriceLevelParams> {
  GetPriceLevel(this._repository);

  @override
  Future<Either<String, String>> call(GetPriceLevelParams p) {
    return _repository.getPriceLevel(prodId: p.prodId, qty: p.qty);
  }

  final Repository _repository;
}

class GetPriceLevelParams {
  final int prodId;
  final int qty;
  GetPriceLevelParams({
    required this.prodId,
    required this.qty,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetPriceLevelParams &&
        other.prodId == prodId &&
        other.qty == qty;
  }

  @override
  int get hashCode => prodId.hashCode ^ qty.hashCode;

  GetPriceLevelParams copyWith({
    int? prodId,
    int? qty,
  }) {
    return GetPriceLevelParams(
      prodId: prodId ?? this.prodId,
      qty: qty ?? this.qty,
    );
  }

  @override
  String toString() => 'GetPriceLevelParams(prodId: $prodId, qty: $qty)';
}
