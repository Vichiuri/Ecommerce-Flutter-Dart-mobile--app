// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListNotificationModel _$ListNotificationModelFromJson(
        Map<String, dynamic> json) =>
    ListNotificationModel(
      id: json['id'],
      distributor: json['distributor'],
      product: json['product'],
      offer: json['offer'],
      name: json['name'],
      order: json['order'],
      display_text: json['display_text'],
      detail: json['detail'],
      pic: json['pic'],
      status: json['status'],
    );

Map<String, dynamic> _$ListNotificationModelToJson(
        ListNotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'distributor': instance.distributor,
      'product': instance.product,
      'offer': instance.offer,
      'order': instance.order,
      'name': instance.name,
      'display_text': instance.display_text,
      'detail': instance.detail,
      'pic': instance.pic,
      'status': instance.status,
    };
