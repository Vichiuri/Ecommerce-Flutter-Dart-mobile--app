import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReOrder extends UseCase<String, ParamsId> {
  ReOrder(this._repository);

  @override
  Future<Either<String, String>> call(ParamsId params) {
    return _repository.reorder(orderId: params.id);
  }

  final Repository _repository;
}
