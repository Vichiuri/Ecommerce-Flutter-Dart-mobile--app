import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetSingleCategory extends UseCase<DashBoardResponse, ParamsId> {
  GetSingleCategory(this._repository);

  @override
  Future<Either<String, DashBoardResponse>> call(ParamsId params) {
    return _repository.getSingleCategory(categoryId: params.id);
  }

  final Repository _repository;
}
