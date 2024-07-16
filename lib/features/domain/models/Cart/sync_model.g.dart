// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncModel _$SyncModelFromJson(Map<String, dynamic> json) => SyncModel(
      productId: json['product_id'] as int,
      cartQty: json['cart_qty'] as int,
      retId: json['retailer_id'] as int,
    );

Map<String, dynamic> _$SyncModelToJson(SyncModel instance) => <String, dynamic>{
      'product_id': instance.productId,
      'cart_qty': instance.cartQty,
      'retailer_id': instance.retId,
    };
