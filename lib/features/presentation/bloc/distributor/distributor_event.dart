part of 'distributor_bloc.dart';

abstract class DistributorEvent extends Equatable {
  const DistributorEvent();

  @override
  List<Object> get props => [];
}

class FetchDistributorEvent extends DistributorEvent {
  final String? query;
  FetchDistributorEvent({
    this.query,
  });

  FetchDistributorEvent copyWith({
    String? query,
  }) {
    return FetchDistributorEvent(
      query: query ?? this.query,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FetchDistributorEvent && other.query == query;
  }

  @override
  int get hashCode => query.hashCode;

  @override
  String toString() => 'FetchDistributorEvent(query: $query)';
}

class UpdateDistributorEvent extends DistributorEvent {}

class ChangeDistributorEvent extends DistributorEvent {
  final int distributorId;
  ChangeDistributorEvent({
    required this.distributorId,
  });
  @override
  List<Object> get props => [distributorId];
}
