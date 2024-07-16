import 'package:biz_mobile_app/core/errors/exeptions.dart';
import 'package:biz_mobile_app/database/app_database.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';

import 'banner_table.dart';

part 'banner_dao.g.dart';

@UseDao(tables: [BannerTable])
@lazySingleton
class BannerDao extends DatabaseAccessor<AppDatabase> with _$BannerDaoMixin {
  BannerDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  Future insertBanners(BannerDataClass prod) => into(bannerTable)
          .insert(prod, mode: InsertMode.insertOrReplace)
          .onError((error, stackTrace) {
        print("FAILED INSERT BANNER: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future<List<BannerDataClass>> getBanners() =>
      select(bannerTable).get().onError((error, stackTrace) {
        print("FAILED GET BANNER: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future deleteAll() => delete(bannerTable).go().onError((error, stackTrace) {
        print("FAILED DELETE Banner: $error, $stackTrace");
        throw DatabaseExeption();
      });
}
