part of 'related_bloc.dart';

abstract class RelatedEvent extends Equatable {
  const RelatedEvent();

  @override
  List<Object> get props => [];
}

class GetRelatedStarted extends RelatedEvent {
  final int prodId;
  GetRelatedStarted({
    required this.prodId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetRelatedStarted && other.prodId == prodId;
  }

  @override
  int get hashCode => prodId.hashCode;
}
