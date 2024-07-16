// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RetailerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RetailerModel _$RetailerModelFromJson(Map<String, dynamic> json) =>
    RetailerModel(
      id: json['id'] as int,
      pinNo: json['pin_no'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      pic: json['pic'] as String?,
      distributors: (json['distributors'] as List<dynamic>?)
          ?.map((e) => DistributorsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RetailerModelToJson(RetailerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pin_no': instance.pinNo,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'pic': instance.pic,
      'distributors': instance.distributors,
    };
