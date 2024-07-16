part of 'description_bloc.dart';

abstract class DescriptionEvent extends Equatable {
  const DescriptionEvent();

  @override
  List<Object> get props => [];
}

class DescriptionStarted extends DescriptionEvent {
  final int prodId;
  DescriptionStarted({
    required this.prodId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DescriptionStarted && other.prodId == prodId;
  }

  @override
  int get hashCode => prodId.hashCode;
}
