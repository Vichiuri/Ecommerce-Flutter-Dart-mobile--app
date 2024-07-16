import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/order_history_response.dart';
import 'package:biz_mobile_app/features/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FilterOrders extends UseCase<OrderHistoryResponse, FilterOrderParams> {
  FilterOrders(this._repository);

  @override
  Future<Either<String, OrderHistoryResponse>> call(FilterOrderParams p) {
    return _repository.filterOrders(
      distId: p.id,
      status: p.status,
      timeStampFrom: p.timeStampFrom,
      timeStampTo: p.timeStampTo,
    );
  }

  final Repository _repository;
}

class FilterOrderParams {
  final int? id;
  final String? status;
  final int? timeStampFrom;
  final int? timeStampTo;
  FilterOrderParams({
    required this.id,
    required this.status,
    required this.timeStampFrom,
    required this.timeStampTo,
  });

  FilterOrderParams copyWith({
    int? id,
    String? status,
    int? timeStampFrom,
    int? timeStampTo,
  }) {
    return FilterOrderParams(
      id: id ?? this.id,
      status: status ?? this.status,
      timeStampFrom: timeStampFrom ?? this.timeStampFrom,
      timeStampTo: timeStampTo ?? this.timeStampTo,
    );
  }

  @override
  String toString() {
    return 'FilterOrderParams(distId: $id, status: $status, timeStampFrom: $timeStampFrom, timeStampTo: $timeStampTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FilterOrderParams &&
        other.id == id &&
        other.status == status &&
        other.timeStampFrom == timeStampFrom &&
        other.timeStampTo == timeStampTo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        status.hashCode ^
        timeStampFrom.hashCode ^
        timeStampTo.hashCode;
  }
}
