import 'dart:convert';

import 'package:biz_mobile_app/features/domain/models/Cart/sync_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/HandleNetworkCall.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/logging_interceptor.dart';

abstract class Api {
  Future<http.Response> sendLocation({
    required String lat,
    required String lon,
    required int id,
  });
  Future<http.Response> login({
    required String email,
    required String password,
    required String deviceId,
  });

  Future<http.Response> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<http.Response> checkUser({
    required String deviceId,
  });

  Future<http.Response> fetchBannersApi({required int id});
  Future<http.Response> fetchDashBoardApi({required int id});
  Future<http.Response> fetchCategories(
      {required int? distributerId, int? page});
  Future<http.Response> fetchCartApi();
  Future<http.Response> placeOrder({required String? notes});
  Future<http.Response> addToCart({
    required String qty,
    required String action,
    required int prodId,
  });
  Future<http.Response> deleteCart({required int orderId, required bool all});
  Future<http.Response> getCartNumber({required int? retId});
  Future<http.Response> addSingleToCart({
    required int prodId,
    required int? retId,
  });

  Future<http.Response> fetchByCategory({
    required int catId,
    required int? retId,
    required int? page,
  });
  Future<http.Response> addOfferToCart({
    required int offerId,
    required int qty,
    required int? retId,
  });
  Future<http.Response> addToFavorite({required productId});
  Future<http.Response> fetchFavourites({
    required int? retId,
    required int? page,
  });
  Future<http.Response> logout();
  Future<http.Response> fetchDistributer({required String? query});
  Future<http.Response> changeDistributor({required int distId});
  Future<http.Response> searchProducts({
    required String query,
    required int? distributorId,
    required int? retId,
    required int? maxPrice,
    required int? minPrice,
    required bool isNewArrival,
    required int? catId,
  });
  Future<http.Response> getOrdersHistory({int? page, int? retId});
  Future<http.Response> deleteOrder({required int orderId});
  Future<http.Response> getSingleProduct(
      {required int prodId, required int distributorId});
  Future<http.Response> getNotifications();
  Future<http.Response> getSingleOffer({required int offerId});
  Future<http.Response> getUser();
  Future<http.Response> changePassword({
    required String oldPass,
    required String newPass,
  });
  Future<http.Response> getPriceLevel({required int prodId, required int qty});

  //!SALESMANN
  // Future<http.Response> fetchSalesManDashBoardApi({required retailerId});
  // Future<http.Response> getSalesManCartNumber({});
  Future<http.Response> fetchRetailer({required String? query});
  Future<http.Response> changeRetailer({required int retId});

  Future<http.Response> confirmDelivery({required int orderId});
  // Future<http.Response> addSalesmanOfferToCart({
  //   required int offerId,
  //   required int qty,
  // });
  // Future<http.Response> fetchByCategorySalesMan({
  //   required int catId,
  //   required int retId,
  // });
  Future<http.Response> fetchCartApiSalesman({required int retId});
  // Future<http.Response> addSingleToCartSalesman({
  //   required int prodId,

  // });

  Future<http.Response> getSingleProductSalesman(
      {required int prodId, required int retId});

  Future<http.Response> addToCartSalesman({
    required String qty,
    required String action,
    required int prodId,
    required int retId,
  });
  // Future<http.Response> searchProductsSalesman({
  //   required String query,
  //   required int retId,
  // });
  Future<http.Response> placeOrderSalesman(
      {required int? retId, required String? notes});
  Future<http.Response> deleteCartSalesman(
      {required int orderId, required int retId, required bool all});
  Future<http.Response> getOrdersHistorySalesman({required int retId});
  // Future<http.Response> deleteOrderSalesman({required int orderId,});
  // Future<http.Response> fetchFavouritesSalesman({required int retId});
  Future<http.Response> getProductsPaginated({
    required int distributorId,
    required int? page,
    required int? retId,
    required int? maxPrice,
    required int? minPrice,
    required bool isNewArrival,
    required int? catId,
  });
  Future<http.Response> getSalesmanPriceLevel({
    required int prodId,
    required int qty,
    required int retId,
  });
  Future<http.Response> fortgotPassword({required String email});
  Future<http.Response> filterOrders({
    required int? distId,
    required String? status,
    required int? timeStampFrom,
    required int? retId,
    required int? timeStampTo,
  });
  Future<http.Response> searchRetailer({required String query});
  Future<http.Response> reorder({required int orderId});
  Future<http.Response> getSingleCategory({required int categoryId});
  Future<http.Response> getNewArrivals({required int? retId, int? page});
  Future<http.Response> getBanners({required int? distId});
  Future<http.Response> getOffers({required int? distId});
  Future<http.Response> getSlabs({required int prodId, required int? retId});
  Future<http.Response> getDesc({required int prodId});
  Future<http.Response> getRelated({required int prodId, required int? retId});

