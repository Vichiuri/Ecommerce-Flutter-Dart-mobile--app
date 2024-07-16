import 'package:biz_mobile_app/core/errors/NetworkErrorHandler.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';

class OfferRespose {
  final OfferModel? model;
  final List<OfferModel>? otherOffers;
  final String? error;
  OfferRespose({required this.model, this.otherOffers, this.error});

  OfferRespose.withError(String error)
      : model = null,
        otherOffers = [],
        error = networkErrorHandler(error);
}
