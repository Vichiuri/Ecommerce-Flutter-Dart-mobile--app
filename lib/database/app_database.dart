import 'dart:io';

import 'package:biz_mobile_app/database/retailer/retailer_dao.dart';
import 'package:biz_mobile_app/database/retailer/retailer_table.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:biz_mobile_app/database/banners/banner_dao.dart';
import 'package:biz_mobile_app/database/banners/banner_table.dart';
import 'package:biz_mobile_app/database/offer/offer_dao.dart';
import 'package:biz_mobile_app/database/offer/offer_table.dart';
import 'package:biz_mobile_app/database/products/product_dao.dart';
import 'package:biz_mobile_app/database/products/product_table.dart';
import 'package:biz_mobile_app/features/domain/models/ProductImages/ProductImagesModel.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/models/Products/color_model.dart';
import 'package:biz_mobile_app/features/domain/models/Units/UnitModel.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';

import 'cart/cart_dao.dart';
import 'cart/cart_table.dart';
import 'cart/retail_salesman.dart';
import 'cart/retail_salesman_dao.dart';
import 'categories/category_dao.dart';
import 'categories/category_table.dart';

part 'app_database.g.dart';

//* LOCAL DB
@UseMoor(
  tables: [
    RetailSalesmanTable,
    ProductTable,
    OfferTable,
    BannerTable,
    CategoryTable,
    CartTable,
    RetailetTable,
  ],
  daos: [
    RetailSalesmanDao,
    ProductDao,
    OfferDao,
    BannerDao,
    CategoryDao,
    CartDao,
    RetailerDao
  ],
  include: {},
)
@lazySingleton
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()) {
    moorRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        // beforeOpen: (detailt) async =>
        //     await customStatement('PRAGMA foreign_keys = ON'),
        onCreate: (m) {
          return m.createAll();
        },
      );
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}
