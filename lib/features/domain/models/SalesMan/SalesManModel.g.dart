// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SalesManModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesManModel _$SalesManModelFromJson(Map<String, dynamic> json) =>
    SalesManModel(
      pic: json['pic'] as String?,
      id: json['id'] as int,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      distributor: DistributorsModel.fromJson(
          json['distributor'] as Map<String, dynamic>),
      retailers: (json['retailers'] as List<dynamic>?)
          ?.map((e) => RetailerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SalesManModelToJson(SalesManModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'phone': instance.phone,
      'email': instance.email,
      'pic': instance.pic,
      'distributor': instance.distributor,
      'retailers': instance.retailers,
    };
