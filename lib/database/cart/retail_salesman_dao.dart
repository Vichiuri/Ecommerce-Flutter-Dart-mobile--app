import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';

import 'package:biz_mobile_app/database/app_database.dart';
import 'package:biz_mobile_app/database/cart/cart_table.dart';
import 'package:biz_mobile_app/database/cart/retail_salesman.dart';

part 'retail_salesman_dao.g.dart';

@UseDao(tables: [RetailSalesmanTable, CartTable])
@lazySingleton
class RetailSalesmanDao extends DatabaseAccessor<AppDatabase>
    with _$RetailSalesmanDaoMixin {
  RetailSalesmanDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  Future insertRetailSales(RetailSalesman entity) => into(retailSalesmanTable)
      .insert(entity, mode: InsertMode.insertOrReplace);

  Future<List<CartWithRetailer>> getOfflineCart() =>
      (select(retailSalesmanTable))
          .join([
            leftOuterJoin(
              cartTable,
              cartTable.ret.equalsExp(retailSalesmanTable.id),
            )
          ])
          .get()
          .then((rows) {
            final _groupedData = <RetailSalesman, List<CartDataClass>>{};
            for (final row in rows) {
              final _ret = row.readTable(retailSalesmanTable);
              final _cart = row.readTableOrNull(cartTable);

              final _list = _groupedData.putIfAbsent(_ret, () => []);
              if (_cart != null) _list.add(_cart);
            }

            return [
              for (final entry in _groupedData.entries)
                CartWithRetailer(retailSalesman: entry.key, cart: entry.value)
            ];
          });

  Future deleteCartItem({required retId, required prodId}) => (delete(cartTable)
        ..where((tbl) => tbl.id.equals(prodId))
        ..where((tbl) => tbl.ret.equals(retId)))
      .go();

  Future deleteAll() => delete(retailSalesmanTable).go();
  Future delereAllCart() => (delete(cartTable)).go();

  Future delereWhere(int id) =>
      (delete(retailSalesmanTable)..where((tbl) => tbl.id.equals(id))).go();
  Future deleteCartWhere(int id) =>
      (delete(cartTable)..where((tbl) => tbl.ret.equals(id))).go();

  Future<int> countCart(int id) {
    return customSelect('SELECT COUNT(*) FROM cart_table WHERE ret=$id',
        variables: [],
        readsFrom: {
          cartTable,
        }).map((QueryRow row) => row.read<int>('COUNT(*)')).getSingle();
  }

  Future<int> countAllCart() {
    return customSelect('SELECT COUNT(*) FROM cart_table',
        variables: [],
        readsFrom: {
          cartTable,
        }).map((QueryRow row) => row.read<int>('COUNT(*)')).getSingle();
  }
}

class CartWithRetailer {
  final RetailSalesman retailSalesman;
  final List<CartDataClass> cart;

  CartWithRetailer({
    required this.retailSalesman,
    required this.cart,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartWithRetailer &&
        other.retailSalesman == retailSalesman &&
        listEquals(other.cart, cart);
  }

  @override
  int get hashCode => retailSalesman.hashCode ^ cart.hashCode;

  @override
  String toString() =>
      'CartWithRetailer(retailSalesman: $retailSalesman, cart: $cart)';
}
