import 'package:biz_mobile_app/features/domain/models/SalesMan/SalesManModel.dart';

import '../../../core/errors/NetworkErrorHandler.dart';
import '../../domain/models/retailers/RetailerModel.dart';
import '../../domain/models/token_model.dart';

class AuthResponse {
  final RetailerModel? retailer;
  final TokenModel? tokenModel;
  final SalesManModel? salesManModel;
  final String? error;
  final bool salesmann;

  AuthResponse(
      {required this.retailer,
      required this.salesManModel,
      this.tokenModel,
      this.salesmann = false,
      this.error});

  AuthResponse.withError(String errorValue)
      : retailer = null,
        salesManModel = null,
        tokenModel = null,
        salesmann = false,
        error = networkErrorHandler(errorValue);
}
