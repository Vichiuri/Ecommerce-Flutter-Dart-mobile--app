part of 'single_offer_bloc.dart';

abstract class SingleOfferEvent extends Equatable {
  const SingleOfferEvent();

  @override
  List<Object> get props => [];
}

class GetSingleOfferStarted extends SingleOfferEvent {
  final int offerId;
  GetSingleOfferStarted({
    required this.offerId,
  });
  @override
  List<Object> get props => [offerId];
}
