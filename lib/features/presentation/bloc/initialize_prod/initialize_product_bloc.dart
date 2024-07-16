import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/usecase/initialize_product.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'initialize_product_event.dart';
part 'initialize_product_state.dart';

@injectable
class InitializeProductBloc
    extends Bloc<InitializeProductEvent, InitializeProductState> {
  InitializeProductBloc(this._product) : super(InitializeProductInitial());
  final InitializeProduct _product;

  @override
  Stream<Transition<InitializeProductEvent, InitializeProductState>>
      transformEvents(
          Stream<InitializeProductEvent> events,
          TransitionFunction<InitializeProductEvent, InitializeProductState>
              transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<InitializeProductState> mapEventToState(
    InitializeProductEvent event,
  ) async* {
    if (event is InitializeProductStarted) {
      yield InitializeProductLoading();
      final _res = await _product.call(ParamsIdNullable(id: event.page));
      yield _res.fold(
          (l) => InitializeProductError(error: l),
          (r) => InitializeProductSuccess(
              currentPage: r.currentPage, lastPage: r.lastPage));
    }
  }
}
