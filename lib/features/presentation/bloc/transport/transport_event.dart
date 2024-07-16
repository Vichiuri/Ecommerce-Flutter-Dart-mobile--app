part of 'transport_bloc.dart';

abstract class TransportEvent extends Equatable {
  const TransportEvent();

  @override
  List<Object> get props => [];
}

class FetchTransportEvent extends TransportEvent {
  final int retId;
  FetchTransportEvent({
    required this.retId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FetchTransportEvent && other.retId == retId;
  }

  @override
  int get hashCode => retId.hashCode;

  @override
  String toString() => 'FetchTransportEvent(retId: $retId)';
}
