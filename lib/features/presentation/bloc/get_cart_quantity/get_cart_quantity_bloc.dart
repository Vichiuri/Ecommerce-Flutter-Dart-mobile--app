import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/Cart/CartQuantity.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_cart_quantity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'get_cart_quantity_event.dart';
part 'get_cart_quantity_state.dart';

@injectable
class GetCartQuantityBloc
    extends Bloc<GetCartQuantityEvent, GetCartQuantityState> {
  GetCartQuantityBloc(this.getCartQuantity) : super(GetCartQuantityInitial());
  final GetCartQuantity getCartQuantity;

  @override
  Stream<GetCartQuantityState> mapEventToState(
    GetCartQuantityEvent event,
  ) async* {
    if (event is GetCartQuantityStarted) {
      yield GetCartQuantityLoading();
      final result = await getCartQuantity.call(NoParams());
      yield result.fold(
        (l) => GetCartQuantityError(l),
        (r) => GetCartQuantitySuccess(cartQuantity: r),
      );
    }
  }
}
