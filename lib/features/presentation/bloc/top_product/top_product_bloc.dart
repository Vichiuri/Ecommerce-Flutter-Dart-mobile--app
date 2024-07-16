import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_top_products.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'top_product_event.dart';
part 'top_product_state.dart';

@injectable
class TopProductBloc extends Bloc<TopProductEvent, TopProductState> {
  TopProductBloc(this._get) : super(TopProductInitial());
  final GetTopProducts _get;

  @override
  Stream<TopProductState> mapEventToState(
    TopProductEvent event,
  ) async* {
    if (event is TopProductStarted) {
      yield TopProductLoading();
      final _res = await _get.call(NoParams());
      yield _res.fold(
        (l) => TopProductError(l),
        (r) => TopProductSuccess(r),
      );
    }
    if (event is TopProductUpdate) {
      // yield TopProductLoading();
      final _res = await _get.call(NoParams());
      yield _res.fold(
        (l) => TopProductError(l),
        (r) => TopProductSuccess(r),
      );
    }
  }
}
