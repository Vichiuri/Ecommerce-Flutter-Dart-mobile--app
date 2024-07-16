import 'package:json_annotation/json_annotation.dart';

part 'CategoryModel.g.dart';

@JsonSerializable()
class CategoryModel {
  final int id;
  final String? name;
  final String? category_pic;
  // final String? description;
  final int? parent_category;
  final int productcount;
  @JsonKey(name: "sub_categories")
  final List<int> subCateqory;
  // final String product_num;

  CategoryModel({
    required this.id,
    required this.name,
    this.category_pic,
    // this.description,
    this.parent_category,
    required this.productcount,
    required this.subCateqory,
    // required this.product_num,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
