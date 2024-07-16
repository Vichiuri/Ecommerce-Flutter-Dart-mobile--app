part of 'order_history_bloc.dart';

abstract class OrderHistoryEvent extends Equatable {
  const OrderHistoryEvent();

  @override
  List<Object> get props => [];
}

class GetOrderHistoryStarted extends OrderHistoryEvent {
  final int? page;
  final List<RetailOrdersModel> retOrder;
  GetOrderHistoryStarted({
    this.page,
    required this.retOrder,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetOrderHistoryStarted &&
        other.page == page &&
        listEquals(other.retOrder, retOrder);
  }

  @override
  int get hashCode => page.hashCode ^ retOrder.hashCode;

  @override
  String toString() =>
      'GetOrderHistoryStarted(page: $page, retOrder: $retOrder)';
}

class GetOrderHistoryUpdated extends OrderHistoryEvent {
  final List<RetailOrdersModel> retOrder;
  GetOrderHistoryUpdated({
    required this.retOrder,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetOrderHistoryUpdated &&
        listEquals(other.retOrder, retOrder);
  }

  @override
  int get hashCode => retOrder.hashCode;

  @override
  String toString() => 'GetOrderHistoryUpdated(retOrder: $retOrder)';
}

class FilterOrderHistoryEvent extends OrderHistoryEvent {
  final int? id;
  final String? status;
  final int? timeStampFrom;
  final int? timeStampTo;

  FilterOrderHistoryEvent({
    this.id,
    this.status,
    this.timeStampFrom,
    this.timeStampTo,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FilterOrderHistoryEvent &&
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

  @override
  String toString() {
    return 'FilterOrderHistoryEvent(id: $id, status: $status, timeStampFrom: $timeStampFrom, timeStampTo: $timeStampTo)';
  }
}
