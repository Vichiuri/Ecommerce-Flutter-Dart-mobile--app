import 'dart:convert';

import 'CartModel.dart';

class SalesManCartModel {
  final RetailerSalesModel retailer;
  final CartModel cart;
  SalesManCartModel({
    required this.retailer,
    required this.cart,
  });

  SalesManCartModel copyWith({
    RetailerSalesModel? retailer,
    CartModel? cart,
  }) {
    return SalesManCartModel(
      retailer: retailer ?? this.retailer,
      cart: cart ?? this.cart,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'retailer': retailer.toMap(),
      'cart': cart.toJson(),
    };
  }

  factory SalesManCartModel.fromMap(Map<String, dynamic> map) {
    return SalesManCartModel(
      retailer: RetailerSalesModel.fromMap(map['retailer']),
      cart: CartModel.fromJson(map['cart']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesManCartModel.fromJson(String source) =>
      SalesManCartModel.fromMap(json.decode(source));

  @override
  String toString() => 'SalesManCartModel(retailer: $retailer, cart: $cart)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SalesManCartModel &&
        other.retailer == retailer &&
        other.cart == cart;
  }

  @override
  int get hashCode => retailer.hashCode ^ cart.hashCode;
}

class RetailerSalesModel {
  final int id;
  final String name;
  RetailerSalesModel({
    required this.id,
    required this.name,
  });

  RetailerSalesModel copyWith({
    int? id,
    String? name,
  }) {
    return RetailerSalesModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory RetailerSalesModel.fromMap(Map<String, dynamic> map) {
    return RetailerSalesModel(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RetailerSalesModel.fromJson(String source) =>
      RetailerSalesModel.fromMap(json.decode(source));

  @override
  String toString() => 'RetailerSalesModel(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RetailerSalesModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
