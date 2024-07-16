import 'dart:async';

import 'package:biz_mobile_app/features/domain/usecase/get_price_level.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'price_level_event.dart';
part 'price_level_state.dart';

@injectable
class PriceLevelBloc extends Bloc<PriceLevelEvent, PriceLevelState> {
  PriceLevelBloc(this._level) : super(PriceLevelInitial());
  final GetPriceLevel _level;

  @override
  Stream<PriceLevelState> mapEventToState(
    PriceLevelEvent event,
  ) async* {
    if (event is GetPriceLevelEvent) {
      yield PriceLevelLoading();
      final _res = await _level
          .call(GetPriceLevelParams(prodId: event.prodId, qty: event.qty));
      yield _res.fold(
        (l) => PriceLevelSuccess(price: event.price),
        (r) => PriceLevelSuccess(price: r),
      );
    }
  }
}
