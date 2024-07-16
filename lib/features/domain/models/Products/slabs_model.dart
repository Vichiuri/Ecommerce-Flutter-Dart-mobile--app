import 'package:json_annotation/json_annotation.dart';
part 'slabs_model.g.dart';

@JsonSerializable()
class SlabsModel {
  final int min;
  final int max;
  final String? rate;
  @JsonKey(name: "discount_amount")
  final String? discountAmmount;
  @JsonKey(name: "discount_percent")
  final String? discountPercent;

  SlabsModel({
    required this.min,
    required this.max,
    required this.rate,
    required this.discountAmmount,
    required this.discountPercent,
  });

  factory SlabsModel.fromJson(Map<String, dynamic> json) =>
      _$SlabsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SlabsModelToJson(this);
}
