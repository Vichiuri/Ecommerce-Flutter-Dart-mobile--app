// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as int,
      product_images: (json['product_images'] as List<dynamic>)
          .map((e) => ProductImagesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isNewArrivals: json['is_new_arrival'] as bool,
      category: json['category'] as int?,
      units: json['units'] == null
          ? null
          : UnitModel.fromJson(json['units'] as Map<String, dynamic>),
      name: json['name'] as String?,
      price_currency: json['price_currency'] as String?,
      price: json['price'] as String?,
      description: json['description'] as String?,
      stock_qty: json['stock_qty'] as int?,
      colors: (json['colors'] as List<dynamic>)
          .map((e) => ColorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      price_s: json['price_s'] as String?,
      color: json['color'] as String?,
      size: json['size'] as String?,
      brand: json['brand'] as String?,
      isFavourite: json['is_favorite'] as bool?,
      cartQty: json['cart_qty'] as int?,
      slabs: (json['slabs'] as List<dynamic>)
          .map((e) => SlabsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      briefDescription: json['brief_description'] as String?,
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_images': instance.product_images,
      'category': instance.category,
      'units': instance.units,
      'name': instance.name,
      'price_currency': instance.price_currency,
      'price': instance.price,
      'description': instance.description,
      'stock_qty': instance.stock_qty,
      'color': instance.color,
      'size': instance.size,
      'brand': instance.brand,
      'price_s': instance.price_s,
      'is_new_arrival': instance.isNewArrivals,
      'is_favorite': instance.isFavourite,
      'cart_qty': instance.cartQty,
      'slabs': instance.slabs,
      'colors': instance.colors,
      'brief_description': instance.briefDescription,
    };
