import 'package:json_annotation/json_annotation.dart';

part 'sync_model.g.dart';

@JsonSerializable()
class SyncModel {
  @JsonKey(name: "product_id")
  final int productId;
  @JsonKey(name: "cart_qty")
  final int cartQty;
  @JsonKey(name: "retailer_id")
  final int retId;

  SyncModel({required int productId, required int cartQty, required int retId})
      : productId = productId,
        cartQty = cartQty,
        retId = retId;

  factory SyncModel.fromJson(Map<String, dynamic> json) =>
      _$SyncModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncModelToJson(this);

  SyncModel copyWith({
    int? productId,
    int? cartQty,
    int? retId,
  }) {
    return SyncModel(
      productId: productId ?? this.productId,
      cartQty: cartQty ?? this.cartQty,
      retId: retId ?? this.retId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SyncModel &&
        other.productId == productId &&
        other.cartQty == cartQty &&
        other.retId == retId;
  }

  @override
  int get hashCode => productId.hashCode ^ cartQty.hashCode ^ retId.hashCode;

  @override
  String toString() =>
      'SyncModel(productId: $productId, cartQty: $cartQty, retId: $retId)';
}
