// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slabs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlabsModel _$SlabsModelFromJson(Map<String, dynamic> json) => SlabsModel(
      min: json['min'] as int,
      max: json['max'] as int,
      rate: json['rate'] as String?,
      discountAmmount: json['discount_amount'] as String?,
      discountPercent: json['discount_percent'] as String?,
    );

Map<String, dynamic> _$SlabsModelToJson(SlabsModel instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'rate': instance.rate,
      'discount_amount': instance.discountAmmount,
      'discount_percent': instance.discountPercent,
    };
