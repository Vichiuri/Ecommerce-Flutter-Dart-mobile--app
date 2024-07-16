import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';
import 'package:json_annotation/json_annotation.dart';

import '../Products/ProductsModel.dart';
import '../distributors/Distributors.dart';

part 'OrderModel.g.dart';

@JsonSerializable()
class OrderModel {
  final int id;
  final ProductModel product;
  final String order_date;
  final int qty;
  final bool placed;
  final String order_price_currency;
  final String order_price;
  final String? applied_offer;
  final int? free_qty;
  final int? total_qty;
  final int? offer_id;

  @JsonKey(name: "per_price")
  final String? pricePer;

  OrderModel({
    required this.id,
    required this.product,
    required this.order_date,
    required this.qty,
    required this.placed,
    required this.order_price_currency,
    required this.order_price,
    this.applied_offer,
    required this.free_qty,
    this.pricePer,
    required this.total_qty,
    this.offer_id,
  });

  OrderModel.fromOffline(
      {required this.product, required this.qty, required String retName})
      : id = 1,
        order_date = DateTime.now().toString(),
        placed = false,
        order_price_currency = "",
        order_price = "Offline",
        applied_offer = null,
        free_qty = null,
        total_qty = null,
        offer_id = null,
        pricePer = "Offline";

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
