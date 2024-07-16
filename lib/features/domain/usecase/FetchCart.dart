import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/CartResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FetchCart extends UseCase<CartResponse, NoParams> {
  final Repository repository;

  FetchCart({required this.repository});

  @override
  Future<Either<String, CartResponse>> call(NoParams params) {
    return repository.fetchCart();
  }
}
