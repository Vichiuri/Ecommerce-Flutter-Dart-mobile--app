import 'package:biz_mobile_app/features/domain/models/Products/color_model.dart';
import 'package:biz_mobile_app/features/domain/models/Products/slabs_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../Category/CategoryModel.dart';
import '../ProductImages/ProductImagesModel.dart';
import '../Units/UnitModel.dart';

part 'ProductsModel.g.dart';

@JsonSerializable()
class ProductModel {
  final int id;
  final List<ProductImagesModel> product_images;
  final int? category;
  final UnitModel? units;
  final String? name;
  final String? price_currency;
  final String? price;
  final String? description;
  final int? stock_qty;
  final String? color;
  final String? size;
  final String? brand;
  final String? price_s;
  @JsonKey(name: "is_new_arrival")
  final bool isNewArrivals;
  @JsonKey(name: "is_favorite")
  final bool? isFavourite;
  @JsonKey(name: "cart_qty")
  final int? cartQty;
  final List<SlabsModel> slabs;
  final List<ColorModel> colors;
  @JsonKey(name: "brief_description")
  final String? briefDescription;

  ProductModel({
    required this.id,
    required this.product_images,
    required this.isNewArrivals,
    this.category,
    this.units,
    required this.name,
    required this.price_currency,
    required this.price,
    this.description,
    this.stock_qty,
    required this.colors,
    this.price_s,
    this.color,
    this.size,
    this.brand,
    this.isFavourite,
    this.cartQty,
    required this.slabs,
    this.briefDescription,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
