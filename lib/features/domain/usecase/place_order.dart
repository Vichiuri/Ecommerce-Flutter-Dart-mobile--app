import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/ApiSuccessResponse.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';

@lazySingleton
class PlaceOrder implements UseCase<ApiSuccessResponse, PlaceOrderParams> {
  PlaceOrder(this._repository);

  @override
  Future<Either<String, ApiSuccessResponse>> call(PlaceOrderParams params) {
    return _repository.placeOrder(notes: params.notes, retId: params.retId);
  }

  final Repository _repository;
}

class PlaceOrderParams {
  final int? retId;
  final String? notes;

  PlaceOrderParams({
    this.retId,
    this.notes,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaceOrderParams &&
        other.retId == retId &&
        other.notes == notes;
  }

  @override
  int get hashCode => retId.hashCode ^ notes.hashCode;

  @override
  String toString() => 'PlaceOrderParams(retId: $retId, notes: $notes)';
}
