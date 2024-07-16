part of 'get_offer_bloc.dart';

abstract class GetOfferState extends Equatable {
  const GetOfferState();

  @override
  List<Object> get props => [];
}

class GetOfferInitial extends GetOfferState {}

class GetOfferLoading extends GetOfferState {}

class GetOfferUpdating extends GetOfferState {}

class GetOfferSuccess extends GetOfferState {
  final List<OfferModel> offers;
  GetOfferSuccess({
    required this.offers,
  });
  @override
  List<Object> get props => [offers];
}

class GetOfferError extends GetOfferState {
  final String error;
  GetOfferError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}
