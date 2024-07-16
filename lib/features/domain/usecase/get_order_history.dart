import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/order_history_response.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetOrderHistory extends UseCase<OrderHistoryResponse, ParamsIdNullable> {
  GetOrderHistory(this._repository);

  @override
  Future<Either<String, OrderHistoryResponse>> call(ParamsIdNullable params) {
    return _repository.fetchOrderHistory(page: params.id);
  }

  final Repository _repository;
}
