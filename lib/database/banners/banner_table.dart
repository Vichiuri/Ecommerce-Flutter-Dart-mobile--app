import 'dart:convert';

import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:moor/moor.dart';

@DataClassName("BannerDataClass")
class BannerTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get bannerText => text()();
  TextColumn get pic => text().nullable()();
  TextColumn get status => text()();

  TextColumn get product =>
      text().map(const ProductModelConverter()).nullable()();
  TextColumn get offer => text().map(const OfferModelConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProductModelConverter extends TypeConverter<ProductModel, String> {
  const ProductModelConverter();
  @override
  ProductModel? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    return ProductModel.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String? mapToSql(ProductModel? value) {
    if (value == null) {
      return null;
    }
    return json.encode(value.toJson());
  }
}

class OfferModelConverter extends TypeConverter<OfferModel, String> {
  const OfferModelConverter();
  @override
  OfferModel? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    return OfferModel.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String? mapToSql(OfferModel? value) {
    if (value == null) {
      return null;
    }
    return json.encode(value.toJson());
  }
}
