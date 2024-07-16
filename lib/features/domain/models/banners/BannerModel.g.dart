// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BannerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
      status: json['status'] as String,
      id: json['id'] as int,
      name: json['name'] as String,
      text: json['text'] as String,
      pic: json['pic'] as String?,
      product: json['product'] == null
          ? null
          : ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      offer: json['offer'] == null
          ? null
          : OfferModel.fromJson(json['offer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'text': instance.text,
      'pic': instance.pic,
      'status': instance.status,
      'product': instance.product,
      'offer': instance.offer,
    };
