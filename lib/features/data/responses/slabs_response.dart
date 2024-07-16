import 'package:biz_mobile_app/core/errors/NetworkErrorHandler.dart';
import 'package:biz_mobile_app/features/domain/models/Products/slabs_model.dart';

class SlabsResponse {
  final List<SlabsModel> slabs;
  final String? error;

  SlabsResponse({
    required this.slabs,
    this.error,
  });

  SlabsResponse.withError(String errorValue)
      : error = networkErrorHandler(errorValue),
        slabs = [];
}
