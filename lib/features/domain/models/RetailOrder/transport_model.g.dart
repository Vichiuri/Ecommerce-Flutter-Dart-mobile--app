// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransportModel _$TransportModelFromJson(Map<String, dynamic> json) =>
    TransportModel(
      transpoterName: json['transporter_name'] as String?,
      vehicle: json['vehicle_no'] as String?,
      date: json['date'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => ItemsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      phone: json['transporter_phone'] as String?,
    );

Map<String, dynamic> _$TransportModelToJson(TransportModel instance) =>
    <String, dynamic>{
      'transporter_name': instance.transpoterName,
      'vehicle_no': instance.vehicle,
      'date': instance.date,
      'items': instance.items,
      'transporter_phone': instance.phone,
    };

ItemsModel _$ItemsModelFromJson(Map<String, dynamic> json) => ItemsModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      quantity: json['quantity'] as int,
      image: json['pic'] as String?,
    );

Map<String, dynamic> _$ItemsModelToJson(ItemsModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'quantity': instance.quantity,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('pic', instance.image);
  return val;
}
