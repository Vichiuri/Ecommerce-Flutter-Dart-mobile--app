import 'package:biz_mobile_app/core/errors/exeptions.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';

import 'package:biz_mobile_app/database/app_database.dart';
import 'package:biz_mobile_app/database/categories/category_table.dart';

part 'category_dao.g.dart';

@UseDao(tables: [CategoryTable])
@lazySingleton
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  Future insertCats(CategoryDataClass prod) => into(categoryTable)
          .insert(prod, mode: InsertMode.insertOrReplace)
          .onError((error, stackTrace) {
        print("FAILED INSERT CATEGORY: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future<List<CategoryDataClass>> getCats({required int? page}) =>
      (select(categoryTable)
            ..limit(20,
                offset: page != null
                    ? page == 1
                        ? page
                        : (((page - 1) * 20) + 1)
                    : null))
          .get()
          .onError((error, stackTrace) {
        print("FAILED GET CATEGORY: $error, $stackTrace");
        throw DatabaseExeption();
      });

  List<CategoryDataClass> getSubCategory({required List<int> id}) {
    List<CategoryDataClass> _data = [];
    id.forEach((e) async {
      final _cat = await (select(categoryTable)
            ..where((tbl) => tbl.id.equals(e)))
          .getSingle()
          .onError((error, stackTrace) => throw DatabaseExeption());
      _data.add(_cat);
    });

    return _data;
  }

  Future<int> countCats() {
    return customSelect('SELECT COUNT(*) FROM category_table',
            variables: [], readsFrom: {categoryTable})
        .map((QueryRow row) => row.read<int>('COUNT(*)'))
        .getSingle()
        .then((value) {
      print("CAT COUNT: $value");
      return value;
    }).onError((error, stackTrace) => throw DatabaseExeption());
  }

  Future<CategoryDataClass?> getSingleCat(int id) =>
      (select(categoryTable)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull()
          .onError((error, stackTrace) {
        print("FAILED GET SINGLE CATEGORY: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future deleteAll() => delete(categoryTable).go().onError((error, stackTrace) {
        print("FAILED DELETE Banner: $error, $stackTrace");
        throw DatabaseExeption();
      });
}
