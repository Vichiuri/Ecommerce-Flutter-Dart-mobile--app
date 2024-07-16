import 'package:biz_mobile_app/features/data/responses/ApiSuccessResponse.dart';
import 'package:biz_mobile_app/features/data/responses/CartResponse.dart';
import 'package:biz_mobile_app/features/data/responses/DistributorResponse.dart';
import 'package:biz_mobile_app/features/data/responses/notification_response.dart';
import 'package:biz_mobile_app/features/data/responses/offer_response.dart';
import 'package:biz_mobile_app/features/data/responses/order_history_response.dart';
import 'package:biz_mobile_app/features/data/responses/profile_response.dart';
import 'package:biz_mobile_app/features/data/responses/single_product_response.dart';
import 'package:biz_mobile_app/features/data/responses/slabs_response.dart';
import 'package:biz_mobile_app/features/data/responses/transport_response.dart';
import 'package:biz_mobile_app/features/domain/models/Cart/CartQuantity.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:dartz/dartz.dart';

import '../../data/responses/AuthResponse.dart';
import '../../data/responses/DashBoardResponse.dart';
import '../models/retailers/RetailerModel.dart';

//abstract classes are interfaces check its implementation on repository_impl.dart
abstract class Repository {
  //connection Checker
  // Stream<Either<String, bool>> checkConnection();

  //firebase
  Stream<Either<String, NotificationResponse>?> streamOnMessage();
  Stream<Either<String, NotificationResponse>?> streamOnMessageOppenedApp();
  Future<Either<String, NotificationResponse?>> getInitialMessage();
  Future<Either<String, String>> sendLocation();

  Future<Either<String, AuthResponse>> login({
    required String email,
    required String password,
    // required String deviceId,
  });
  Future<bool> checkFirstTime();
  Future<Either<String, bool>> saveFirstTime();
  Future<Either<String, RetailerModel>> fetchLocalUser();
  Future<Either<String, DashBoardResponse>> fetchDashBoardResponse();
  Future<Either<String, DashBoardResponse>> fetchCategory({required int? page});
  Future<Either<String, CartResponse>> fetchCart();
  Future<Either<String, ApiSuccessResponse>> placeOrder({
    required String? notes,
    int? retId,
  });
  Future<Either<String, ApiSuccessResponse>> addToCart({
    required String qty,
    required String action,
    required int prodId,
    required ProductModel product,
  });
  Future<Either<String, ApiSuccessResponse>> addSingleToCart({
    required int prodId,
    required ProductModel prod,
  });
  Future<Either<String, DashBoardResponse>> fetchByCategory({
    required int catId,
    required int? page,
  });

  Future<Either<String, ApiSuccessResponse>> addOfferToCart({
    required int qty,
    required int offerId,
  });
  Future<Either<String, RetailerModel>> fetchRetailer();
  Future<Either<String, ApiSuccessResponse>> addOrRemoveToFavourite({
    required int productId,
  });
  Future<Either<String, DashBoardResponse>> fetchFavourites({
    required int? page,
  });
  Future<Either<String, ApiSuccessResponse>> deleteCart({
    required int orderId,
    required ProductModel prod,
    required int? ret,
  });
  Future<Either<String, CartQuantity>> getCartQuantity();
  Future<Either<String, void>> logout();
  Future<Either<String, DistributorResponse>> changedistributor({
    required int distId,
  });
  Future<Either<String, DistributorResponse>> fetchistributor(
      {required String? query});
  Future<Either<String, DistributorResponse>> fetchCurrentDistributor();
  // Future<Either<String, RetailerModel>> fetchCurrentRetailer();
  Future<Either<String, DashBoardResponse>> searchProducts({
    required String query,
    required int? maxPrice,
    required int? minPrice,
    required bool isNewArrival,
    required int? catId,
  });
  Future<Either<String, OrderHistoryResponse>> fetchOrderHistory(
      {required int? page});
  Future<Either<String, String>> deleteOrder({required int orderId});
  Future<Either<String, SingleProductResponse>> getSingleProduct(
      {required int prodId});
  Future<Either<String, NotificationResponse>> fetchNotifictains();
  Future<Either<String, OfferRespose>> fetchSingleOffer({required int offerId});
  Future<Either<String, ProfileResponse>> fetchProfile();
  Future<Either<String, String>> changePassword(
      {required String oldPass, required String newPass});
  Future<Either<String, String>> confirmDelivery({required int orderId});
  Future<Either<String, bool>> checkAuthUser();
  Future<Either<String, DashBoardResponse>> fetchPaginatedProduct({
    required int? page,
    required int? maxPrice,
    required int? minPrice,
    required bool isNewArrival,
    required int? catId,
  });
  Future<Either<String, String>> getPriceLevel(
      {required int prodId, required int qty});
  Future<Either<String, String>> forgotPassword({required String email});
  Future<Either<String, OrderHistoryResponse>> filterOrders({
    required int? distId,
    required String? status,
    required int? timeStampFrom,
    required int? timeStampTo,
  });
  Future<Either<String, DistributorResponse>> searchRetailer(
      {required String query});
  Future<Either<String, String>> reorder({required int orderId});
  Future<Either<String, DashBoardResponse>> getSingleCategory(
      {required int categoryId});

  Future<Either<String, DashBoardResponse>> getNewArrivals(int? page);
  Future<Either<String, DashBoardResponse>> getOffers(int? page);
  Future<Either<String, DashBoardResponse>> getBanners(int? page);
  Future<Either<String, DashBoardResponse>> getRelated({required int prodId});
  Future<Either<String, SlabsResponse>> getSlabs({required int prodId});
  Future<Either<String, String>> getDescription({required int prodId});
  Future<Either<String, DashBoardResponse>> initializeProduct(int? page);
  Future<Either<String, DashBoardResponse>> fetchTopProducts();
  Future<Either<String, DashBoardResponse>> fetchRecentlyBought();
  Future<Either<String, TransportResponse>> fetchTransport(int retId);
}
