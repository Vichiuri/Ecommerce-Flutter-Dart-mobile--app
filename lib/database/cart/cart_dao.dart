import 'package:biz_mobile_app/database/app_database.dart';
import 'package:biz_mobile_app/database/cart/cart_table.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';

import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';

part 'cart_dao.g.dart';

@UseDao(tables: [CartTable])
@lazySingleton
class CartDao extends DatabaseAccessor<AppDatabase> with _$CartDaoMixin {
  CartDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  Future addToCart(
          {required retId, required ProductModel prod, required int cartQty}) =>
      into(cartTable).insert(
        CartTableCompanion.insert(
            product: prod, cartQty: cartQty, ret: retId, id: prod.id),
        mode: InsertMode.insertOrReplace,
      );

  Future<int?> fetchCartQty({required retId, required ProductModel prod}) =>
      (select(cartTable)
            ..where((tbl) => tbl.id.equals(prod.id))
            ..where((tbl) => tbl.ret.equals(retId)))
          .getSingleOrNull()
          .then((value) => value?.cartQty);
}
