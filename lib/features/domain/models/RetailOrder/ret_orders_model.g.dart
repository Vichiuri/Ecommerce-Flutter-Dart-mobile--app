// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ret_orders_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetOrderModel _$RetOrderModelFromJson(Map<String, dynamic> json) =>
    RetOrderModel(
      id: json['id'] as int,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      orderDate: DateTime.parse(json['order_date'] as String),
      qty: (json['qty'] as num).toDouble(),
      perPrice: json['per_price'] as String,
      delivered: json['delivered'] as bool,
      placed: json['placed'] as bool,
      orderPriceCurrency: json['order_price_currency'] as String,
      orderPrice: json['order_price'] as String,
      remainingAmount: (json['remaining_amount'] as num).toDouble(),
      freeQty: (json['free_qty'] as num).toDouble(),
      totalQty: (json['total_qty'] as num).toDouble(),
      deliveredQty: (json['delivered_qty'] as num).toDouble(),
      appliedOffer: json['applied_offer'] as String?,
      variant: json['variant'] as String?,
      distributor: (json['distributor'] as num).toDouble(),
    );

Map<String, dynamic> _$RetOrderModelToJson(RetOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'order_date': instance.orderDate.toIso8601String(),
      'qty': instance.qty,
      'per_price': instance.perPrice,
      'delivered': instance.delivered,
      'placed': instance.placed,
      'order_price_currency': instance.orderPriceCurrency,
      'order_price': instance.orderPrice,
      'remaining_amount': instance.remainingAmount,
      'free_qty': instance.freeQty,
      'total_qty': instance.totalQty,
      'delivered_qty': instance.deliveredQty,
      'applied_offer': instance.appliedOffer,
      'variant': instance.variant,
      'distributor': instance.distributor,
    };
