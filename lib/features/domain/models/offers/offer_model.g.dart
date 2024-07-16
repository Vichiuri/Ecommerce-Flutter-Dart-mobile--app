// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferModel _$OfferModelFromJson(Map<String, dynamic> json) => OfferModel(
      id: json['id'] as int,
      xItem: ProductModel.fromJson(json['x_item'] as Map<String, dynamic>),
      yItem: json['y_item'] == null
          ? null
          : ProductModel.fromJson(json['y_item'] as Map<String, dynamic>),
      name: json['name'] as String,
      scheme: json['scheme'] as String,
      xAmt: json['x_amt'] as int,
      yAmt: json['y_amt'] as int,
      dateFrom: json['date_from'] as String,
      dateTo: json['date_to'] as String,
      pic: json['pic'] as String,
      detailName: json['detail_name'] as String,
    );

Map<String, dynamic> _$OfferModelToJson(OfferModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'x_item': instance.xItem,
      'y_item': instance.yItem,
      'name': instance.name,
      'scheme': instance.scheme,
      'x_amt': instance.xAmt,
      'y_amt': instance.yAmt,
      'date_from': instance.dateFrom,
      'date_to': instance.dateTo,
      'pic': instance.pic,
      'detail_name': instance.detailName,
    };
