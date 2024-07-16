import 'dart:convert';

import 'package:biz_mobile_app/core/errors/NetworkErrorHandler.dart';
import 'package:biz_mobile_app/features/data/responses/slabs_response.dart';
import 'package:biz_mobile_app/features/data/responses/transport_response.dart';
import 'package:biz_mobile_app/features/domain/models/Cart/salesman_cart_model.dart';
import 'package:biz_mobile_app/features/domain/models/Cart/sync_model.dart';
import 'package:biz_mobile_app/features/domain/models/Products/slabs_model.dart';
import 'package:biz_mobile_app/features/domain/models/RetailOrder/transport_model.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

import 'package:biz_mobile_app/features/data/responses/ApiSuccessResponse.dart';
import 'package:biz_mobile_app/features/data/responses/CartResponse.dart';
import 'package:biz_mobile_app/features/data/responses/DistributorResponse.dart';
import 'package:biz_mobile_app/features/data/responses/notification_response.dart';
import 'package:biz_mobile_app/features/data/responses/offer_response.dart';
import 'package:biz_mobile_app/features/data/responses/order_history_response.dart';
import 'package:biz_mobile_app/features/data/responses/profile_response.dart';
import 'package:biz_mobile_app/features/data/responses/single_product_response.dart';
import 'package:biz_mobile_app/features/domain/models/Cart/CartModel.dart';
import 'package:biz_mobile_app/features/domain/models/Cart/CartQuantity.dart';
import 'package:biz_mobile_app/features/domain/models/SalesMan/SalesManModel.dart';
import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';
import 'package:biz_mobile_app/features/domain/models/notification/list_notification_model.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:biz_mobile_app/features/domain/models/profile/profile.dart';

import '../../../../core/errors/exeptions.dart';
import '../../../../core/network/HandleNetworkCall.dart';
import '../../../domain/models/Category/CategoryModel.dart';
import '../../../domain/models/Products/ProductsModel.dart';
import '../../../domain/models/RetailOrder/retail_order_model.dart';
import '../../../domain/models/banners/BannerModel.dart';
import '../../../domain/models/retailers/RetailerModel.dart';
import '../../../domain/models/token_model.dart';
import '../../responses/AuthResponse.dart';
import '../../responses/DashBoardResponse.dart';
import '../api/api.dart';

abstract class RemoteDataSource {
  Future<String> sendLocation({
    required String lat,
    required String lon,
    required int id,
  });

