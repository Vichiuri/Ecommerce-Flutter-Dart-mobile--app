import 'dart:convert';

import 'package:moor/moor.dart';

@DataClassName("CategoryDataClass")
class CategoryTable extends Table {
  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer()();
  TextColumn get name => text().nullable()();
  TextColumn get category_pic => text().nullable()();
  IntColumn get parent_category => integer().nullable()();
  IntColumn get productcount => integer()();
  TextColumn get subCategory =>
      text().map(const SubCategoryConverter()).nullable()();
}

class SubCategoryConverter extends TypeConverter<List<int>, String> {
  const SubCategoryConverter();
  @override
  List<int>? mapToDart(String? fromDb) {
    if (fromDb == null) return null;
    final _int = json.decode(fromDb);
    return (_int as List<dynamic>).map((e) => e as int).toList();
  }

  @override
  String? mapToSql(List<int>? value) {
    if (value == null) return null;
    return json.encode(value.toList());
  }
}
