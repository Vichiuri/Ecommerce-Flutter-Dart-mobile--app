import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DistributorResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SearchRetailer extends UseCase<DistributorResponse, ParamsString> {
  SearchRetailer(this._repository);

  @override
  Future<Either<String, DistributorResponse>> call(ParamsString params) {
    return _repository.searchRetailer(query: params.string);
  }

  final Repository _repository;
}
