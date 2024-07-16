part of 'get_offer_bloc.dart';

abstract class GetOfferEvent extends Equatable {
  const GetOfferEvent();

  @override
  List<Object> get props => [];
}

class GetOfferStarted extends GetOfferEvent {
  final int? page;
  GetOfferStarted({
    this.page,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetOfferStarted && other.page == page;
  }

  @override
  int get hashCode => page.hashCode;
}

class GetOfferUpdate extends GetOfferEvent {
  final int? page;
  GetOfferUpdate({
    this.page,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetOfferUpdate && other.page == page;
  }

  @override
  int get hashCode => page.hashCode;
}
