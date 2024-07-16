part of 'add_to_cart_bloc.dart';

abstract class AddToCartEvent extends Equatable {
  const AddToCartEvent();

  @override
  List<Object> get props => [];
}

class AddToCartStarted extends AddToCartEvent {
  final String qty;
  final String action;
  final int prodId;
  final ProductModel product;

  AddToCartStarted({
    required this.qty,
    required this.action,
    required this.prodId,
    required this.product,
  });

  @override
  List<Object> get props => [qty, action, product, prodId];
}

class AddToCartSingle extends AddToCartEvent {
  @override
  List<Object> get props => [prodId, product];
  final int prodId;
  final ProductModel product;
  AddToCartSingle({
    required this.prodId,
    required this.product,
  });

  @override
  String toString() => 'AddToCartSingle(prodId: $prodId, product: $product)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddToCartSingle &&
        other.prodId == prodId &&
        other.product == product;
  }

  @override
  int get hashCode => prodId.hashCode ^ product.hashCode;

  AddToCartSingle copyWith({
    int? prodId,
    ProductModel? product,
  }) {
    return AddToCartSingle(
      prodId: prodId ?? this.prodId,
      product: product ?? this.product,
    );
  }
}
