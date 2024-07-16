import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DistributorResponse.dart';
import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCurrentDistributor extends UseCase<DistributorResponse, NoParams> {
  final Repository _repository;

  GetCurrentDistributor(this._repository);

  @override
  Future<Either<String, DistributorResponse>> call(NoParams params) {
    return _repository.fetchCurrentDistributor();
  }
}
