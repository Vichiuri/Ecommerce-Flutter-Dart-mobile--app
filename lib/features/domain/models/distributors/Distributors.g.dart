// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Distributors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistributorsModel _$DistributorsModelFromJson(Map<String, dynamic> json) =>
    DistributorsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      about: json['about_company'] == null
          ? null
          : AboutModel.fromJson(json['about_company'] as Map<String, dynamic>),
      website: json['website'] as String?,
      address: json['address'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$DistributorsModelToJson(DistributorsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'website': instance.website,
      'address': instance.address,
      'description': instance.description,
      'category': instance.category,
      'logo': instance.logo,
      'about_company': instance.about,
    };
