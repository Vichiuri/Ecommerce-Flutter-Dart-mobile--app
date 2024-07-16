import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_offers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'get_offer_event.dart';
part 'get_offer_state.dart';

@injectable
class GetOfferBloc extends Bloc<GetOfferEvent, GetOfferState> {
  GetOfferBloc(this._offers) : super(GetOfferInitial());
  final GetOffers _offers;

  @override
  Stream<GetOfferState> mapEventToState(
    GetOfferEvent event,
  ) async* {
    if (event is GetOfferStarted) {
      yield GetOfferLoading();
      final _res = await _offers.call(ParamsIdNullable(id: event.page));
      yield _res.fold(
        (l) => GetOfferError(error: l),
        (r) => GetOfferSuccess(offers: r.offers),
      );
    }
    if (event is GetOfferUpdate) {
      yield GetOfferUpdating();
      final _res = await _offers.call(ParamsIdNullable(id: event.page ?? 0));
      yield _res.fold(
        (l) => GetOfferError(error: l),
        (r) => GetOfferSuccess(offers: r.offers),
      );
    }
  }
}
