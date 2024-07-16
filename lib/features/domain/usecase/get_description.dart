import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetDescription extends UseCase<String, ParamsId> {
  GetDescription(this._repository);

  @override
  Future<Either<String, String>> call(ParamsId params) {
    return _repository.getDescription(prodId: params.id);
  }

  final Repository _repository;
}
