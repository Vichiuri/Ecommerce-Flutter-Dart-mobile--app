import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetFavourites extends UseCase<DashBoardResponse, ParamsIdNullable> {
  GetFavourites(this._repository);

  @override
  Future<Either<String, DashBoardResponse>> call(ParamsIdNullable params) {
    return _repository.fetchFavourites(page: params.id);
  }

  final Repository _repository;
}
