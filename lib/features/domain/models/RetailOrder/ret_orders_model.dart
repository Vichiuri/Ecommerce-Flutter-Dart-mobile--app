import 'package:json_annotation/json_annotation.dart';

import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';

part 'ret_orders_model.g.dart';

@JsonSerializable()
class RetOrderModel {
  RetOrderModel({
    required this.id,
    required this.product,
    required this.orderDate,
    required this.qty,
    required this.perPrice,
    required this.delivered,
    required this.placed,
    required this.orderPriceCurrency,
    required this.orderPrice,
    required this.remainingAmount,
    required this.freeQty,
    required this.totalQty,
    required this.deliveredQty,
    this.appliedOffer,
    this.variant,
    required this.distributor,
  });

  factory RetOrderModel.fromJson(Map<String, dynamic> json) =>
      _$RetOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$RetOrderModelToJson(this);

  final int id;
  final ProductModel product;
  @JsonKey(name: "order_date")
  final DateTime orderDate;
  final double qty;
  @JsonKey(name: "per_price")
  final String perPrice;
  final bool delivered;
  final bool placed;
  @JsonKey(name: "order_price_currency")
  final String orderPriceCurrency;
  @JsonKey(name: "order_price")
  final String orderPrice;
  @JsonKey(name: "remaining_amount")
  final double remainingAmount;
  @JsonKey(name: "free_qty")
  final double freeQty;
  @JsonKey(name: "total_qty")
  final double totalQty;
  @JsonKey(name: "delivered_qty")
  final double deliveredQty;
  @JsonKey(name: "applied_offer")
  final String? appliedOffer;
  final String? variant;
  final double distributor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RetOrderModel &&
        other.id == id &&
        other.product == product &&
        other.orderDate == orderDate &&
        other.qty == qty &&
        other.perPrice == perPrice &&
        other.delivered == delivered &&
        other.placed == placed &&
        other.orderPriceCurrency == orderPriceCurrency &&
        other.orderPrice == orderPrice &&
        other.remainingAmount == remainingAmount &&
        other.freeQty == freeQty &&
        other.totalQty == totalQty &&
        other.deliveredQty == deliveredQty &&
        other.appliedOffer == appliedOffer &&
        other.variant == variant &&
        other.distributor == distributor;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        product.hashCode ^
        orderDate.hashCode ^
        qty.hashCode ^
        perPrice.hashCode ^
        delivered.hashCode ^
        placed.hashCode ^
        orderPriceCurrency.hashCode ^
        orderPrice.hashCode ^
        remainingAmount.hashCode ^
        freeQty.hashCode ^
        totalQty.hashCode ^
        deliveredQty.hashCode ^
        appliedOffer.hashCode ^
        variant.hashCode ^
        distributor.hashCode;
  }

  @override
  String toString() {
    return 'RetOrderModel(id: $id, product: $product, orderDate: $orderDate, qty: $qty, perPrice: $perPrice, delivered: $delivered, placed: $placed, orderPriceCurrency: $orderPriceCurrency, orderPrice: $orderPrice, remainingAmount: $remainingAmount, freeQty: $freeQty, totalQty: $totalQty, deliveredQty: $deliveredQty, appliedOffer: $appliedOffer, variant: $variant, distributor: $distributor)';
  }
}
