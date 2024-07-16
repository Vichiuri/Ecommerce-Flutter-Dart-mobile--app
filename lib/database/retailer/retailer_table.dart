import 'dart:convert';

import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';
import 'package:moor/moor.dart';

@DataClassName("RetailerDataClass")
class RetailetTable extends Table {
  IntColumn get id => integer()();
  TextColumn get pinNo => text()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get pic => text().nullable()();
  TextColumn get distributors =>
      text().map(const DistributorModelConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class DistributorModelConverter
    extends TypeConverter<List<DistributorsModel>, String> {
  const DistributorModelConverter();
  @override
  List<DistributorsModel>? mapToDart(String? fromDb) {
    if (fromDb != null) {
      final _dist = json.decode(fromDb);
      return (_dist as List<dynamic>)
          .map((e) => DistributorsModel.fromJson(e))
          .toList();
    }
  }

  @override
  String? mapToSql(List<DistributorsModel>? value) {
    if (value != null) return json.encode(value.toList());
  }
}
