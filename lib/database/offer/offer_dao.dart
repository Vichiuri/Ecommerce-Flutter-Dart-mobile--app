import 'package:biz_mobile_app/core/errors/exeptions.dart';
import 'package:injectable/injectable.dart';
import 'package:moor/moor.dart';

import 'package:biz_mobile_app/database/app_database.dart';

import 'offer_table.dart';

part 'offer_dao.g.dart';

@UseDao(tables: [OfferTable])
@lazySingleton
class OfferDao extends DatabaseAccessor<AppDatabase> with _$OfferDaoMixin {
  OfferDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  Future insert(OfferDataClass offer) => into(offerTable)
          .insert(offer, mode: InsertMode.insertOrReplace)
          .onError((error, stackTrace) {
        print("FAILED INSERT OFFER: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future<List<OfferDataClass>> getOffers() =>
      select(offerTable).get().onError((error, stackTrace) {
        print("FAILED GET OFFER: $error, $stackTrace");
        throw DatabaseExeption();
      });

  Future deleteAll() => delete(offerTable).go().onError((error, stackTrace) {
        print("FAILED DELETE OFFER: $error, $stackTrace");
        throw DatabaseExeption();
      });
}
