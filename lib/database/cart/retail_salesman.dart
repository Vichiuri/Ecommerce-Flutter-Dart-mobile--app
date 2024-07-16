import 'package:moor/moor.dart';

@DataClassName("RetailSalesman")
class RetailSalesmanTable extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  @override
  Set<Column> get primaryKey => {id};
}
