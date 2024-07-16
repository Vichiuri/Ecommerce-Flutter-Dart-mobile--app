import 'package:biz_mobile_app/core/errors/NetworkErrorHandler.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';

class SingleProductResponse {
  ProductModel? product;
  final List<ProductModel> related;
  final String? error;

  SingleProductResponse({
    required this.product,
    required this.related,
    this.error,
  });

  SingleProductResponse.withError(String errorValue)
      : error = networkErrorHandler(errorValue),
        product = null,
        related = [];
}
