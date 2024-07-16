part of 'place_order_bloc.dart';

abstract class PlaceOrderEvent extends Equatable {
  const PlaceOrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrderStarted extends PlaceOrderEvent {
  final String? notes;
  final int? retId;
  PlaceOrderStarted({
    required this.notes,
    required this.retId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaceOrderStarted &&
        other.notes == notes &&
        other.retId == retId;
  }

  @override
  int get hashCode => notes.hashCode ^ retId.hashCode;

  @override
  String toString() => 'PlaceOrderStarted(notes: $notes, retId: $retId)';
}
