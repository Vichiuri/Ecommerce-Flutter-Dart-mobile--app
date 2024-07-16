import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/single_product_response.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_single_product.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'single_product_event.dart';
part 'single_product_state.dart';

@injectable
class SingleProductBloc extends Bloc<SingleProductEvent, SingleProductState> {
  SingleProductBloc(this._product) : super(SingleProductInitial());
  final GetSingleProduct _product;

  @override
  Stream<SingleProductState> mapEventToState(
    SingleProductEvent event,
  ) async* {
    if (event is GetSingleProductStarted) {
      yield SingleProductLoading();
      final _res = await _product.call(ParamsId(id: event.productId));
      yield _res.fold(
        (l) => SingleProductError(message: l),
        (r) => SingleProductSuccess(response: r),
      );
    }
    if (event is UpdateSingleProductStarted) {
      // yield SingleProductLoading();
      final _res = await _product.call(ParamsId(id: event.productId));
      yield _res.fold(
        (l) => SingleProductError(message: l),
        (r) => SingleProductSuccess(response: r),
      );
    }
  }
}
