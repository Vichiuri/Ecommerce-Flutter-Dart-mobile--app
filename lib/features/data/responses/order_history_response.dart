import 'package:biz_mobile_app/core/errors/NetworkErrorHandler.dart';
import '../../domain/models/RetailOrder/retail_order_model.dart';

class OrderHistoryResponse {
  final List<RetailOrdersModel> retailOrders;
  final String? error;
  final int currentPage;
  final int lastPage;

  OrderHistoryResponse({
    required this.retailOrders,
    this.currentPage = 1,
    this.lastPage = 1,
    this.error,
  });

  OrderHistoryResponse.withError(String error)
      : retailOrders = [],
        currentPage = 1,
        lastPage = 1,
        error = networkErrorHandler(error);
}
