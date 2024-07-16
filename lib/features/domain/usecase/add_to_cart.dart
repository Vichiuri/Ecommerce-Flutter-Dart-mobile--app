import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/ApiSuccessResponse.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';

@lazySingleton
class AddToCart extends UseCase<ApiSuccessResponse, AddToCartParams> {
  AddToCart(this._repository);

  @override
  Future<Either<String, ApiSuccessResponse>> call(AddToCartParams p) {
    return _repository.addToCart(
      qty: p.qty,
      action: p.action,
      prodId: p.prodId,
      product: p.product,
    );
  }

  final Repository _repository;
}

class AddToCartParams {
  final String qty;
  final String action;
  final int prodId;
  final ProductModel product;

  AddToCartParams({
    required this.qty,
    required this.action,
    required this.prodId,
    required this.product,
  });

  AddToCartParams copyWith({
    String? qty,
    String? action,
    int? prodId,
    ProductModel? product,
  }) {
    return AddToCartParams(
      qty: qty ?? this.qty,
      action: action ?? this.action,
      prodId: prodId ?? this.prodId,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'qty': qty,
      'action': action,
      'prodId': prodId,
      'product': product.toJson(),
    };
  }

  factory AddToCartParams.fromMap(Map<String, dynamic> map) {
    return AddToCartParams(
      qty: map['qty'],
      action: map['action'],
      prodId: map['prodId'],
      product: ProductModel.fromJson(map['product']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddToCartParams.fromJson(String source) =>
      AddToCartParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddToCartParams(qty: $qty, action: $action, prodId: $prodId, product: $product)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddToCartParams &&
        other.qty == qty &&
        other.action == action &&
        other.prodId == prodId &&
        other.product == product;
  }

  @override
  int get hashCode {
    return qty.hashCode ^ action.hashCode ^ prodId.hashCode ^ product.hashCode;
  }
}
