import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_model.g.dart';

@JsonSerializable()
class OfferModel {
  OfferModel({
    required this.id,
    required this.xItem,
    this.yItem,
    required this.name,
    required this.scheme,
    required this.xAmt,
    required this.yAmt,
    required this.dateFrom,
    required this.dateTo,
    required this.pic,
    required this.detailName,
  });

  final int id;
  @JsonKey(name: "x_item")
  final ProductModel xItem;
  @JsonKey(name: "y_item")
  final ProductModel? yItem;
  final String name;
  final String scheme;
  @JsonKey(name: "x_amt")
  final int xAmt;
  @JsonKey(name: "y_amt")
  final int yAmt;
  @JsonKey(name: "date_from")
  final String dateFrom;
  @JsonKey(name: "date_to")
  final String dateTo;
  final String pic;
  @JsonKey(name: "detail_name")
  final String detailName;

  factory OfferModel.fromJson(Map<String, dynamic> json) =>
      _$OfferModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfferModelToJson(this);
}
