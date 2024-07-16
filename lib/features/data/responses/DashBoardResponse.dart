import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';

import '../../../core/errors/NetworkErrorHandler.dart';
import '../../domain/models/Category/CategoryModel.dart';
import '../../domain/models/Products/ProductsModel.dart';
import '../../domain/models/banners/BannerModel.dart';

class DashBoardResponse {
  final List<BannerModel> banners;
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final List<OfferModel> offers;
  final CategoryModel? category;
  final String? error;
  final int? lastPage;
  final int? currentPage;

  DashBoardResponse({
    required this.banners,
    required this.products,
    required this.categories,
    required this.offers,
    this.category,
    this.lastPage,
    this.currentPage,
    this.error,
  });

  DashBoardResponse.withError(String errorValue)
      : banners = [],
        currentPage = null,
        lastPage = null,
        category = null,
        products = [],
        categories = [],
        offers = [],
        error = networkErrorHandler(errorValue);
}
