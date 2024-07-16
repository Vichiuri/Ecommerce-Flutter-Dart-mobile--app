import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/single_product_response.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetSingleProduct extends UseCase<SingleProductResponse, ParamsId> {
  GetSingleProduct(this._repository);

  @override
  Future<Either<String, SingleProductResponse>> call(ParamsId params) {
    return _repository.getSingleProduct(prodId: params.id);
  }

  final Repository _repository;
}
