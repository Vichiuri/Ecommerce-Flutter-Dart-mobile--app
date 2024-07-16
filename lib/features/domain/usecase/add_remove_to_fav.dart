import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/ApiSuccessResponse.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddRemoveToFav implements UseCase<ApiSuccessResponse, ParamsId> {
  AddRemoveToFav(this._repository);

  @override
  Future<Either<String, ApiSuccessResponse>> call(ParamsId params) {
    return _repository.addOrRemoveToFavourite(productId: params.id);
  }

  final Repository _repository;
}
