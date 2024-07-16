import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/ApiSuccessResponse.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';

@lazySingleton
class AddSingleToCart
    extends UseCase<ApiSuccessResponse, AddSingleToCartParams> {
  AddSingleToCart(this._repository);

  @override
  Future<Either<String, ApiSuccessResponse>> call(
      AddSingleToCartParams params) {
    return _repository.addSingleToCart(
      prodId: params.prodId,
      prod: params.product,
    );
  }

  final Repository _repository;
}

class AddSingleToCartParams {
  final int prodId;
  final ProductModel product;
  final int? ret;

  AddSingleToCartParams({
    required this.prodId,
    required this.product,
    this.ret,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddSingleToCartParams &&
        other.prodId == prodId &&
        other.product == product &&
        other.ret == ret;
  }

  @override
  int get hashCode => prodId.hashCode ^ product.hashCode ^ ret.hashCode;

  @override
  String toString() =>
      'AddSingleToCartParams(prodId: $prodId, product: $product, ret: $ret)';
}
