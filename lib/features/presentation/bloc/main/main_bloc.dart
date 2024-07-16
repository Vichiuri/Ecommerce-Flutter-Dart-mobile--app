import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/CartResponse.dart';
import 'package:biz_mobile_app/features/domain/usecase/FetchCart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'main_event.dart';
part 'main_state.dart';

@injectable
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc({required this.fetchCart}) : super(MainInitial());

  final FetchCart fetchCart;

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is FetchCartEvent) {
      yield MainLoadingState();

      final cartEither = await fetchCart(NoParams());
      yield cartEither.fold(
        (failure) => MainErrorState(message: failure),
        (response) => MainLoadedState(cartResponse: response),
      );
    }
    if (event is UpdateCartEvent) {
      yield UpdateLoadingState();

      final cartEither = await fetchCart(NoParams());
      yield cartEither.fold(
        (failure) => MainErrorState(message: failure),
        (response) => MainLoadedState(cartResponse: response),
      );
    }
  }
}
