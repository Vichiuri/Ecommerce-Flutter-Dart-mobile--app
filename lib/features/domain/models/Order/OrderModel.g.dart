// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as int,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      order_date: json['order_date'] as String,
      qty: json['qty'] as int,
      placed: json['placed'] as bool,
      order_price_currency: json['order_price_currency'] as String,
      order_price: json['order_price'] as String,
      applied_offer: json['applied_offer'] as String?,
      free_qty: json['free_qty'] as int?,
      pricePer: json['per_price'] as String?,
      total_qty: json['total_qty'] as int?,
      offer_id: json['offer_id'] as int?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'order_date': instance.order_date,
      'qty': instance.qty,
      'placed': instance.placed,
      'order_price_currency': instance.order_price_currency,
      'order_price': instance.order_price,
      'applied_offer': instance.applied_offer,
      'free_qty': instance.free_qty,
      'total_qty': instance.total_qty,
      'offer_id': instance.offer_id,
      'per_price': instance.pricePer,
    };
