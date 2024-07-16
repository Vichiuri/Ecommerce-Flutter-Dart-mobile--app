import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FetchRetailer implements UseCase<RetailerModel, NoParams> {
  FetchRetailer(this._repository);

  @override
  Future<Either<String, RetailerModel>> call(NoParams params) {
    return _repository.fetchRetailer();
  }

  final Repository _repository;
}
