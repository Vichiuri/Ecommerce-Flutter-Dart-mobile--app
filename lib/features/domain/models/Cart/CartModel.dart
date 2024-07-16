import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:biz_mobile_app/features/domain/models/Order/OrderModel.dart';

part 'CartModel.g.dart';

@JsonSerializable()
class CartModel {
  final int id;
  final List<OrderModel> orders;
  final String? total;

  CartModel({required this.id, required this.orders, this.total});

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  CartModel.fromOffline(this.orders, {String? total})
      : id = 1,
        total = total ?? "Offline";

  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  CartModel copyWith({
    int? id,
    List<OrderModel>? orders,
    String? total,
  }) {
    return CartModel(
      id: id ?? this.id,
      orders: orders ?? this.orders,
      total: total ?? this.total,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartModel &&
        other.id == id &&
        listEquals(other.orders, orders) &&
        other.total == total;
  }

  @override
  int get hashCode => id.hashCode ^ orders.hashCode ^ total.hashCode;
}
