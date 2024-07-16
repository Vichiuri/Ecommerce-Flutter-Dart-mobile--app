// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ProductDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductTableTable get productTable => attachedDatabase.productTable;
  Selectable<int> countEntries() {
    return customSelect('SELECT COUNT(*) FROM product_table',
        variables: [],
        readsFrom: {
          productTable,
        }).map((QueryRow row) => row.read<int>('COUNT(*)'));
  }

  Selectable<int> countFav() {
    return customSelect(
        'SELECT COUNT(*) FROM product_table WHERE is_favourite IS TRUE',
        variables: [],
        readsFrom: {
          productTable,
        }).map((QueryRow row) => row.read<int>('COUNT(*)'));
  }

  Selectable<int> conuntNewArricals() {
    return customSelect(
        'SELECT COUNT(*) FROM product_table WHERE is_new_arrivals IS TRUE',
        variables: [],
        readsFrom: {
          productTable,
        }).map((QueryRow row) => row.read<int>('COUNT(*)'));
  }

  Selectable<ProductDataClass> searchProd() {
    return customSelect(
        'SELECT * FROM product_table WHERE name LIKE \'%prod%\' OR brand LIKE \'%prod%\'',
        variables: [],
        readsFrom: {
          productTable,
        }).map(productTable.mapFromRow);
  }
}
