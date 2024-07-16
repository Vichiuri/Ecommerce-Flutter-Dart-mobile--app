// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      category_pic: json['category_pic'] as String?,
      parent_category: json['parent_category'] as int?,
      productcount: json['productcount'] as int,
      subCateqory: (json['sub_categories'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category_pic': instance.category_pic,
      'parent_category': instance.parent_category,
      'productcount': instance.productcount,
      'sub_categories': instance.subCateqory,
    };
