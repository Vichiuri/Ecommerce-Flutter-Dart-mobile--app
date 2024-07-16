import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/Cart/CartQuantity.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCartQuantity extends UseCase<CartQuantity, NoParams> {
  GetCartQuantity(this._repository);

  @override
  Future<Either<String, CartQuantity>> call(NoParams params) {
    return _repository.getCartQuantity();
  }

  final Repository _repository;
}
