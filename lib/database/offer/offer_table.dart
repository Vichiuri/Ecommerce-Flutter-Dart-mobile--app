import 'package:biz_mobile_app/database/banners/banner_table.dart';
import 'package:moor/moor.dart';

@DataClassName("OfferDataClass")
class OfferTable extends Table {
  IntColumn get id => integer()();
  TextColumn get xItem => text().map(const ProductModelConverter())();
  TextColumn get yItem =>
      text().map(const ProductModelConverter()).nullable()();
  TextColumn get name => text()();
  TextColumn get scheme => text()();
  IntColumn get xAmt => integer()();
  IntColumn get yAmt => integer()();
  TextColumn get dateFrom => text()();
  TextColumn get dateTo => text()();
  TextColumn get pic => text()();
  TextColumn get detailName => text()();

  @override
  Set<Column> get primaryKey => {id};
}