  Future<http.Response> initializeProducts({required int? page});
  Future<http.Response> syncCart({required List<SyncModel> sync});
  Future<http.Response> deleteAllCart();
  Future<http.Response> fetchTopProducts({required int? distributorId});
  Future<http.Response> fetchRecentlyBought(
      {required int? distributorId, required int? retId});

  Future<http.Response> fetchTransport(int retId);
}

@LazySingleton(as: Api)
class ApiImpl implements Api {
  http.Client client = InterceptedClient.build(
    interceptors: [
      LoggingInterceptor(),
    ],
    requestTimeout: Duration(seconds: 60), //timesout after sixisty seconds
  );

  final HandleNetworkCall networkCall; //success failure checker

  ApiImpl({required this.networkCall});

  @override
  Future<http.Response> sendLocation({
    required String lat,
    required String lon,
    required int id,
  }) async {
    final _url = "retailer/api/auth/retail_user/";
    final String token = await networkCall.authToken();

    return client.patch(
      Uri.https(BASE_URL, _url),
      headers: {
        "Authorization": token,
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "latitude": lat,
        'longitude': lon,
        "distributor_id": id.toString(),
      }),
    );
  }

  @override
  Future<http.Response> login({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    final String url = "/mobile/login";
    // String device_id = await getToken();
    return client.post(
      //Uri.httpss(BASE_URL, url), //* if its http useUri.https(BASE_URL, url)
      Uri.https(BASE_URL, url), //* if its http useUri.https(BASE_URL, url)
      headers: {"Accept": "application/json"},
      body: {
        "email": email,
        "password": password,
        "device_id": deviceId,
      },
    );
  }

  @override
  Future<http.Response> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    final String url = "/mobile/register";
    return client.post(
      //Uri.httpss(BASE_URL,url), //* if its http,i.e not secured useUri.https(BASE_URL, url)
      Uri.https(BASE_URL, url),
      headers: {"Accept": "application/json"},
      body: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
      },
    );
  }

  @override
  Future<http.Response> fetchBannersApi({required int id}) async {
    final String url = "/retailer/api/retail_banners/?distributor_id=$id";
    final token = await networkCall.authToken();
    return client.post(
      //Uri.httpss(BASE_URL, url),
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> fetchDashBoardApi({required int id}) async {
    final String url = "/retailer/api/retail_dashboard";
    final String token = await networkCall.authToken();

    return client.get(
      Uri.https(BASE_URL, url).replace(query: 'distributor_id=$id'),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> fetchCategories({
    required int? distributerId,
    int? page,
  }) async {
    final String url = 'retailer/api/retailer_categories';
    final String token = await networkCall.authToken();

    final queryParameters = {
      "distributor_id": distributerId.toString(),
      "page": "${page ?? ""}",
    };

    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> fetchCartApi() async {
    final String url = '/mobile/cart_';
    final String token = await networkCall.authToken();
    final queryParams = {"action": "cart_items"};
    return client.get(
      Uri.https(BASE_URL, url, queryParams),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> checkUser({required String deviceId}) async {
    final String url = '/retailer/api/retailer_user';
    final String token = await networkCall.authToken();

    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: json.encode({deviceId}),
    );
  }

  @override
  Future<http.Response> placeOrder({required String? notes}) async {
    final String url = '/mobile/cart_';
    final String token = await networkCall.authToken();

    return client.put(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "notes": notes ?? "",
      },
    );
  }

  @override
  Future<http.Response> addToCart({
    required String qty,
    required String action,
    required int prodId,
  }) async {
    final String url = '/mobile/cart_';
    final String token = await networkCall.authToken();

    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "qty": qty,
        "action": action,
        "product_id": prodId.toString(),
      },
    );
  }

  @override
  Future<http.Response> addSingleToCart({
    required int prodId,
    required int? retId,
  }) async {
    final String url = '/mobile/cart_';
    final String token = await networkCall.authToken();

    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "product_id": prodId.toString(),
        "retailer_id": retId?.toString() ?? "",
      },
    );
  }

  //*sj
  @override
  Future<http.Response> deleteCart(
      {required int orderId, required bool all}) async {
    final String url = '/mobile/cart_';
    // order_id=$orderId
    final String token = await networkCall.authToken();

    final queryParameters = {
      'order_id': '$orderId',
      "action": all ? "all" : ""
    };

    return client.delete(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
      // body: {
      //   "order_id": orderId.toString(),
      // },
    );
  }

  @override
  Future<http.Response> getCartNumber({required int? retId}) async {
    final String url = '/mobile/cart_';
    final String token = await networkCall.authToken();
    final queryParams = {
      "retailer_id": retId?.toString() ?? "",
      "action": "cart_qty",
    };

    return client.get(
      Uri.https(BASE_URL, url, queryParams),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> fetchByCategory(
      {required int catId, required int? retId, required int? page}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/category/$catId/products';
    final quertParams = {
      "retailer_id": retId?.toString() ?? "",
      "page": page?.toString() ?? ""
    };
    return client.get(
      Uri.https(BASE_URL, url, quertParams),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> addOfferToCart(
      {required int offerId, required int? retId, required int qty}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/purchase/offer/';
    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "offer_id": offerId.toString(),
        "qty": qty.toString(),
        "retailer_id": retId?.toString() ?? "",
      },
    );
  }

  @override
  Future<http.Response> addToFavorite({required productId}) async {
    //*user can also remove from fav with this method
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/favorites/';
    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "product_id": productId.toString(),
      },
    );
  }

  @override
  Future<http.Response> fetchFavourites({
    required int? retId,
    required int? page,
  }) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/favorites';
    final queryParams = {
      'retailer_id': retId.toString(),
      "page": page.toString()
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParams),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> logout() async {
    final String token = await networkCall.authToken();
    final String url = '/retailer/api/auth/logout';
    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> changeDistributor({required int distId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/retailer/distributors/';
    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "distributor_id": distId.toString(),
      },
    );
  }

  @override
  Future<http.Response> fetchDistributer({required String? query}) async {
    final queryParameters = {
      'search': query ?? "",
    };
    final String token = await networkCall.authToken();
    final String url = '/mobile/retailer/distributors';
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> searchProducts({
    required String query,
    required int? distributorId,
    required int? retId,
    required int? maxPrice,
    required int? minPrice,
    required bool isNewArrival,
    required int? catId,
  }) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/search';

    final queryParameters = {
      'search': query,
      'distributor_id': distributorId?.toString() ?? "",
      'retailer_id': retId?.toString() ?? "",
      'price_from': minPrice?.toString() ?? "",
      'price_to': maxPrice?.toString() ?? "",
      "new_arrival": isNewArrival ? "yes" : "",
      "category_id": catId?.toString() ?? "",
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getOrdersHistory({int? page, int? retId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/orders/history';
    final queryParameters = {
      // 'order_id': '$orderId',
      'retailer_id': '${retId ?? ""}',
      "page": "$page"
    };

    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> deleteOrder({required int orderId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/orders/history';
    final queryParameters = {
      "order_id": orderId.toString(),
    };

    return client.delete(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getSingleProduct(
      {required int prodId, required int distributorId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/single';

    final queryParameters = {
      "product_id": prodId.toString(),
      "distributor_id": distributorId.toString(),
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getNotifications() async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/retailer/notifications';
    return client.get(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getSingleOffer({required int offerId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/retailer/offers';
    final queryParameters = {
      "offer_id": offerId.toString(),
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  //!SALESMANN
  // @override
  // Future<http.Response> fetchSalesManDashBoardApi({required retailerId}) async {
  //   final String url = "/retailer/api/retail_dashboard";
  //   final String token = await networkCall.authToken();

  //   return client.get(
  //     Uri.https(BASE_URL, url).replace(query: 'retailer_id=$retailerId'),
  //     headers: {"Authorization": token, "Accept": "application/json"},
  //   );
  // }

  //

  @override
  Future<http.Response> changeRetailer({required int retId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/salesman/retailers';
    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "retailer_id": retId.toString(),
      },
    );
  }

  @override
  Future<http.Response> fetchRetailer({required String? query}) async {
    final String token = await networkCall.authToken();
    final queryParameters = {
      "search": query ?? "",
    };
    final String url = '/mobile/salesman/retailers';
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> changePassword(
      {required String oldPass, required String newPass}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/profile';
    return client.post(
      Uri.https(BASE_URL, url),
      body: {
        "action": "change_password",
        "old_password": oldPass,
        "new_password": newPass,
        "repeat_password": newPass,
      },
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getUser() async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/profile';
    return client.get(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> confirmDelivery({required int orderId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/orders/history';

    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "ret_order_id": orderId.toString(),
        "action": "confirm",
      },
    );
  }

  // @override
  // Future<http.Response> addSalesmanOfferToCart({
  //   required int offerId,
  //   required int qty,
  //   required int retId,
  // }) async {
  //   final String token = await networkCall.authToken();
  //   final String url = '/mobile/purchase/offer/';

  //   return client.post(
  //     Uri.https(BASE_URL, url),
  //     headers: {"Authorization": token, "Accept": "application/json"},
  //     body: {
  //       "offer_id": offerId.toString(),
  //       "qty": qty.toString(),
  //       "retailer_id": retId.toString(),
  //     },
  //   );
  // }

  // @override
  // Future<http.Response> fetchByCategorySalesMan(
  //     {required int catId, required int retId}) async {
  //   final String token = await networkCall.authToken();
  //   final String url = '/mobile/category/$catId/products';
  //   final quertParams = {
  //     "retailer_id": retId.toString(),
  //   };
  //   return client.get(
  //     Uri.https(BASE_URL, url, quertParams),
  //     headers: {"Authorization": token, "Accept": "application/json"},
  //   );
  // }

  @override
  Future<http.Response> fetchCartApiSalesman({required int retId}) async {
    final String url = '/mobile/cart_';
    final String token = await networkCall.authToken();
    final quertParams = {
      "retailer_id": retId.toString(),
      "action": "cart_items"
    };
    return client.get(
      Uri.https(BASE_URL, url, quertParams),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  // @override
  // Future<http.Response> addSingleToCartSalesman(
  //     {required int prodId, required int retId}) async {
  //   final String url = '/mobile/cart_';
  //   final String token = await networkCall.authToken();
  //   final quertParams = {
  //     "retailer_id": retId.toString(),
  //   };
  //   return client.post(
  //     Uri.https(BASE_URL, url, quertParams),
  //     headers: {"Authorization": token, "Accept": "application/json"},
  //     body: {
  //       "id": prodId.toString(),
  //     },
  //   );
  // }

  @override
  Future<http.Response> getSingleProductSalesman(
      {required int prodId, required int retId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/single';

    final queryParameters = {
      "product_id": prodId.toString(),
      "retailer_id": retId.toString(),
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> addToCartSalesman({
    required String qty,
    required String action,
    required int prodId,
    required int retId,
  }) async {
    final String url = '/mobile/cart_';
    final String token = await networkCall.authToken();

    return client.post(
      Uri.https(
        BASE_URL,
        url,
      ),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "qty": qty,
        "action": action,
        "product_id": prodId.toString(),
        "retailer_id": retId.toString(),
      },
    );
  }

  @override
  Future<http.Response> placeOrderSalesman({
    required int? retId,
    required String? notes,
  }) async {
    final String url = '/mobile/cart_';
    final String token = await networkCall.authToken();

    return client.put(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "notes": notes ?? "",
        'retailer_id': '${retId ?? ""}',
      },
    );
  }

  @override
  Future<http.Response> deleteCartSalesman(
      {required int orderId, required int retId, required bool all}) async {
    final String url = '/mobile/cart_';
    // order_id=$orderId
    final String token = await networkCall.authToken();

    final queryParameters = {
      'order_id': '$orderId',
      'retailer_id': '$retId',
      'action': all ? "all" : "",
    };

    return client.delete(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
      // body: {
      //   "order_id": orderId.toString(),
      // },
    );
  }

  @override
  Future<http.Response> getOrdersHistorySalesman({required int retId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/orders/history';
    final queryParameters = {
      // 'order_id': '$orderId',
      'retailer_id': '$retId',
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getProductsPaginated(
      {required int distributorId,
      required int? maxPrice,
      required int? minPrice,
      required bool isNewArrival,
      required int? catId,
      required int? page,
      required int? retId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/search';

    final queryParameters = {
      "page": page?.toString() ?? "",
      "distributor_id": distributorId.toString(),
      "retailer_id": retId?.toString() ?? "",
      'price_from': minPrice?.toString() ?? "",
      'price_to': maxPrice?.toString() ?? "",
      "new_arrival": isNewArrival ? "yes" : "",
      "category_id": catId?.toString() ?? "",
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getPriceLevel(
      {required int prodId, required int qty}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/price';

    final queryParameters = {
      "product_id": prodId.toString(),
      "qty": qty.toString(),
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> fortgotPassword({required String email}) {
    final String url = '/retailer/api/auth/forgot';
    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Accept": "application/json"},
      body: json.encode({"email": email}),
    );
  }

  @override
  Future<http.Response> getSalesmanPriceLevel(
      {required int prodId, required int qty, required int retId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/price';

    final queryParameters = {
      "product_id": prodId.toString(),
      "qty": qty.toString(),
      "retailer_id": retId.toString(),
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> filterOrders({
    required int? distId,
    required String? status,
    required int? timeStampFrom,
    required int? timeStampTo,
    required int? retId,
  }) async {
    final String token = await networkCall.authToken();
    final String url = "/mobile/orders/filter";

    final queryParameters = {
      "distributor_id": distId?.toString() ?? "",
      "to": timeStampTo?.toString() ?? "",
      "from": timeStampFrom?.toString() ?? "",
      "status": status ?? "",
      "retailer_id": retId?.toString() ?? ""
    };

    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> searchRetailer({required String query}) async {
    final String token = await networkCall.authToken();

    final String url = '/mobile/salesman/retailers';
    final queryParameters = {"search": query};

    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> reorder({required int orderId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/orders/history';

    return client.post(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
      body: {
        "ret_order_id": orderId.toString(),
        "action": "re_order",
      },
    );
  }

  @override
  Future<http.Response> getSingleCategory({required int categoryId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/category/single';

    final queryParameters = {"category_id": categoryId.toString()};

    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getNewArrivals({required int? retId, int? page}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/new';
    final queryParameters = {
      "distributor_id": retId?.toString() ?? "",
      "retailer_id": retId?.toString() ?? "",
      "page": page?.toString() ?? "",
    };

    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getBanners({required int? distId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/banners';
    final queryParameters = {
      "distributor_id": distId?.toString() ?? "",

      // "page": page?.toString() ?? "",
    };

    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getOffers({required int? distId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/offers';
    final queryParameters = {
      "distributor_id": distId?.toString() ?? "",
      // "page": page?.toString() ?? "",
    };

    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getDesc({required int prodId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/single';

    final queryParameters = {
      "product_id": prodId.toString(),
      "action": "description",
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getRelated(
      {required int prodId, required int? retId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/single';

    final queryParameters = {
      "product_id": prodId.toString(),
      "action": "related",
      "retailer_id": retId?.toString() ?? ""
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> getSlabs(
      {required int prodId, required int? retId}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/products/single';

    final queryParameters = {
      "product_id": prodId.toString(),
      "retailer_id": retId?.toString() ?? "",
      "action": "slabs"
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> initializeProducts({required int? page}) async {
    final String token = await networkCall.authToken();
    final String url = '/mobile/salesman/products';

    final queryParameters = {"page": page.toString()};
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> syncCart({required List<SyncModel> sync}) async {
    final String token = await networkCall.authToken();
    final url = '/mobile/cart/sync';
    return client.post(
      Uri.https(BASE_URL, url),
      headers: {
        "Authorization": token,
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(sync.toList()),
    );
  }

  @override
  Future<http.Response> deleteAllCart() {
    // TODO: implement deleteAllCart
    throw UnimplementedError();
  }

  @override
  Future<http.Response> fetchTopProducts({required int? distributorId}) async {
    final String url = '/mobile/products/search';
    final String token = await networkCall.authToken();
    final queryParameters = {
      "distributor_id": distributorId?.toString() ?? "",
      "top": "top"
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> fetchRecentlyBought(
      {required int? distributorId, required int? retId}) async {
    final String url = '/mobile/products/search';
    final String token = await networkCall.authToken();
    final queryParameters = {
      'distributor_id': distributorId?.toString() ?? "",
      'retailer_id': retId?.toString() ?? "",
      "recent": "recent",
    };
    return client.get(
      Uri.https(BASE_URL, url, queryParameters),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }

  @override
  Future<http.Response> fetchTransport(int retId) async {
    final String url = '/mobile/orders/history/details/$retId';
    final String token = await networkCall.authToken();
    return client.get(
      Uri.https(BASE_URL, url),
      headers: {"Authorization": token, "Accept": "application/json"},
    );
  }
}
