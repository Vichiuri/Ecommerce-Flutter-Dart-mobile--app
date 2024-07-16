import 'package:biz_mobile_app/core/errors/exeptions.dart';
import 'package:biz_mobile_app/database/app_database.dart';
import 'package:biz_mobile_app/database/products/product_table.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';

part 'product_dao.g.dart';

@UseDao(
  tables: [ProductTable],
  queries: {
    "countEntries": " SELECT COUNT(*) FROM product_table",
    "countFav": "SELECT COUNT(*) FROM product_table WHERE is_favourite IS TRUE",
    "conuntNewArricals":
        "SELECT COUNT(*) FROM product_table WHERE is_new_arrivals IS TRUE",
    "searchProd":
        "SELECT * FROM product_table WHERE name LIKE '%prod%' OR brand LIKE '%prod%'",
  },
)
@lazySingleton
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  Future insertProducts(ProductDataClass prod) => into(productTable)
          .insert(prod, mode: InsertMode.insertOrReplace)
          .onError((error, stackTrace) {
        print("FAILED INSERT PRODUCT: $error, $stackTrace");
        throw DatabaseExeption();
      });

  // Future<List<ProductDataClass>> searchProd({@required String? {query??""}}) =>
  //     (select(productTable)..where((tbl) => tbl.brand.like("regex"))).get();

  // Future<List<ProductDataClass>> filterByPrice()=>

  //TODO BADDDOOOH
  Future<List<ProductDataClass>> searchProducts({
    @required String? query,
    int? page,
    int? maxPrice,
    int? minPrice,
  }) {
    return customSelect(
        "SELECT * FROM product_table WHERE (name LIKE '%${query ?? ""}%' OR brand LIKE '%${query ?? ""}%') OR ((name LIKE '%${query ?? ""}%' OR brand LIKE '%${query ?? ""}%') AND price <= ${minPrice ?? 0}) LIMIT 20 OFFSET ${page != null ? page == 1 ? page : (((page - 1) * 20) + 1) : null}",
        variables: [],
        readsFrom: {
          productTable
        }).map(productTable.mapFromRow).get().onError((error, stackTrace) {
      print("FAILED SEARCH PROD: $error,$stackTrace");
      throw DatabaseExeption();
    });
  }

  Future<List<ProductDataClass>> getProducts({required int? page}) =>
      (select(productTable)
            ..limit(20,
                offset: page != null
                    ? page == 1
                        ? page
                        : (((page - 1) * 20) + 1)
                    : null))
          .get()
          .onError((error, stackTrace) {
        print("FAILED GET PRODUCT: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future<ProductDataClass?> getSingleProd(int id) =>
      (select(productTable)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull()
          .onError((error, stackTrace) {
        print("FAILED GET SINGLE PRODUCT: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future<List<ProductDataClass>> getFavourites({required int? page}) =>
      (select(productTable)
            ..where((tbl) => tbl.isFavourite)
            ..limit(20,
                offset: page != null
                    ? page == 1
                        ? page
                        : (((page - 1) * 20) + 1)
                    : null))
          .get()
          .onError((error, stackTrace) {
        print("FAILED GET FAV PRODUCTS: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future<List<ProductDataClass>> getNewArrivals({required int? page}) =>
      (select(productTable)
            ..where((tbl) => tbl.isNewArrivals.equals(true))
            ..limit(20,
                offset: page != null
                    ? page == 1
                        ? page
                        : (((page - 1) * 20) + 1)
                    : null))
          .get()
          .onError((error, stackTrace) {
        print("FAILED GET NEW PRODUCTS: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future<int> countArrivals({bool value = true}) {
    return customSelect(
            'SELECT COUNT(*) FROM product_table WHERE is_new_arrivals=$value',
            variables: [],
            readsFrom: {productTable})
        .map((QueryRow row) => row.read<int>('COUNT(*)'))
        .getSingle()
        .then((value) {
      print("ARR COUNT: $value");
      return value;
    }).onError((error, stackTrace) {
      print("ERROR COUNT NEW: $error,$stackTrace");
      throw DatabaseExeption();
    });
  }

  Future<List<ProductDataClass>> getByCategory(
          {required int catId, required int? page}) =>
      (select(productTable)
            ..where((tbl) => tbl.category.equals(catId))
            ..limit(20,
                offset: page != null
                    ? page == 1
                        ? page
                        : (((page - 1) * 20) + 1)
                    : null))
          .get()
          .onError((error, stackTrace) {
        print("FAILED GET PRODUCT BY CATEGORY: $error,$stackTrace");
        throw DatabaseExeption();
      });

  Future<int> countByCategory({required int catId}) {
    return customSelect(
            'SELECT COUNT(*) FROM product_table WHERE category=$catId',
            variables: [],
            readsFrom: {productTable})
        .map((QueryRow row) => row.read<int>('COUNT(*)'))
        .getSingle()
        .then((value) {
      print("BY CAT COUNT: $value");
      return value;
    }).onError((error, stackTrace) => throw DatabaseExeption());
  }

  Future updateSingleProduct(
          {required int id, required ProductDataClass prod}) =>
      (update(productTable)..where((tbl) => tbl.id.equals(id)))
          .write(prod)
          .onError((error, stackTrace) {
        print("FAILED UPDATE PRODUCT: $error,$stackTrace");
        throw DatabaseExeption();
      });

  Future updateProdQuantity({required int qty, required int id}) =>
      (update(productTable)..where((tbl) => tbl.id.equals(id)))
          .write(ProductTableCompanion(cartQty: Value(qty)))
          .onError((error, stackTrace) {
        print("FAILED ADD QTY: $error,$stackTrace");
        throw DatabaseExeption();
      });

  Future resetProdQuantity(int id) =>
      (update(productTable)..where((tbl) => tbl.id.equals(id)))
          .write(ProductTableCompanion(cartQty: Value(0)));

  Future deleteAll() => delete(productTable).go().onError((error, stackTrace) {
        print("FAILED DELETE PRODUCT: $error, $stackTrace");
        throw DatabaseExeption();
      });
}
