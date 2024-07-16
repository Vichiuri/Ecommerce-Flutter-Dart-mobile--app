import 'dart:convert';

class CartQuantity {
  final int quantity;

  CartQuantity({
    required this.quantity,
  });

  CartQuantity copyWith({
    int? quantity,
  }) {
    return CartQuantity(
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cart_qty': quantity,
    };
  }

  factory CartQuantity.fromMap(Map<String, dynamic> map) {
    return CartQuantity(
      quantity: map['cart_qty'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartQuantity.fromJson(String source) =>
      CartQuantity.fromMap(json.decode(source));

  @override
  String toString() => 'CartQuantity(quantity: $quantity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartQuantity && other.quantity == quantity;
  }

  @override
  int get hashCode => quantity.hashCode;
}
