import 'package:biz_mobile_app/core/errors/exeptions.dart';
import 'package:biz_mobile_app/database/app_database.dart';
import 'package:biz_mobile_app/database/retailer/retailer_table.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';

part 'retailer_dao.g.dart';

@UseDao(tables: [RetailetTable])
@lazySingleton
class RetailerDao extends DatabaseAccessor<AppDatabase>
    with _$RetailerDaoMixin {
  RetailerDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  Future insertRetailer(RetailerDataClass ret) => into(retailetTable)
          .insert(ret, mode: InsertMode.insertOrReplace)
          .onError((error, stackTrace) {
        print("ERROR ADD RETAILER: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future<List<RetailerDataClass>> getRetailers(String? query) =>
      (select(retailetTable)..where((tbl) => tbl.name.like("%${query ?? ""}%")))
          .get()
          .onError((error, stackTrace) {
        print("ERROR GET RETAILER: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future<RetailerDataClass?> getSingleRetaile(int id) =>
      (select(retailetTable)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future deleteAll() => delete(retailetTable).go().onError((error, stackTrace) {
        print("ERROR DELETE RETAILER: $error, $stackTrace");
        throw DatabaseExeption();
      });
}
