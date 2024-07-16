import 'dart:convert';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/ApiSuccessResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

//usecases are the siple functions, this does the work the name says

@lazySingleton
class AddOfferToCart extends UseCase<ApiSuccessResponse, AddOfferToCartParam> {
  AddOfferToCart(this._repository);

  @override
  Future<Either<String, ApiSuccessResponse>> call(AddOfferToCartParam params) {
    return _repository.addOfferToCart(qty: params.qty, offerId: params.offerId);
  }

  final Repository _repository;
}

class AddOfferToCartParam {
  final int offerId;
  final int qty;
  AddOfferToCartParam({
    required this.offerId,
    required this.qty,
  });

  AddOfferToCartParam copyWith({
    int? offerId,
    int? qty,
  }) {
    return AddOfferToCartParam(
      offerId: offerId ?? this.offerId,
      qty: qty ?? this.qty,
    );
  }

  @override
  String toString() => 'AddOfferToCartParam(offerId: $offerId, qty: $qty)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddOfferToCartParam &&
        other.offerId == offerId &&
        other.qty == qty;
  }

  @override
  int get hashCode => offerId.hashCode ^ qty.hashCode;
}
