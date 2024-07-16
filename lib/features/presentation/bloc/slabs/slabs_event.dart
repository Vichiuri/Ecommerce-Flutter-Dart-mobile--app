part of 'slabs_bloc.dart';

abstract class SlabsEvent extends Equatable {
  const SlabsEvent();

  @override
  List<Object> get props => [];
}

class GetSlabsStarted extends SlabsEvent {
  final int prodId;
  GetSlabsStarted({
    required this.prodId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetSlabsStarted && other.prodId == prodId;
  }

  @override
  int get hashCode => prodId.hashCode;
}
