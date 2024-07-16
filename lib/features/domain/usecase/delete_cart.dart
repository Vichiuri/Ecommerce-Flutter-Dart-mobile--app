import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/ApiSuccessResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'add_single_to_cart.dart';

@lazySingleton
class DeleteCart extends UseCase<ApiSuccessResponse, AddSingleToCartParams> {
  DeleteCart(this._repository);

  @override
  Future<Either<String, ApiSuccessResponse>> call(
      AddSingleToCartParams params) {
    return _repository.deleteCart(
      orderId: params.prodId,
      prod: params.product,
      ret: params.ret,
    );
  }

  final Repository _repository;
}
