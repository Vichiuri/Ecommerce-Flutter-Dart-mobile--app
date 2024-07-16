import 'dart:async';

import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/usecase/search_products.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'search_product_event.dart';
part 'search_product_state.dart';

@injectable
class SearchProductBloc extends Bloc<SearchProductEvent, SearchProductState> {
  SearchProductBloc(this._products) : super(SearchProductInitial());
  final SearchProducts _products;

  @override
  Stream<SearchProductState> mapEventToState(
    SearchProductEvent event,
  ) async* {
    if (event is SearchProductStarted) {
      yield SearchProductLoading();
      final result = await _products.call(SearchProductParams(
        query: event.query,
        isNewArrival: event.isNewArrival,
        maxPrice: event.maxPrice,
        minPrice: event.minPrice,
        catId: event.catId,
      ));
      yield result.fold(
        (l) => SearchProductError(l),
        (r) => SearchProductSuccess(r.products),
      );
    }
  }
}
