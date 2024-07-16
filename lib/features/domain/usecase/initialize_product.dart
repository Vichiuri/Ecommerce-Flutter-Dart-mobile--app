import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class InitializeProduct extends UseCase<DashBoardResponse, ParamsIdNullable> {
  final Repository _repository;

  InitializeProduct(this._repository);

  @override
  Future<Either<String, DashBoardResponse>> call(ParamsIdNullable params) {
    return _repository.initializeProduct(params.id);
  }
}
