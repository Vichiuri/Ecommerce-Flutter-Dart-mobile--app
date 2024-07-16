import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/offer_response.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_single_offet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'single_offer_event.dart';
part 'single_offer_state.dart';

@injectable
class SingleOfferBloc extends Bloc<SingleOfferEvent, SingleOfferState> {
  SingleOfferBloc(this._offer) : super(SingleOfferInitial());
  final GetSingleOffer _offer;
  @override
  Stream<SingleOfferState> mapEventToState(
    SingleOfferEvent event,
  ) async* {
    if (event is GetSingleOfferStarted) {
      yield SingleOfferLoading();
      final _res = await _offer.call(ParamsId(id: event.offerId));
      yield _res.fold(
        (l) => SingleOfferError(message: l),
        (r) => SingleOfferSuccess(respose: r),
      );
    }
  }
}
