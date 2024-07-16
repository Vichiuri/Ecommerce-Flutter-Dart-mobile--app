import 'dart:convert';

import 'package:biz_mobile_app/features/domain/models/ProductImages/ProductImagesModel.dart';
import 'package:biz_mobile_app/features/domain/models/Products/color_model.dart';
import 'package:biz_mobile_app/features/domain/models/Products/slabs_model.dart';
import 'package:biz_mobile_app/features/domain/models/Units/UnitModel.dart';
import 'package:moor/moor.dart';

@DataClassName("ProductDataClass")
class ProductTable extends Table {
  IntColumn get id => integer()();
  IntColumn get category => integer().nullable()();
  TextColumn get product_images =>
      text().map(const ProductImagesModelConverter())();
  TextColumn get units => text().map(const UnitModelConverter()).nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get price_currency => text().nullable()();
  TextColumn get price => text().nullable()();
  IntColumn get stock_qty => integer().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get size => text().nullable()();
  TextColumn get brand => text().nullable()();
  TextColumn get price_s => text().nullable()();
  BoolColumn get isNewArrivals => boolean()();
  BoolColumn get isFavourite => boolean().nullable()();
  IntColumn get cartQty => integer().nullable()();
  TextColumn get colors => text().map(const ColorModelConverter())();
  TextColumn get briefDescription => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProductImagesModelConverter
    extends TypeConverter<List<ProductImagesModel>, String> {
  const ProductImagesModelConverter();
  @override
  List<ProductImagesModel>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    final _prod = json.decode(fromDb);
    return (_prod as List).map((e) => ProductImagesModel.fromJson(e)).toList();
  }

  @override
  String? mapToSql(List<ProductImagesModel>? value) {
    if (value == null) {
      return null;
    }
    return json.encode(value.toList());
  }
}

class UnitModelConverter extends TypeConverter<UnitModel, String> {
  const UnitModelConverter();
  @override
  UnitModel? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    return UnitModel.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String? mapToSql(UnitModel? value) {
    if (value == null) {
      return null;
    }
    return json.encode(value.toJson());
  }
}

class SlabsModelConverter extends TypeConverter<List<SlabsModel>, String> {
  const SlabsModelConverter();
  @override
  List<SlabsModel>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    final _prod = json.decode(fromDb);
    return (_prod as List).map((e) => SlabsModel.fromJson(e)).toList();
  }

  @override
  String? mapToSql(List<SlabsModel>? value) {
    if (value == null) {
      return null;
    }
    return json.encode(value.toList());
  }
}

class ColorModelConverter extends TypeConverter<List<ColorModel>, String> {
  const ColorModelConverter();
  @override
  List<ColorModel>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    final _prod = json.decode(fromDb);
    return (_prod as List).map((e) => ColorModel.fromJson(e)).toList();
  }

  @override
  String? mapToSql(List<ColorModel>? value) {
    if (value == null) {
      return null;
    }
    return json.encode(value.toList());
  }
}
