part of 'single_offer_bloc.dart';

abstract class SingleOfferState extends Equatable {
  const SingleOfferState();

  @override
  List<Object> get props => [];
}

class SingleOfferInitial extends SingleOfferState {}

class SingleOfferLoading extends SingleOfferState {}

class SingleOfferSuccess extends SingleOfferState {
  final OfferRespose respose;
  SingleOfferSuccess({
    required this.respose,
  });
  @override
  List<Object> get props => [respose];
}

class SingleOfferError extends SingleOfferState {
  final String message;
  SingleOfferError({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
