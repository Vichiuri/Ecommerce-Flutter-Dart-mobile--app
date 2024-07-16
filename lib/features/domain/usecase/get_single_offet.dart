import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/offer_response.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetSingleOffer extends UseCase<OfferRespose, ParamsId> {
  GetSingleOffer(this._repository);

  @override
  Future<Either<String, OfferRespose>> call(ParamsId params) {
    return _repository.fetchSingleOffer(offerId: params.id);
  }

  final Repository _repository;
}
