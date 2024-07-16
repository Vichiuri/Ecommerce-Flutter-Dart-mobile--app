import 'package:biz_mobile_app/database/banners/banner_table.dart';
import 'package:moor/moor.dart';

@DataClassName("CartDataClass")
class CartTable extends Table {
  IntColumn get id => integer()();
  TextColumn get product => text().map(const ProductModelConverter())();
  IntColumn get cartQty => integer()();

  IntColumn get ret => integer().customConstraint(
      "NOT NULL REFERENCES retail_salesman_table (id) ON DELETE CASCADE")();

  @override
  Set<Column> get primaryKey => {id, ret};
}
