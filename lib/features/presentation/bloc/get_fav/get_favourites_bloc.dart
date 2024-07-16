import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_favourites.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

part 'get_favourites_event.dart';
part 'get_favourites_state.dart';

@injectable
class GetFavouritesBloc extends Bloc<GetFavouritesEvent, GetFavouritesState> {
  GetFavouritesBloc(this._get) : super(GetFavouritesInitial());
  final GetFavourites _get;

  @override
  Stream<GetFavouritesState> mapEventToState(
    GetFavouritesEvent event,
  ) async* {
    if (event is GetFavouritesStarted) {
      yield GetFavouritesLoading();
      final _res = await _get.call(ParamsIdNullable(id: event.page));
      yield _res.fold(
        (l) => GetFavouritesError(message: l),
        (response) => GetFavouritesSuccess(
          products: response.products + event.products,
          currentPage: response.currentPage,
          lastPage: response.lastPage,
        ),
      );
    }
    if (event is GetFavouritePaginated) {
      yield GetFavouritesPaginating();
      final _res = await _get.call(ParamsIdNullable(id: event.page));
      yield _res.fold(
        (l) => GetFavouritesPaginatedError(message: l),
        (response) => GetFavouritesSuccess(
          products: [...event.products, ...response.products],
          currentPage: response.currentPage,
          lastPage: response.lastPage,
        ),
      );
    }
    if (event is GetFavouritesUpdated) {
      yield GetFavouritesUpdating();
      final _res = await _get.call(ParamsIdNullable(id: 1));
      yield* _res.fold(
        (l) async* {
          yield GetFavouritesError(message: l);
        },
        (response) async* {
          yield GetFavouritesSuccess(
            products: response.products,
            currentPage: response.currentPage,
            lastPage: response.lastPage,
          );
        },
      );
    }
  }
}
