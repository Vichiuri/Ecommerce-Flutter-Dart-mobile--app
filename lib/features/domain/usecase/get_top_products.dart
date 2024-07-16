import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetTopProducts extends UseCase<DashBoardResponse, NoParams> {
  GetTopProducts(this._repository);

  @override
  Future<Either<String, DashBoardResponse>> call(NoParams params) {
    return _repository.fetchTopProducts();
  }

  final Repository _repository;
}
