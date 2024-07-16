import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/transport_response.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FetchTransport extends UseCase<TransportResponse, ParamsId> {
  FetchTransport(this._repository);

  @override
  Future<Either<String, TransportResponse>> call(ParamsId params) {
    return _repository.fetchTransport(params.id);
  }

  final Repository _repository;
}
