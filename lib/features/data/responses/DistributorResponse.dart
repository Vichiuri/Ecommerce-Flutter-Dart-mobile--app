import 'package:biz_mobile_app/core/errors/NetworkErrorHandler.dart';
import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';
import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';

class DistributorResponse {
  final DistributorsModel? singleDist;
  final List<DistributorsModel>? distributors;
  final RetailerModel? singleRet;
  final List<RetailerModel>? retailers;
  final String? error;

  DistributorResponse({
    required this.singleDist,
    required this.distributors,
    this.singleRet,
    this.retailers,
    this.error,
  });

  DistributorResponse.withError(String error)
      : singleDist = null,
        distributors = [],
        singleRet = null,
        retailers = [],
        error = networkErrorHandler(error);
}
