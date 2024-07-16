import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/slabs_response.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetSlabs extends UseCase<SlabsResponse, ParamsId> {
  GetSlabs(this._repository);

  @override
  Future<Either<String, SlabsResponse>> call(ParamsId params) {
    return _repository.getSlabs(prodId: params.id);
  }

  final Repository _repository;
}