  Future<AuthResponse> login({
    required String email,
    required String password,
    required String deviceId,
  });
  Future<TokenModel> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  });
  Future<AuthResponse> checkUser(String deviceId);
  Future<DashBoardResponse> fetchDashBoardData(int id);
  Future<DashBoardResponse> fetchCategories({
    required int? page,
    required int? distributorId,
  });
  Future<CartResponse> fetchCartData();
  Future<ApiSuccessResponse> placeOrder({required String? notes});
  Future<ApiSuccessResponse> addToCart({
    required String qty,
    required String action,
    required int prodId,
  });
  Future<ApiSuccessResponse> addSingleToCart(
      {required int prodId, required int? retId});
  Future<ApiSuccessResponse> addOfferToCart({
    required int qty,
    required int offerId,
    required int? retId,
  });
  Future<DashBoardResponse> fetchByCategory(
      {required int catId, required int? retId, required int? page});
  Future<ApiSuccessResponse> addOrRemoveToFavourites({required int productId});
  Future<DashBoardResponse> fetchFavourites({int? page, int? retId});
  Future<ApiSuccessResponse> deleteCart(
      {required int orderId, required bool all});
  Future<CartQuantity> cartQuantity({required int? retid});
  Future<void> logout();
  Future<DistributorResponse> changeDistributor({required int distId});
  Future<DistributorResponse> fetchDistributor({required String? query});
  Future<DashBoardResponse> searchProduct({
    required int? distId,
    required int? retId,
    required String query,
    required int? maxPrice,
    required int? minPrice,
    required bool isNewArrival,
    required int? catId,
  });
  Future<DashBoardResponse> fetchTopProducts({required int? distributorId});
  Future<DashBoardResponse> fetchRecentBought(
      {required int? distributorId, required int? retId});
  Future<OrderHistoryResponse> fetchOrderHistory({int? page, int? retId});
  Future<ApiSuccessResponse> deleteOrder({required int orderId});
  Future<SingleProductResponse> fetchSingleProduct(
      {required int prodId, required int distributorId});
  Future<NotificationResponse> getNotifications();
  Future<OfferRespose> fetchSingleOffer({required int offerId});

  //!SALESMANN
  // Future<DashBoardResponse> fetchSalesmanDashBoardData(int id);
  // Future<CartQuantity> salesmanCartQuantity(int id);
  Future<DistributorResponse> changeRetailer({required int retId});
  Future<DistributorResponse> fetchRetailer({required String? query});

  Future<ProfileResponse> fetchProfile();
  Future<ProfileResponse> changePassword({
    required String oldPass,
    required String newPass,
  });

  Future<ApiSuccessResponse> confirmDelivery({required int orderId});
  // Future<ApiSuccessResponse> addSalesmanOfferToCart({
  //   required int qty,
  //   required int offerId,
  //   required int retid,
  // });

  Future<CartResponse> fetchCartDataSalesman({required int retId});
  // Future<ApiSuccessResponse> addSingleToCartSalesman(
  //     {required int prodId, required int retId});
  Future<SingleProductResponse> fetchSingleProductSalesman(
      {required int prodId, required int retId});
  Future<ApiSuccessResponse> addToCartSalesman({
    required String qty,
    required String action,
    required int prodId,
    required int retId,
  });
  // Future<DashBoardResponse> searchProductSalesman({
  //   required int retId,
  //   required String query,
  // });
  Future<ApiSuccessResponse> placeOrderSalesman({
    required int? retId,
    required String? notes,
  });
  Future<ApiSuccessResponse> deleteCartSalesman({
    required int orderId,
    required bool all,
    required int retId,
  });
  Future<OrderHistoryResponse> fetchOrderHistorySalesman({required int retId});
  // Future<DashBoardResponse> fetchFavouritesSalesman({required int retId});
  Future<DashBoardResponse> fetchPaginatedProduct(
      {required int distributorId,
      required int? maxPrice,
      required int? minPrice,
      required bool isNewArrival,
      required int? catId,
      required int? page,
      int? retId});
  Future<String> getPriceLevel({required int prodId, required int qty});
  Future<String> getSalemsanPriceLevel({
    required int prodId,
    required int qty,
    required int retId,
  });
  Future<ApiSuccessResponse> forgotPassword({required String email});
  Future<OrderHistoryResponse> filterOrdes({
    required int? distId,
    required String? status,
    required int? timeStampFrom,
    required int? retId,
    required int? timeStampTo,
  });
  Future<DistributorResponse> searchRetailer({required String query});
  Future<ApiSuccessResponse> reorder({required int orderId});
  Future<DashBoardResponse> getSingleCategory({required int categoryId});
  Future<DashBoardResponse> getNewArrivals({int? retId, int? page});
  Future<DashBoardResponse> getOffers({int? distId});
  Future<DashBoardResponse> getBanners({int? distId});
  Future<String> getProductDescription({required int prodId});
  Future<DashBoardResponse> getRelated({required int prodId, int? retId});
  Future<SlabsResponse> getSlabs({required int prodId, int? retId});
  Future<DashBoardResponse> initializeProduct(int? page);
  Future<CartResponse> syncCart(List<SyncModel> sync);
  Future<TransportResponse> fetchTransport(int retId);
  // Future<String> sendLocation({required String lat, required String lon});
}

