import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DistributorResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FetchDistributor
    extends UseCase<DistributorResponse, ParamsStringNullable> {
  FetchDistributor(this._repository);

  @override
  Future<Either<String, DistributorResponse>> call(
      ParamsStringNullable params) {
    return _repository.fetchistributor(query: params.string);
  }

  final Repository _repository;
}
