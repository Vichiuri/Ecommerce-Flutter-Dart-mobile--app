import 'package:json_annotation/json_annotation.dart';

part 'ProductImagesModel.g.dart';

@JsonSerializable()
class ProductImagesModel {
  final int id;
  final String? image;

  ProductImagesModel({required this.id, required this.image});

  factory ProductImagesModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImagesModelToJson(this);
}
