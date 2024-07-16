import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/usecase/new_arrivals.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

part 'new_arrivals_event.dart';
part 'new_arrivals_state.dart';

@injectable
class NewArrivalsBloc extends Bloc<NewArrivalsEvent, NewArrivalsState> {
  NewArrivalsBloc(this._arrivals) : super(NewArrivalsInitial());
  final NewArrivals _arrivals;
  @override
  Stream<NewArrivalsState> mapEventToState(
    NewArrivalsEvent event,
  ) async* {
    if (event is GetNewArrivalePaginatedEvent) {
      yield NewArrivalsLoading(message: "Fetching Products");
      final _res = await _arrivals.call(ParamsIdNullable(id: event.page));
      yield _res.fold(
        (l) => NewArrivalsError(position: event.position, error: l),
        (r) => NewArrivalsSuccess(
            response: r, position: event.position, products: event.product),
      );
    }
    if (event is UpdateNewArrivals) {
      // yield NewArrivalsLoading(message: "Fetching Products");
      yield NewArrivalsUpdating();
      final _res = await _arrivals.call(ParamsIdNullable(id: event.page));
      yield _res.fold(
        (l) => NewArrivalsError(position: event.position, error: l),
        (r) => NewArrivalsSuccess(
            response: r, position: event.position, products: event.product),
      );
    }
  }
}
