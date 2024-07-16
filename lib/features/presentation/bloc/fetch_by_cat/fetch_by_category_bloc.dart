import 'dart:async';

import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/usecase/fetch_by_category.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

part 'fetch_by_category_event.dart';
part 'fetch_by_category_state.dart';

@injectable
class FetchByCategoryBloc
    extends Bloc<FetchByCategoryEvent, FetchByCategoryState> {
  FetchByCategoryBloc(this._fetch) : super(FetchByCategoryInitial());
  final FetchByCategory _fetch;

  @override
  Stream<FetchByCategoryState> mapEventToState(
    FetchByCategoryEvent event,
  ) async* {
    if (event is FetchByCategoryStarted) {
      yield FetchByCategoryLoading();
      final result = await _fetch
          .call(FetchByCategoryParams(id: event.categoryId, page: 1));
      yield result.fold(
        (failure) => FetchByCategoryError(error: failure),
        (response) => FetchByCategorySuccess(
          product: [...event.product, ...response.products],
          lastPage: response.lastPage,
          currentPage: response.currentPage,
        ),
      );
    }
    if (event is UpdateCategoryStarted) {
      // yield FetchByCategoryLoading();
      final result = await _fetch
          .call(FetchByCategoryParams(id: event.categoryId, page: 1));
      yield result.fold(
        (failure) => FetchByCategoryError(error: failure),
        (response) => FetchByCategorySuccess(product: response.products),
      );
    }
    if (event is FetchByCategoryPaginated) {
      // yield FetchByCategoryLoading();
      final result = await _fetch
          .call(FetchByCategoryParams(id: event.categoryId, page: event.page));
      yield result.fold(
        (failure) => FetchByCategoryError(error: failure),
        (response) => FetchByCategorySuccess(
          product: [...event.product, ...response.products],
          lastPage: response.lastPage,
          currentPage: response.currentPage,
        ),
      );
    }
  }
}
