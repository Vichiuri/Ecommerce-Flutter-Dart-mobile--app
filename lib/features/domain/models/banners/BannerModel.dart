import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BannerModel.g.dart';

@JsonSerializable()
class BannerModel {
  final int id;
  final String name;
  final String text;
  final String? pic;
  final String status;
  final ProductModel? product;
  final OfferModel? offer;
  // final List<OfferModel>? offers;

  BannerModel({
    required this.status,
    required this.id,
    required this.name,
    required this.text,
    this.pic,
    this.product,
    this.offer,
    // this.offers,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}
