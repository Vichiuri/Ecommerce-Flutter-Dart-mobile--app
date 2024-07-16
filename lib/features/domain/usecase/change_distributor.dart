import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DistributorResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangeDistributor extends UseCase<DistributorResponse, ParamsId> {
  ChangeDistributor(this._repository);

  @override
  Future<Either<String, DistributorResponse>> call(ParamsId params) {
    return _repository.changedistributor(distId: params.id);
  }

  final Repository _repository;
}
