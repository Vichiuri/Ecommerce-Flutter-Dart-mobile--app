import 'dart:async';

// ignore: unused_import
import 'package:biz_mobile_app/core/usecase/usecase.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/usecase/get_paginated_products.dart';
import 'package:biz_mobile_app/features/domain/usecase/new_arrivals.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:injectable/injectable.dart';

part 'product_paginated_event.dart';
part 'product_paginated_state.dart';

@injectable
class ProductPaginatedBloc
    extends Bloc<ProductPaginatedEvent, ProductPaginatedState> {
  ProductPaginatedBloc(this._product, this._arrivals)
      : super(ProductPaginatedInitial());
  final GetPaginatedProduct _product;
  final NewArrivals _arrivals;

  @override
  Stream<ProductPaginatedState> mapEventToState(
    ProductPaginatedEvent event,
  ) async* {
    if (event is GetProductPaginatedEvent) {
      yield ProductPaginatedLoading(message: "Fetching Products");
      final _res = await _product.call(GetPaginatedProductParams(
          page: event.page,
          isNewArrival: event.isNewArrival,
          catId: event.catId,
          maxPrice: event.maxPrice,
          minPrice: event.minPrice));
      yield _res.fold(
        (l) => ProductPaginatedError(position: event.position, error: l),
        (r) => ProductPaginatedSuccess(
            response: r, position: event.position, products: event.product),
      );
    }
    if (event is GetProductPaginatedUpdate) {
      yield ProductPaginatedUpdating(message: "Fetching Products");
      final _res = await _product.call(
          GetPaginatedProductParams(page: event.page, isNewArrival: false));
      yield _res.fold(
        (l) => ProductPaginatedError(position: event.position, error: l),
        (r) => ProductPaginatedSuccess(
            response: r, position: event.position, products: event.product),
      );
    }

    // if (event is GetNewArrivalePaginatedEvent) {
    //   yield ProductPaginatedLoading(message: "Fetching Products");
    //   final _res = await _arrivals.call(ParamsIdNullable(id: event.page));
    //   yield _res.fold(
    //     (l) => ProductPaginatedError(position: event.position, error: l),
    //     (r) => ProductPaginatedSuccess(
    //         response: r, position: event.position, products: event.product),
    //   );
    // }
  }
}