//fetching data from remote api....like backend
@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final HandleNetworkCall _call;
  final Api _service;
  // final LocalDataSource _localDataSource;

  RemoteDataSourceImpl(this._call, this._service);

  @override
  Future<String> sendLocation({
    required String lat,
    required String lon,
    required int id,
  }) async {
    try {
      final _res = await _service.sendLocation(lat: lat, lon: lon, id: id);
      final status = _call.checkStatusCode(_res.statusCode);
      if (status) {
        print("success");
        return "success";
      }
      return "failed";
    } catch (e) {
      print(e);
      return "";
    }
  }

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    try {
      final response = await _service.login(
        email: email,
        password: password,
        deviceId: deviceId,
      );
      final status = _call.checkStatusCode(response.statusCode);

      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        TokenModel token = TokenModel(token: body["token"]);
        if (body.containsKey("retailer")) {
          print("RETAILER");
          RetailerModel retailer = RetailerModel.fromJson(body['retailer']);
          return AuthResponse(
            retailer: retailer,
            tokenModel: token,
            salesManModel: null,
          );
        } else if (body.containsKey("salesman")) {
          print("SALESMANN");
          SalesManModel salesman = SalesManModel.fromJson(body['salesman']);
          return AuthResponse(
            retailer: null,
            tokenModel: token,
            salesManModel: salesman,
            salesmann: true,
          );
        } else {
          return AuthResponse.withError(response.body.toString());
        }
      } else {
        return AuthResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<TokenModel> register(
      {required String name,
      required String email,
      required String password,
      required String confirmPassword}) async {
    try {
      final response = await _service.register(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return TokenModel.fromJson(body);
      } else {
        throw ServerException();
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> fetchDashBoardData(int id) async {
    try {
      // final retailer = await _localDataSource.fetchRetailer();
      // final dist = await _localDataSource.fetchDistributor();
      final response = await _service.fetchDashBoardApi(id: id);

      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<ProductModel> products = (body['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        List<BannerModel> banners = (body['banners'] as List)
            .map((e) => BannerModel.fromJson(e))
            .toList();
        // List<CategoryModel> categories = (body['categories'] as List)
        //     .map((e) => CategoryModel.fromJson(e))
        //     .toList();
        List<OfferModel> offers = (body['offers'] as List)
            .map((e) => OfferModel.fromJson(e))
            .toList();

        return DashBoardResponse(
          banners: banners,
          products: products,
          categories: [],
          offers: offers,
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> fetchCategories(
      {required int? page, required int? distributorId}) async {
    try {
      final response = await _service.fetchCategories(
        distributerId: distributorId,
        page: page,
      );

      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        // List<ProductModel> products = (body['products'] as List)
        //     .map((e) => ProductModel.fromJson(e))
        //     .toList();

        // List<BannerModel> banners = (body['banners'] as List)
        //     .map((e) => BannerModel.fromJson(e))
        //     .toList();
        List<CategoryModel> categories = (body['categories'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
        // List<OfferModel> offers = (body['offers'] as List)
        //     .map((e) => OfferModel.fromJson(e))
        //     .toList();

        return DashBoardResponse(
          banners: [],
          products: [],
          categories: categories,
          offers: [],
          currentPage: body['current_page'],
          lastPage: body['last_page'],
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CartResponse> fetchCartData() async {
    try {
      final response = await _service.fetchCartApi();
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        CartModel cart = CartModel.fromJson(body['cart']);
        return CartResponse(cart: cart, salesmanCart: []);
      } else {
        return CartResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> checkUser(String deviceId) async {
    try {
      final response = await _service.checkUser(deviceId: deviceId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        if (body.containsKey("retailer")) {
          print("RETAILER");
          RetailerModel retailer = RetailerModel.fromJson(body['retailer']);
          return AuthResponse(retailer: retailer, salesManModel: null);
        } else if (body.containsKey("salesman")) {
          print("SALESMANN");
          SalesManModel salesman = SalesManModel.fromJson(body['salesman']);
          return AuthResponse(retailer: null, salesManModel: salesman);
        } else {
          return AuthResponse.withError(response.body.toString());
        }
      } else {
        return AuthResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> placeOrder({required String? notes}) async {
    try {
      final response = await _service.placeOrder(notes: notes);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> addToCart({
    required String qty,
    required String action,
    required int prodId,
  }) async {
    try {
      final response =
          await _service.addToCart(qty: qty, action: action, prodId: prodId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> addSingleToCart(
      {required int prodId, required int? retId}) async {
    try {
      final response = await _service.addSingleToCart(
        prodId: prodId,
        retId: retId,
      );
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> fetchByCategory(
      {required int catId, required int? retId, required int? page}) async {
    try {
      final response = await _service.fetchByCategory(
        catId: catId,
        page: page,
        retId: retId,
      );
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<ProductModel> products = (body['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        // List<BannerModel> banners = (body['banners'] as List)
        //     .map((e) => BannerModel.fromJson(e))
        //     .toList();

        // List<CategoryModel> categories = (body['categories'] as List)
        //     .map((e) => CategoryModel.fromJson(e))
        //     .toList();
        // List<OfferModel> offers = (body['offers'] as List)
        //     .map((e) => OfferModel.fromJson(e))
        //     .toList();

        return DashBoardResponse(
          banners: [],
          products: products,
          categories: [],
          offers: [],
          lastPage: body['last_page'],
          currentPage: body['current_page'],
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> addOfferToCart(
      {required int qty, required int offerId, required int? retId}) async {
    try {
      final response = await _service.addOfferToCart(
        offerId: offerId,
        qty: qty,
        retId: retId,
      );
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> addOrRemoveToFavourites(
      {required int productId}) async {
    try {
      final response = await _service.addToFavorite(productId: productId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> fetchFavourites({int? page, int? retId}) async {
    try {
      final response = await _service.fetchFavourites(page: page, retId: retId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<ProductModel> products = (body['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        return DashBoardResponse(
          banners: [],
          products: products,
          categories: [],
          offers: [],
          currentPage: body['current_page'],
          lastPage: body['last_page'],
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> deleteCart(
      {required int orderId, required bool all}) async {
    try {
      final response = await _service.deleteCart(orderId: orderId, all: all);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<CartQuantity> cartQuantity({required int? retid}) async {
    try {
      final response = await _service.getCartNumber(retId: retid);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return CartQuantity(quantity: body['cart_qty']);
      } else {
        throw ServerException();
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _service.logout();
      if (response.statusCode == 204) {
      } else {
        throw ServerException();
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DistributorResponse> changeDistributor({required int distId}) async {
    try {
      final response = await _service.changeDistributor(distId: distId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);

        return DistributorResponse(
          singleDist: DistributorsModel.fromJson(body['distributor']),
          distributors: [],
        );
      } else {
        return DistributorResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DistributorResponse> fetchDistributor({required String? query}) async {
    try {
      final response = await _service.fetchDistributer(query: query);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<DistributorsModel> distributors = (body['distributors'] as List)
            .map((e) => DistributorsModel.fromJson(e))
            .toList();

        return DistributorResponse(
          singleDist: null,
          distributors: distributors,
        );
      } else {
        return DistributorResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> searchProduct(
      {required int? distId,
      required int? retId,
      required int? maxPrice,
      required int? minPrice,
      required bool isNewArrival,
      required int? catId,
      required String query}) async {
    try {
      final response = await _service.searchProducts(
        query: query,
        distributorId: distId,
        retId: retId,
        isNewArrival: isNewArrival,
        catId: catId,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<ProductModel> products = (body['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        return DashBoardResponse(
          banners: [],
          products: products,
          categories: [],
          offers: [],
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<OrderHistoryResponse> fetchOrderHistory(
      {int? page, int? retId}) async {
    try {
      final response =
          await _service.getOrdersHistory(page: page, retId: retId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<RetailOrdersModel> orders = (body['retail_orders'] as List)
            .map((e) => RetailOrdersModel.fromJson(e))
            .toList();

        return OrderHistoryResponse(
          retailOrders: orders,
          currentPage: body['current_page'],
          lastPage: body['last_page'],
        );
      }
      return OrderHistoryResponse.withError(response.body.toString());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  //*delete pending order
  @override
  Future<ApiSuccessResponse> deleteOrder({required int orderId}) async {
    try {
      final response = await _service.deleteOrder(orderId: orderId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<SingleProductResponse> fetchSingleProduct(
      {required int prodId, required int distributorId}) async {
    try {
      final response = await _service.getSingleProduct(
          prodId: prodId, distributorId: distributorId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        ProductModel product = ProductModel.fromJson(body["product"]);
        List<ProductModel> related = (body['related'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return SingleProductResponse(product: product, related: related);
      } else {
        return SingleProductResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<NotificationResponse> getNotifications() async {
    try {
      final response = await _service.getNotifications();
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<ListNotificationModel> notifications =
            (body['notifications'] as List)
                .map((e) => ListNotificationModel.fromJson(e))
                .toList();
        return NotificationResponse(notifications: notifications);
      } else {
        return NotificationResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<OfferRespose> fetchSingleOffer({required int offerId}) async {
    try {
      final response = await _service.getSingleOffer(offerId: offerId);
      final status = _call.checkStatusCode(response.statusCode);
      Map<String, dynamic> body = jsonDecode(response.body);
      if (status) {
        return OfferRespose(
            otherOffers: (body["other_offers"] as List)
                .map((e) => OfferModel.fromJson(e))
                .toList(),
            model: OfferModel.fromJson(body['offer']));
      }

      return OfferRespose.withError(response.body.toString());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DistributorResponse> changeRetailer({required int retId}) async {
    try {
      final response = await _service.changeRetailer(retId: retId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);

        return DistributorResponse(
          singleDist: null,
          distributors: null,
          singleRet: RetailerModel.fromJson(body['retailer']),
        );
      } else {
        return DistributorResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DistributorResponse> fetchRetailer({required String? query}) async {
    try {
      final response = await _service.fetchRetailer(query: query);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<RetailerModel> retailer = (body['retailers'] as List)
            .map((e) => RetailerModel.fromJson(e))
            .toList();

        return DistributorResponse(
          singleDist: null,
          distributors: null,
          retailers: retailer,
          singleRet: null,
        );
      } else {
        return DistributorResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ProfileResponse> fetchProfile() async {
    try {
      final response = await _service.getUser();
      final status = _call.checkStatusCode(response.statusCode);
      Map<String, dynamic> body = jsonDecode(response.body);
      if (status)
        return ProfileResponse(
          profile: ProfileModel.fromJson(body['profile']),
          success: "success",
        );

      return ProfileResponse.withError(response.body.toString());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ProfileResponse> changePassword(
      {required String oldPass, required String newPass}) async {
    try {
      final response =
          await _service.changePassword(oldPass: oldPass, newPass: newPass);
      final status = _call.checkStatusCode(response.statusCode);
      Map<String, dynamic> body = jsonDecode(response.body);
      if (status)
        return ProfileResponse(
          profile: null,
          success: body['message'],
        );

      return ProfileResponse.withError(response.body.toString());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> confirmDelivery({required int orderId}) async {
    try {
      final response = await _service.confirmDelivery(orderId: orderId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // @override
  // Future<ApiSuccessResponse> addSalesmanOfferToCart(
  //     {required int qty, required int offerId, required int retid}) async {
  //   try {
  //     final response = await _service.addSalesmanOfferToCart(
  //         offerId: offerId, qty: qty, retId: retid);
  //     final status = _call.checkStatusCode(response.statusCode);
  //     if (status) {
  //       Map<String, dynamic> body = jsonDecode(response.body);
  //       return ApiSuccessResponse(message: body['message']);
  //     } else {
  //       return ApiSuccessResponse.withError(response.body.toString());
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     rethrow;
  //   }
  // }

  @override
  Future<CartResponse> fetchCartDataSalesman({required int retId}) async {
    try {
      final response = await _service.fetchCartApiSalesman(retId: retId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        if (body.containsKey("carts")) {
          print("SALESMAN CART");
          return CartResponse(
            salesmanCart: (body['carts'] as List)
                .map((e) => SalesManCartModel.fromMap(e))
                .toList(),
          );
        }
        CartModel cart = CartModel.fromJson(body['cart']);
        return CartResponse(
          cart: cart,
          salesmanCart: [],
        );
      } else {
        return CartResponse.withError(response.body.toString());
      }
    } catch (e) {
      print("ERRROOOO HAPA" + e.toString());
      rethrow;
    }
  }

  @override
  Future<SingleProductResponse> fetchSingleProductSalesman(
      {required int prodId, required int retId}) async {
    try {
      final response =
          await _service.getSingleProductSalesman(prodId: prodId, retId: retId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        ProductModel product = ProductModel.fromJson(body["product"]);
        List<ProductModel> related = (body['related'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return SingleProductResponse(product: product, related: related);
      } else {
        return SingleProductResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> addToCartSalesman({
    required String qty,
    required String action,
    required int prodId,
    required int retId,
  }) async {
    try {
      final response = await _service.addToCartSalesman(
        qty: qty,
        action: action,
        prodId: prodId,
        retId: retId,
      );
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // @override
  // Future<DashBoardResponse> searchProductSalesman(
  //     {required int retId, required String query}) async {
  //   try {
  //     final response =
  //         await _service.searchProductsSalesman(query: query, retId: retId);
  //     final status = _call.checkStatusCode(response.statusCode);
  //     if (status) {
  //       Map<String, dynamic> body = jsonDecode(response.body);
  //       List<ProductModel> products = (body['products'] as List)
  //           .map((e) => ProductModel.fromJson(e))
  //           .toList();

  //       return DashBoardResponse(
  //         banners: [],
  //         products: products,
  //         categories: [],
  //         offers: [],
  //       );
  //     } else {
  //       return DashBoardResponse.withError(response.body.toString());
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     rethrow;
  //   }
  // }

  @override
  Future<ApiSuccessResponse> placeOrderSalesman(
      {required int? retId, required String? notes}) async {
    try {
      final response =
          await _service.placeOrderSalesman(retId: retId, notes: notes);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> deleteCartSalesman(
      {required int orderId, required int retId, required bool all}) async {
    try {
      final response = await _service.deleteCartSalesman(
          orderId: orderId, all: all, retId: retId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<OrderHistoryResponse> fetchOrderHistorySalesman(
      {required int retId}) async {
    try {
      final response = await _service.getOrdersHistorySalesman(retId: retId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<RetailOrdersModel> orders = (body['retail_orders'] as List)
            .map((e) => RetailOrdersModel.fromJson(e))
            .toList();

        return OrderHistoryResponse(retailOrders: orders);
      } else {
        return OrderHistoryResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> fetchPaginatedProduct({
    required int distributorId,
    required int? page,
    required int? maxPrice,
    required int? minPrice,
    required bool isNewArrival,
    required int? catId,
    int? retId,
  }) async {
    try {
      final response = await _service.getProductsPaginated(
          isNewArrival: isNewArrival,
          catId: catId,
          maxPrice: maxPrice,
          minPrice: minPrice,
          retId: retId,
          distributorId: distributorId,
          page: page);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<ProductModel> products = (body['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        return DashBoardResponse(
          banners: [],
          products: products,
          categories: [],
          offers: [],
          currentPage: body['current_page'],
          lastPage: body['last_page'],
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> getPriceLevel({required int prodId, required int qty}) async {
    try {
      final _resp = await _service.getPriceLevel(prodId: prodId, qty: qty);
      final status = _call.checkStatusCode(_resp.statusCode);
      Map<String, dynamic> body = jsonDecode(_resp.body);
      if (status) {
        return body['price'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> forgotPassword({required String email}) async {
    try {
      final _resp = await _service.fortgotPassword(email: email);
      final status = _call.checkStatusCode(_resp.statusCode);
      Map<String, dynamic> body = jsonDecode(_resp.body);
      if (status) {
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(_resp.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> getSalemsanPriceLevel(
      {required int prodId, required int qty, required int retId}) async {
    try {
      final _resp = await _service.getSalesmanPriceLevel(
        prodId: prodId,
        qty: qty,
        retId: retId,
      );
      final status = _call.checkStatusCode(_resp.statusCode);
      Map<String, dynamic> body = jsonDecode(_resp.body);
      if (status) {
        return body['price'];
      } else {
        throw ServerException();
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<OrderHistoryResponse> filterOrdes({
    required int? distId,
    required String? status,
    required int? timeStampFrom,
    required int? timeStampTo,
    required int? retId,
  }) async {
    try {
      final response = await _service.filterOrders(
        distId: distId,
        status: status,
        timeStampFrom: timeStampFrom,
        timeStampTo: timeStampTo,
        retId: retId,
      );
      final _status = _call.checkStatusCode(response.statusCode);
      if (_status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<RetailOrdersModel> orders = (body['retail_orders'] as List)
            .map((e) => RetailOrdersModel.fromJson(e))
            .toList();

        return OrderHistoryResponse(retailOrders: orders);
      } else {
        return OrderHistoryResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DistributorResponse> searchRetailer({required String query}) async {
    try {
      final response = await _service.searchRetailer(query: query);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<RetailerModel> retailer = (body['retailers'] as List)
            .map((e) => RetailerModel.fromJson(e))
            .toList();

        return DistributorResponse(
          singleDist: null,
          distributors: null,
          retailers: retailer,
          singleRet: null,
        );
      } else {
        return DistributorResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ApiSuccessResponse> reorder({required int orderId}) async {
    try {
      final response = await _service.reorder(orderId: orderId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return ApiSuccessResponse(message: body['message']);
      } else {
        return ApiSuccessResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> getSingleCategory({required int categoryId}) async {
    try {
      final response = await _service.getSingleCategory(categoryId: categoryId);

      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<CategoryModel> subCategories = (body['sub_categories'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();
        return DashBoardResponse(
          banners: [],
          products: [],
          categories: subCategories,
          offers: [],
          category: CategoryModel.fromJson(body['category']),
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> getNewArrivals({int? retId, int? page}) async {
    try {
      final response = await _service.getNewArrivals(retId: retId, page: page);

      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<ProductModel> products = (body['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        return DashBoardResponse(
          banners: [],
          products: products,
          categories: [],
          offers: [],
          currentPage: body['current_page'],
          lastPage: body['last_page'],
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> getBanners({int? distId}) async {
    try {
      final response = await _service.getBanners(distId: distId);

      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<BannerModel> banners = (body['banners'] as List)
            .map((e) => BannerModel.fromJson(e))
            .toList();

        return DashBoardResponse(
          banners: banners,
          products: [],
          categories: [],
          offers: [],
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> getOffers({int? distId}) async {
    try {
      final response = await _service.getOffers(distId: distId);

      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<OfferModel> offer = (body['offers'] as List)
            .map((e) => OfferModel.fromJson(e))
            .toList();

        return DashBoardResponse(
          banners: [],
          products: [],
          categories: [],
          offers: offer,
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getProductDescription({required int prodId}) async {
    try {
      final response = await _service.getDesc(prodId: prodId);

      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> _body = jsonDecode(response.body);
        return _body["description"];
      } else {
        return networkErrorHandler(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> getRelated(
      {required int prodId, int? retId}) async {
    try {
      final response = await _service.getRelated(prodId: prodId, retId: retId);

      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<ProductModel> _products = (body['related'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        return DashBoardResponse(
          banners: [],
          products: _products,
          categories: [],
          offers: [],
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SlabsResponse> getSlabs({required int prodId, int? retId}) async {
    try {
      final response = await _service.getSlabs(prodId: prodId, retId: retId);

      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<SlabsModel> _slabs =
            (body['slabs'] as List).map((e) => SlabsModel.fromJson(e)).toList();

        return SlabsResponse(slabs: _slabs);
      } else {
        return SlabsResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> initializeProduct(int? page) async {
    try {
      final response = await _service.initializeProducts(page: page);
      final status = _call.checkStatusCode(response.statusCode);
      Map<String, dynamic> body = jsonDecode(response.body);
      if (status) {
        final _prod = (body['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        return DashBoardResponse(
          banners: [],
          products: _prod,
          categories: [],
          offers: [],
          lastPage: body['last_page'],
          currentPage: body['current_page'],
        );
      }
      return DashBoardResponse.withError(response.body);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CartResponse> syncCart(List<SyncModel> sync) async {
    try {
      final response = await _service.syncCart(sync: sync);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        CartModel cart = CartModel.fromJson(body['cart']);
        return CartResponse(cart: cart, salesmanCart: []);
      } else {
        return CartResponse.withError(response.body.toString());
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> fetchTopProducts(
      {required int? distributorId}) async {
    try {
      final response =
          await _service.fetchTopProducts(distributorId: distributorId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<ProductModel> products = (body['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        return DashBoardResponse(
          banners: [],
          products: products,
          categories: [],
          offers: [],
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<DashBoardResponse> fetchRecentBought(
      {required int? distributorId, required int? retId}) async {
    try {
      final response = await _service.fetchRecentlyBought(
          retId: retId, distributorId: distributorId);
      final status = _call.checkStatusCode(response.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(response.body);
        List<ProductModel> products = (body['products'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();

        return DashBoardResponse(
          banners: [],
          products: products,
          categories: [],
          offers: [],
        );
      } else {
        return DashBoardResponse.withError(response.body.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<TransportResponse> fetchTransport(int retId) async {
    try {
      final _res = await _service.fetchTransport(retId);
      final status = _call.checkStatusCode(_res.statusCode);
      if (status) {
        Map<String, dynamic> body = jsonDecode(_res.body);
        List<TransportModel> _trans = (body['transport_details'] as List)
            .map((e) => TransportModel.fromJson(e))
            .toList();

        return TransportResponse(_trans);
      }
      return TransportResponse.withError(_res.body);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
