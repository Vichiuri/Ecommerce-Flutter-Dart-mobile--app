import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transport_model.g.dart';

@JsonSerializable()
class TransportModel {
  @JsonKey(name: "transporter_name")
  final String? transpoterName;
  @JsonKey(name: "vehicle_no")
  final String? vehicle;
  @JsonKey(name: "date")
  final String? date;
  @JsonKey(name: "items")
  final List<ItemsModel> items;
  @JsonKey(name: "transporter_phone")
  final String? phone;

  TransportModel({
    required this.transpoterName,
    required this.vehicle,
    required this.date,
    required this.items,
    required this.phone,
  });
  factory TransportModel.fromJson(Map<String, dynamic> json) =>
      _$TransportModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransportModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransportModel &&
        other.transpoterName == transpoterName &&
        other.vehicle == vehicle &&
        other.date == date &&
        listEquals(other.items, items) &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return transpoterName.hashCode ^
        vehicle.hashCode ^
        date.hashCode ^
        items.hashCode ^
        phone.hashCode;
  }

  @override
  String toString() {
    return 'TransportModel(transpoterName: $transpoterName, vehicle: $vehicle, date: $date, items: $items, phone: $phone)';
  }
}

@JsonSerializable()
class ItemsModel {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "quantity")
  final int quantity;
  @JsonKey(name: "pic", includeIfNull: false)
  final String? image;

  ItemsModel({
    required this.id,
    required this.name,
    required this.quantity,
    this.image,
  });
  factory ItemsModel.fromJson(Map<String, dynamic> json) =>
      _$ItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsModelToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemsModel &&
        other.id == id &&
        other.name == name &&
        other.quantity == quantity &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ quantity.hashCode ^ image.hashCode;
  }

  @override
  String toString() {
    return 'ItemsModel(id: $id, name: $name, quantity: $quantity, image: $image)';
  }
}
