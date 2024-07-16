// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutModel _$AboutModelFromJson(Map<String, dynamic> json) => AboutModel(
      about: json['about'] as String?,
      terms: json['terms'] as String?,
      privacy: json['privacy'] as String?,
    );

Map<String, dynamic> _$AboutModelToJson(AboutModel instance) =>
    <String, dynamic>{
      'about': instance.about,
      'terms': instance.terms,
      'privacy': instance.privacy,
    };
