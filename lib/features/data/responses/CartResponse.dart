import 'package:biz_mobile_app/features/domain/models/Cart/salesman_cart_model.dart';

import '../../../core/errors/NetworkErrorHandler.dart';
import '../../domain/models/Cart/CartModel.dart';

class CartResponse {
  final CartModel? cart;
  final String? message, error;
  final List<SalesManCartModel> salesmanCart;

  CartResponse(
      {this.cart, this.message, this.error, required this.salesmanCart});

  CartResponse.withError(String errorValue)
      : cart = null,
        message = null,
        salesmanCart = const [],
        error = networkErrorHandler(errorValue);
}
