import 'dart:io';

import 'package:biz_mobile_app/core/errors/exeptions.dart';
import 'package:biz_mobile_app/features/data/datasourse/firebase/firebase.dart';
import 'package:biz_mobile_app/features/data/datasourse/location/location_data_source.dart';

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
import 'package:biz_mobile_app/features/domain/models/Cart/salesman_cart_model.dart';
import 'package:biz_mobile_app/features/domain/models/Cart/sync_model.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/models/SalesMan/SalesManModel.dart';
import 'package:biz_mobile_app/features/domain/models/notification/list_notification_model.dart';
import 'package:biz_mobile_app/features/domain/models/notification/notification_model.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/utils/constants.dart';
import '../../domain/models/distributors/Distributors.dart';
import '../../domain/models/retailers/RetailerModel.dart';
import '../../domain/models/token_model.dart';
import '../../domain/repositories/repository.dart';
import '../datasourse/local/local_data_source.dart';
import '../datasourse/remote/remote_data.dart';
import '../responses/AuthResponse.dart';
import '../responses/DashBoardResponse.dart';

//this is where the magic happens 🧚‍♂️️
@LazySingleton(as: Repository) //injecting the class ie. read about unjectable

//*  final _dist = await _local.fetchDistributor(); fetch current distributor and also check if user is retailer
//*  final _ret = await _local.fetchRetailer(); fetch current retailer and also check if usee is salesman
class RepositoryImplementation implements Repository {
  final LocalDataSource _local;
  final RemoteDataSource _remote;
  final LocationDataSource _location;
  // final Connectivity _connectivity;
  final FirebaseHelper _firebaseHelper;

  List<int> _listProduct = const [];

  RepositoryImplementation(
    this._local,
    this._remote,
    this._location,
    // this._connectivity,
    this._firebaseHelper,
  );
  //!Connection CHecker
  // @override
  // Stream<Either<String, bool>> checkConnection() async* {
  //   yield* _connectivity.onConnectivityChanged.map((e) {
  //     if (e == ConnectivityResult.none) {
  //       return right<String, bool>(false);
  //     }
  //     return right<String, bool>(true);
  //   }).onErrorReturnWith((e, s) {
  //     print(e.toString() + "," + s.toString());
  //     final failure = returnFailure(e);
  //     return left(failure);
  //   });
  // }

  @override
  Future<Either<String, String>> sendLocation() async {
    try {
      final _loc = await _location.getUserLocation();
      final _dist = await _local.fetchDistributor();
      if (_dist != null) {
        await _remote.sendLocation(
          lat: _loc.latitude.toString(),
          lon: _loc.longitude.toString(),
          id: _dist.id,
        );
      }
      return right("success");
    } catch (e) {
      final failure = returnFailure(e);
      return left(failure);
    }
  }

  // Future

  //stream on message
  @override
  Stream<Either<String, NotificationResponse>?> streamOnMessage() async* {
    // final offers = await _remote.of
    // final offers = await _offersLocal.getOffers();
    yield* FirebaseMessaging.onMessage.map((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        final response = NotificationResponse(
          notifications: [],
          // offers: offers,
          singleNotification: ListNotificationModel(
            id: message.data['id'],
            distributor: message.data['distributor'],
            display_text: message.data['display_text'],
            detail: message.data['detail'],
            status: message.data['status'],
            offer: message.data['offer'],
            product: message.data['product'],
            name: message.data['name'],
            pic: message.data['pic'],
          ),
          notificationModel: NotificationModel(
            body: message.notification?.body ?? "",
            message: message,
            title: message.notification?.title ?? "",
          ),
        );
        return right<String, NotificationResponse>(response);
      }
    }).onErrorReturnWith((e, s) {
      print(e.toString() + "," + s.toString());
      final failure = returnFailure(e);
      return left(failure);
    });
  }

//stream on messageOppened
  @override
  Stream<Either<String, NotificationResponse>?>
      streamOnMessageOppenedApp() async* {
    // final offers = await _offersLocal.getOffers();
    yield* FirebaseMessaging.onMessageOpenedApp.map((message) {
      // print("hapa messages ivi");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        final response = NotificationResponse(
          // offers: offers,
          notifications: [],
          singleNotification: ListNotificationModel(
            id: message.data['id'],
            distributor: message.data['distributor'],
            display_text: message.data['display_text'],
            detail: message.data['detail'],
            status: message.data['status'],
            offer: message.data['offer'],
            product: message.data['product'],
            name: message.data['name'],
            pic: message.data['pic'],
          ),
          notificationModel: NotificationModel(
            body: message.notification?.body ?? "",
            message: message,
            title: message.notification?.title ?? "",
          ),
        );
        return right<String, NotificationResponse>(response);
      }
    }).onErrorReturnWith((e, s) {
      print(e.toString() + "," + s.toString());
      final failure = returnFailure(e);
      return left(failure);
    });
  }

  //Initial message
  @override
  Future<Either<String, NotificationResponse?>> getInitialMessage() async {
    try {
      return right(await _firebaseHelper.getInitialMessage());
    } catch (e) {
      print(e.toString());
      final failure = returnFailure(e);
      return left(failure);
    }
  }

  @override
  Future<Either<String, AuthResponse>> login({
    required String email,
    required String password,
    // required String deviceId,
  }) async {
    try {
      //get fcm and send to user
      final fcmToken = await _firebaseHelper.getFcmToken();
      print("FCM TOKEN LOGIN: $fcmToken");
      // TokenEntity interface;
      AuthResponse authResponse = await _remote.login(
        email: email,
        password: password,
        deviceId: fcmToken != null
            ? fcmToken
            : throw Exception("No Fcm Token Detected"),
      );
      if (authResponse.error != null && authResponse.error!.length != 0) {
        return left(authResponse.error!);
      } else {
        TokenModel tokenModel = authResponse.tokenModel!;
        RetailerModel? retailer = authResponse.retailer;
        SalesManModel? salesManModel = authResponse.salesManModel;

        if (retailer != null) {
          if (retailer.distributors!.length > 0) {
            await _local.saveFirstDistributor(retailer.distributors!.first);
            final _loc = await _location.getUserLocation();
            // final _dist = await _local.fetchDistributor();
            await _remote.sendLocation(
              lat: _loc.latitude.toString(),
              lon: _loc.longitude.toString(),
              id: retailer.distributors!.first.id,
            );
          }

          await _local.cacheToken(model: tokenModel);
          await _local.saveuser(retailer);
          // await _retailerLocalData.insertToRetailers(retailer);
        }
        if (salesManModel != null) {
          await _local.cacheToken(model: tokenModel);
          await _local.saveRetailer(salesManModel.retailers!.first);
          await _local.saveSalesmanDistributor(salesManModel.distributor);
        }
        _local
          // ..deleteArrivals()
          ..deleteBanners()
          ..deleteCategories()
          ..deleteAllCart()
          ..deleteOffers()
          ..deleteProducts()
              .onError((error, stackTrace) => throw DatabaseExeption());
        return right(authResponse);
      }
    } catch (e) {
      print(e.toString());
      final failure = returnFailure(e);
      return left(failure);
    }
  }

//check if app is oppened for first time
  @override
  Future<bool> checkFirstTime() async {
    try {
      bool firstTime = await _local.checkFirstTime();
      return firstTime;
    } catch (e) {
      return false;
    }
  }

  //fetch local signed user
  @override
  Future<Either<String, RetailerModel>> fetchLocalUser() async {
    try {
      final user = await _local.getUser();
      return right(user);
    } catch (e) {
      print(e.toString());
      final failureMessage = returnFailure(e);
      return left(failureMessage);
    }
  }

  //save first time oppened app
  @override
  Future<Either<String, bool>> saveFirstTime() async {
    try {
      await _local.saveFirstTime();
      return right(true);
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  //ignored
  @override
  Future<Either<String, DashBoardResponse>> fetchDashBoardResponse() async {
    try {
      DashBoardResponse response = DashBoardResponse(
        banners: [],
        products: [],
        categories: [],
        offers: [],
      );

      DistributorsModel? distributor = await _local.fetchDistributor();
      RetailerModel? retailer = await _local.fetchRetailer();
      if (distributor != null)
        response = await _remote.fetchDashBoardData(distributor.id);

      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        // await _offersLocal.insertToOffers(response.offers);
        return right(response);
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> fetchCategory(
      {required int? page}) async {
    try {
      final _dist = await _local.fetchDistributor();

      // await _local.deleteCategories();
      DistributorsModel? distributor = await _local.fetchDistributor();
      DashBoardResponse response = await _remote.fetchCategories(
        page: page,
        distributorId: distributor?.id,
      );

      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      if (_dist != null) return right(response); //no save to locl when salseman

      await _local.insertCategories(response.categories);

      return right(response);
    } catch (e) {
      if (e is SocketException) {
        final _row = await _local.countCats();
        final _cats = await _local.getCategories(page: page);
        if (_cats.isNotEmpty) {
          return right(
            DashBoardResponse(
              banners: [],
              products: [],
              categories: _cats,
              offers: [],
              currentPage: page,
              lastPage: (_row / 20).ceil(),
            ),
          );
        }
      }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, CartResponse>> fetchCart() async {
    try {
      CartResponse response = CartResponse(salesmanCart: []);
      final _ret = await _local.fetchRetailer();
      if (_ret != null) {
        //for salsesman offfline overrides online
        final _salesmanCart = await _local.getCart();

        // final _orders = await _local.getCart();

        // sync = _orders
        //     .map((e) => SyncModel(
        //           productId: e.product.id,
        //           cartQty: e.qty,
        //           retId: e.retailerModel!.id,
        //         ))
        //     .toList();
        List<SyncModel> _finalSynch = const [];
        List<SyncModel> _sync = const [];
        if (_salesmanCart.isNotEmpty) {
          for (final _sales in _salesmanCart) {
            _sync = _sales.cart.orders
                .map((e) => SyncModel(
                      productId: e.product.id,
                      cartQty: e.qty,
                      retId: _sales.retailer.id,
                    ))
                .toList();

            print("SYNCH: " + _sync.toString());
            _finalSynch = [..._finalSynch, ..._sync];
          }
          // _sync = _cart.map((e) => null)

          print("FINAL SYNCH: " + _finalSynch.toString());

          //
          _listProduct = _finalSynch.map((e) => e.productId).toList();
        }

        //sycn cart first then fetch
        await _remote.syncCart(_finalSynch);

        response = await _remote.fetchCartDataSalesman(retId: _ret.id);

        //
      } else {
        response = await _remote.fetchCartData();
      }
      //when error happens
      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      if (response.salesmanCart.isNotEmpty) {
        if (_ret != null) {
          //insert to local db after fetching
          response.salesmanCart.forEach((e) async {
            await _local.insertCart(
                cart: e.cart.orders
                    .where((order) => order.applied_offer == null)
                    .map((e) =>
                        InsertCartObject(product: e.product, cartQty: e.qty))
                    .toList(),
                ret: e.retailer);
          });
          // await _local.insertCart(cart: [InsertCartObjec()], ret: ret);
          final _singleCart = response.salesmanCart
              .where(
                (e) => e.retailer.id == _ret.id,
              )
              .toList();

          final _cart = response.salesmanCart
              .where((e) => e.retailer.id != _ret.id)
              .toList();

          return right(CartResponse(salesmanCart: [..._singleCart, ..._cart]));
        }
      }

      return right(response);
    } catch (e) {
      if (e is SocketException) {
        final _ret = await _local.fetchRetailer();
        if (_ret != null) {
          final _salesmanCart = await _local.getCart();
          if (_salesmanCart.isNotEmpty) {
            final _singleCart = _salesmanCart
                .where(
                  (e) => e.retailer.id == _ret.id,
                )
                .toList();
            final _cart =
                _salesmanCart.where((e) => e.retailer.id != _ret.id).toList();

            return right(
                CartResponse(salesmanCart: [..._singleCart, ..._cart]));
          }
          return right(CartResponse(salesmanCart: _salesmanCart));
        }
      }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, ApiSuccessResponse>> placeOrder(
      {required String? notes, int? retId}) async {
    try {
      ApiSuccessResponse response = ApiSuccessResponse(message: "");
      final _ret = await _local.fetchRetailer();
      if (_ret != null) {
        if (retId == null) return left("retailer not found");

        response = await _remote.placeOrderSalesman(
          retId: retId,
          notes: notes,
        );
      } else {
        response = await _remote.placeOrder(notes: notes);
      }
      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      }
      // if (_ret != null) await _local.deleteAllCart();

      if (retId != null) {
        _listProduct.forEach((e) async {
          await _local.resetProdQuantity(e);
        });
        await _local.deleteCartWhereRet(retId);
      }

      return right(response);
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, ApiSuccessResponse>> addToCart({
    required String qty,
    required String action,
    required int prodId,
    required ProductModel product,
  }) async {
    try {
      // await _local.updateArrQuantity(qty: int.parse(qty), id: prodId);
      ApiSuccessResponse response = ApiSuccessResponse(message: "");
      final _ret = await _local.fetchRetailer();
      if (_ret != null) {
        await _local.insertCart(
            cart: [InsertCartObject(cartQty: int.parse(qty), product: product)],
            ret: RetailerSalesModel(id: _ret.id, name: _ret.name));
        await _local.updateProdQuantity(
          qty: int.parse(qty),
          id: product.id,
        );

        response = await _remote.addToCartSalesman(
            qty: qty, action: action, prodId: prodId, retId: _ret.id);

        // await _local.updateProdQuantity(qty: int.parse(qty), id: prodId);
        // await _local.insertCart(
        //     cartQty: int.parse(qty), product: product, ret: _ret);
      } else {
        response =
            await _remote.addToCart(qty: qty, action: action, prodId: prodId);
      }
      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      }
      return right(response);
    } catch (e) {
      final _ret = await _local.fetchRetailer();
      if (e is SocketException) {
        if (_ret != null) {
          // await _local.insertCart(
          //     cartQty: int.parse(qty), product: product, ret: _ret);

          return right(ApiSuccessResponse(message: "added offline"));
        }
      }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, ApiSuccessResponse>> addSingleToCart(
      {required int prodId, required ProductModel prod}) async {
    try {
      ApiSuccessResponse response = ApiSuccessResponse(message: "");
      final _ret = await _local.fetchRetailer();
      if (_ret != null) {
        final _cartQty = await _local.fetchCartQty(retId: _ret.id, prod: prod);
        if (_cartQty != null) {
          await _local.insertCart(
              cart: [InsertCartObject(cartQty: _cartQty + 1, product: prod)],
              ret: RetailerSalesModel(id: _ret.id, name: _ret.name));
          await _local.updateProdQuantity(
            qty: _cartQty + 1,
            id: prod.id,
          );
        } else {
          await _local.insertCart(
              cart: [InsertCartObject(cartQty: 1, product: prod)],
              ret: RetailerSalesModel(id: _ret.id, name: _ret.name));
          await _local.updateProdQuantity(
            qty: 1,
            id: prod.id,
          );
        }
      }

      response = response =
          await _remote.addSingleToCart(prodId: prodId, retId: _ret?.id);

      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      }

      return right(response);
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        final _ret = await _local.fetchRetailer();
        if (_ret != null) {
          // await _local.insertCart(
          //     cartQty: prod.cartQty != null ? (prod.cartQty! + 1) : 1,
          //     product: prod,
          //     ret: _ret);
          // await _local.updateProdQuantity(
          //   qty: prod.cartQty != null ? (prod.cartQty! + 1) : 1,
          //   id: prodId,
          // );
          return right(ApiSuccessResponse(message: "added offline"));
        }
      }
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> fetchByCategory(
      {required int catId, required int? page}) async {
    try {
      final _dis = await _local.fetchDistributor();

      final _ret = await _local.fetchRetailer();

      final response = await _remote.fetchByCategory(
          catId: catId, page: page, retId: _ret?.id);

      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      if (_dis != null) return right(response);

      if (_ret != null) await _local.insertProd(response.products);

      final _row = await _local.getByCatCount(catId: catId);
      final _prod = await _local.getByCat(page: page, catId: catId);
      if (_prod.isNotEmpty)
        return right(DashBoardResponse(
          banners: [],
          products: _prod,
          categories: [],
          offers: [],
          lastPage: (_row / 20).ceil(),
          currentPage: page,
        ));

      return right(response);
    } catch (e) {
      if (e is SocketException) {
        final _row = await _local.getByCatCount(catId: catId);
        final _prod = await _local.getByCat(page: page, catId: catId);
        if (_prod.isNotEmpty)
          return right(DashBoardResponse(
            banners: [],
            products: _prod,
            categories: [],
            offers: [],
            lastPage: (_row / 20).ceil(),
            currentPage: page,
          ));
      }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, ApiSuccessResponse>> addOfferToCart(
      {required int qty, required int offerId}) async {
    try {
      ApiSuccessResponse response = ApiSuccessResponse(message: "");
      final ret = await _local.fetchRetailer();

      response = await _remote.addOfferToCart(
        qty: qty,
        offerId: offerId,
        retId: ret?.id,
      );

      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      }
      return right(response);
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, RetailerModel>> fetchRetailer() async {
    try {
      final retailer = await _local.fetchRetailer();
      if (retailer != null) {
        return right(retailer);
      } else {
        return left("Retailer Not Found");
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, ApiSuccessResponse>> addOrRemoveToFavourite(
      {required int productId}) async {
    try {
      final _ret = await _local.fetchRetailer();
      if (_ret != null) {
        return left("You cannot add/remove to favourites");
      }
      ApiSuccessResponse response =
          await _remote.addOrRemoveToFavourites(productId: productId);
      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      }
      return right(response);
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> fetchFavourites(
      {required int? page}) async {
    try {
      // DistributorsModel distributor = await _local.fetchDistributor();
      // if (page == null) {
      //   final _prod = await _local.getFavourite();
      //   if (_prod.isNotEmpty) {
      //     return right(DashBoardResponse(
      //         currentPage: 0,
      //         banners: [],
      //         products: [],
      //         categories: [],
      //         offers: []));
      //   }
      // }

      final _ret = await _local.fetchRetailer();
      final response =
          await _remote.fetchFavourites(retId: _ret?.id, page: page);
      // await _local.deleteFav();
      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        // await _local.insertFav(response.products);
        return right(response);
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, ApiSuccessResponse>> deleteCart({
    required int orderId,
    required ProductModel prod,
    required int? ret,
  }) async {
    try {
      ApiSuccessResponse response = ApiSuccessResponse(message: "");
      final _ret = await _local.fetchRetailer();
      if (_ret != null) {
        await _local.deleteCartItem(retId: ret ?? _ret.id, prodId: prod.id);
        await _local.resetProdQuantity(prod.id);
        // await _local.deleteCart(model: prod, ret: ret!);
        // final _localOrderId =
        //     await _local.getSingleCart(product: prod, ret: _ret);

        //!TODO DELETE ALL
        response = await _remote.deleteCartSalesman(
            orderId: orderId, retId: ret ?? _ret.id, all: false);
      } else {
        response = await _remote.deleteCart(orderId: orderId, all: false);
      }
      if (response.error != null && response.error!.length > 0) {
        print("DELETE CART ERROR: ${response.error}");
        return left(response.error!);
      } else {
        // if (_ret != null) await _local.deleteAllCart();
        return right(response);
      }
    } catch (e) {
      if (e is SocketException) {
        final _ret = await _local.fetchRetailer();
        // if (_ret != null) await _local.deleteCart(model: prod, ret: ret!);
        return right(ApiSuccessResponse(message: "Deleted"));
      }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, CartQuantity>> getCartQuantity() async {
    try {
      final _ret = await _local.fetchRetailer();

      return right(await _remote.cartQuantity(retid: _ret?.id));
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        final _ret = await _local.fetchRetailer();

        if (_ret != null) {
          final _qty = await _local.countCart(_ret.id);
          return right(CartQuantity(quantity: _qty));
        }
        // final qty = await _local.countCart();
        // return right(CartQuantity(quantity: qty));
      }
      // returnFailure(e);
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      final _result = await _local.logOutUser();

      if (!_result) await _local.clearPrefs();
      await _remote.logout();
      _local
        // ..deleteArrivals()
        ..deleteBanners()
        ..deleteCategories()
        // ..deleteFav()
        ..deleteOffers()
        ..deleteProducts()
            .onError((error, stackTrace) => throw DatabaseExeption());
      return right("LoggedOuts");
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  //* also change retailer..reusing
  @override
  Future<Either<String, DistributorResponse>> changedistributor(
      {required int distId}) async {
    try {
      final dist = await _local.fetchDistributor();
      final ret = await _local.fetchRetailer();

      DistributorResponse response =
          DistributorResponse(singleDist: null, distributors: []);

      if (dist != null) {
        response = await _remote.changeDistributor(distId: distId);
        if (response.error != null && response.error!.length > 0) {
          return left(response.error!);
        } else {
          await _local.saveFirstDistributor(response.singleDist!);
          // return right(response);
        }
      }
      if (ret != null) {
        response = await _remote.changeRetailer(retId: distId);
        if (response.error != null && response.error!.length > 0) {
          return left(response.error!);
        } else {
          await _local.saveRetailer(response.singleRet!);
          // return right(response);
        }
      }
      return right(response);
    } catch (e) {
      if (e is SocketException) {
        final ret = await _local.fetchRetailer();

        if (ret != null) {
          final _single = await _local.getSingleRetaile(distId);
          if (_single != null) {
            await _local.saveRetailer(_single);
            return right(DistributorResponse(
                singleDist: null, distributors: [], singleRet: _single));
          }
        }
      }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DistributorResponse>> fetchistributor(
      {required String? query}) async {
    try {
      DistributorResponse response = DistributorResponse(
        singleDist: null,
        distributors: null,
      );
      final dist = await _local.fetchDistributor();
      final ret = await _local.fetchRetailer();

      if (dist != null) response = await _remote.fetchDistributor(query: query);
      if (ret != null) response = await _remote.fetchRetailer(query: query);

      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      // await _local.saveFirstDistributor(response.singleDist!);
      if (ret != null)
        await _local.insertRetailers(retailers: response.retailers ?? []);
      return right(response);
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        final _ret = await _local.fetchRetailer();
        if (_ret != null) {
          final _data = await _local.getRetailers(query);
          if (_data.isNotEmpty) {
            return right(DistributorResponse(
              singleDist: null,
              distributors: null,
              retailers: _data,
            ));
          }
        }
      }
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DistributorResponse>> fetchCurrentDistributor() async {
    try {
      DistributorsModel? distributor = await _local.fetchDistributor();
      RetailerModel? retailer = await _local.fetchRetailer();

      return right(DistributorResponse(
        singleDist: distributor,
        distributors: [],
        singleRet: retailer,
      ));
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> searchProducts({
    required String query,
    required int? maxPrice,
    required int? minPrice,
    required bool isNewArrival,
    required int? catId,
  }) async {
    try {
      DistributorsModel? _dist = await _local.fetchDistributor();
      RetailerModel? _ret = await _local.fetchRetailer();

      final response = await _remote.searchProduct(
        distId: _dist?.id,
        retId: _ret?.id,
        query: query,
        isNewArrival: isNewArrival,
        maxPrice: maxPrice,
        catId: catId,
        minPrice: minPrice,
      );

      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      if (_ret != null) await _local.insertProd(response.products);

      return right(response);
    } catch (e) {
      if (e is SocketException) {
        RetailerModel? _ret = await _local.fetchRetailer();
        if (_ret != null) {
          final prod = await _local.searchProduct(query: query);
          if (prod.isNotEmpty) {
            return right(DashBoardResponse(
                banners: [], products: prod, categories: [], offers: []));
          }
          return left("record not found");
        }
      }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, OrderHistoryResponse>> fetchOrderHistory(
      {required int? page}) async {
    try {
      // DistributorsModel distributor = await _local.fetchDistributor();
      OrderHistoryResponse response = OrderHistoryResponse(retailOrders: []);
      final _ret = await _local.fetchRetailer();
      // if (_ret != null) {
      //   response = await _remote.fetchOrderHistorySalesman(retId: _ret.id);
      // } else {
      response = await _remote.fetchOrderHistory(page: page, retId: _ret?.id);
      // }

      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        return right(response);
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, String>> deleteOrder({required int orderId}) async {
    try {
      ApiSuccessResponse response = await _remote.deleteOrder(orderId: orderId);
      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        return right(response.message ?? "order deleted");
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, SingleProductResponse>> getSingleProduct(
      {required int prodId}) async {
    try {
      final _dis = await _local.fetchDistributor();
      final _ret = await _local.fetchRetailer();
      SingleProductResponse response =
          SingleProductResponse(product: null, related: []);
      final _prod = await _local.getSingleProduct(prodId);
      if (_prod != null)
        return right(SingleProductResponse(product: _prod, related: []));
      if (_ret != null) {
        response = await _remote.fetchSingleProductSalesman(
            prodId: prodId, retId: _ret.id);
      }
      if (_dis != null) {
        response = await _remote.fetchSingleProduct(
            prodId: prodId, distributorId: _dis.id);
      }

      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        return right(response);
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, NotificationResponse>> fetchNotifictains() async {
    try {
      final response = await _remote.getNotifications();
      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        return right(response);
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, OfferRespose>> fetchSingleOffer(
      {required int offerId}) async {
    try {
      final response = await _remote.fetchSingleOffer(offerId: offerId);
      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        return right(response);
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, String>> changePassword(
      {required String oldPass, required String newPass}) async {
    try {
      final response =
          await _remote.changePassword(oldPass: oldPass, newPass: newPass);
      if (response.error != null && response.error!.length > 0)
        return left(response.error!);
      return right(response.success ?? "Success");
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, ProfileResponse>> fetchProfile() async {
    try {
      final response = await _remote.fetchProfile();
      if (response.error != null && response.error!.length > 0)
        return left(response.error!);
      return right(response);
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, String>> confirmDelivery({required int orderId}) async {
    try {
      ApiSuccessResponse response =
          await _remote.confirmDelivery(orderId: orderId);
      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        return right(response.message ?? "order deleted");
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, bool>> checkAuthUser() async {
    try {
      return right(await _local.checkAuthenticatedUser());
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> fetchPaginatedProduct({
    required int? page,
    required int? maxPrice,
    required int? minPrice,
    required bool isNewArrival,
    required int? catId,
  }) async {
    try {
      final _dis = await _local.fetchDistributor();
      final _ret = await _local.fetchRetailer();
      DashBoardResponse _response = DashBoardResponse(
        banners: [],
        products: [],
        categories: [],
        offers: [],
      );

      if (_ret != null) {
        _response = await _remote.fetchPaginatedProduct(
          retId: _ret.id,
          distributorId: _dis?.id ?? 0,
          page: page,
          maxPrice: maxPrice,
          minPrice: minPrice,
          catId: catId,
          isNewArrival: isNewArrival,
        );
      }
      if (_dis != null) {
        _response = await _remote.fetchPaginatedProduct(
          distributorId: _dis.id,
          page: page,
          maxPrice: maxPrice,
          minPrice: minPrice,
          catId: catId,
          isNewArrival: isNewArrival,
        );
      }

      if (_response.error != null && _response.error!.length > 0)
        return left(_response.error!);

      if (_dis != null) return right(_response);

      if (_ret != null) await _local.insertProd(_response.products);

      // final _prod = await _local.getProducts(page: page);
      // if (_prod.isNotEmpty) {
      //   final _row = await _local.productCount();
      //   print("PRODUCT_COUNT: $_row");
      //   return right(
      //     DashBoardResponse(
      //       currentPage: page,
      //       lastPage: (_row / 20).ceil(),
      //       banners: [],
      //       products: _prod,
      //       categories: [],
      //       offers: [],FlatList
      //     ),
      //   );
      // }
      return right(_response);
    } catch (e) {
      print(e.toString());
      if (e is SocketException) {
        final _ret = await _local.fetchRetailer();
        if (_ret != null) {
          final _prod = await _local.getProducts(page: page);
          if (_prod.isNotEmpty) {
            final _row = await _local.productCount();
            print("PRODUCT_COUNT: $_row");
            return right(
              DashBoardResponse(
                currentPage: page,
                lastPage: (_row / 20).ceil(),
                banners: [],
                products: _prod,
                categories: [],
                offers: [],
              ),
            );
          }
        }
      }

      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, String>> getPriceLevel(
      {required int prodId, required int qty}) async {
    try {
      final _ret = await _local.fetchRetailer();
      if (_ret != null) {
        return right(await _remote.getSalemsanPriceLevel(
          prodId: prodId,
          qty: qty,
          retId: _ret.id,
        ));
      }
      return right(await _remote.getPriceLevel(prodId: prodId, qty: qty));
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, String>> forgotPassword({required String email}) async {
    try {
      final _resp = await _remote.forgotPassword(email: email);
      if (_resp.error != null && _resp.error!.length > 0) {
        return left(_resp.error!);
      } else {
        return right(_resp.message ?? "order deleted");
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, OrderHistoryResponse>> filterOrders({
    required int? distId,
    required String? status,
    required int? timeStampFrom,
    required int? timeStampTo,
  }) async {
    try {
      // DistributorsModel distributor = await _local.fetchDistributor();
      final response = await _remote.filterOrdes(
        distId: distId,
        status: status,
        retId: distId,
        timeStampFrom: timeStampFrom,
        timeStampTo: timeStampTo,
      );

      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        return right(response);
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DistributorResponse>> searchRetailer(
      {required String query}) async {
    try {
      final response = await _remote.searchRetailer(query: query);
      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        // await _local.saveFirstDistributor(response.singleDist!);
        return right(response);
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, String>> reorder({required int orderId}) async {
    try {
      ApiSuccessResponse response = await _remote.reorder(orderId: orderId);
      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        return right(response.message ?? "order deleted");
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> getSingleCategory(
      {required int categoryId}) async {
    try {
      final response = await _remote.getSingleCategory(categoryId: categoryId);

      if (response.error != null && response.error!.length > 0)
        return left(response.error!);
      // await _offersLocal.insertToOffers(response.offers);
      final _cat = await _local.getSingleCategory(categoryId);
      if (_cat != null) {
        final _subCats = await _local.getSubCategory(id: _cat.subCateqory);
        return right(DashBoardResponse(
          banners: [],
          products: [],
          categories: _subCats,
          offers: [],
          category: _cat,
        ));
      }
      return right(response);
    } catch (e) {
      if (e is SocketException) {
        final _cat = await _local.getSingleCategory(categoryId);
        if (_cat != null) {
          final _subCats = await _local.getSubCategory(id: _cat.subCateqory);
          return right(DashBoardResponse(
            banners: [],
            products: [],
            categories: _subCats,
            offers: [],
            category: _cat,
          ));
        }
      }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> getNewArrivals(int? page) async {
    try {
      final _dis = await _local.fetchDistributor();
      final _ret = await _local.fetchRetailer();
      DashBoardResponse response = DashBoardResponse(
          banners: [], products: [], categories: [], offers: []);
      if (_ret != null) {
        response =
            await _remote.getNewArrivals(retId: _ret.id, page: page ?? 1);
      }
      if (_dis != null) {
        //*RetailerId is DIstribuor_id
        response =
            await _remote.getNewArrivals(page: page ?? 1, retId: _dis.id);
      }

      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      if (_dis != null) return right(response);

      await _local.insertProd(response.products);
      // await _offersLocal.insertToOffers(response.offers);

      return right(response);
    } catch (e) {
      if (e is SocketException) {
        final _arr = await _local.getNewArrival(page: page);
        final _lastPage = await _local.getNewArrivalsCount();
        print("ARRIVALS: $_lastPage");
        if (_arr.isNotEmpty) {
          return right(DashBoardResponse(
            banners: [],
            products: _arr,
            categories: [],
            offers: [],
            currentPage: page,
            lastPage: (_lastPage / 20).ceil(),
          ));
        }
      }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> getBanners(int? page) async {
    try {
      // await _local.deleteBanners();
      final _dis = await _local.fetchDistributor();
      final _ret = await _local.fetchRetailer();
      DashBoardResponse response = DashBoardResponse(
          banners: [], products: [], categories: [], offers: []);
      if (_ret != null) {
        response = await _remote.getBanners();
      }
      if (_dis != null) {
        response = await _remote.getBanners(distId: _dis.id);
      }

      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      if (_dis != null) return right(response);

      await _local.insertBanners(response.banners);

      final _bann = await _local.getBanners();
      if (_bann.isNotEmpty) {
        return right(DashBoardResponse(
            banners: _bann, products: [], categories: [], offers: []));
      }
      // await _offersLocal.insertToOffers(response.offers);

      return right(response);
    } catch (e) {
      if (e is SocketException) {
        final _bann = await _local.getBanners();
        if (_bann.isNotEmpty) {
          return right(DashBoardResponse(
              banners: _bann, products: [], categories: [], offers: []));
        }
      }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> getOffers(int? page) async {
    try {
      // await _local.deleteOffers();
      final _dis = await _local.fetchDistributor();
      final _ret = await _local.fetchRetailer();
      DashBoardResponse response = DashBoardResponse(
          banners: [], products: [], categories: [], offers: []);
      if (_ret != null) {
        response = await _remote.getOffers();
      }
      if (_dis != null) {
        response = await _remote.getOffers(distId: _dis.id);
      }

      if (response.error != null && response.error!.length > 0)
        return left(response.error!);
      if (_dis != null) return right(response);

      // if (_ret != null) {
      //   await _local.deleteOffers();
      //   await _local.insertOffers(response.offers);
      // }

      return right(response);
    } catch (e) {
      // if (e is SocketException) {
      //   final _offer = await _local.getOffers();
      //   if (_offer.isNotEmpty) {
      //     return right(DashBoardResponse(
      //         banners: [], products: [], categories: [], offers: _offer));
      //   }
      // }
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, String>> getDescription({required int prodId}) async {
    try {
      return right(await _remote.getProductDescription(prodId: prodId));
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> getRelated(
      {required int prodId}) async {
    try {
      final _ret = await _local.fetchRetailer();
      final response =
          await _remote.getRelated(prodId: prodId, retId: _ret?.id);

      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      return right(response);
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, SlabsResponse>> getSlabs({required int prodId}) async {
    try {
      final _ret = await _local.fetchRetailer();
      final response = await _remote.getSlabs(prodId: prodId, retId: _ret?.id);

      if (response.error != null && response.error!.length > 0) {
        return left(response.error!);
      } else {
        return right(response);
      }
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> initializeProduct(int? page) async {
    try {
      final _ret = await _local.fetchRetailer();
      if (_ret == null)
        return right(DashBoardResponse(
            banners: [], products: [], categories: [], offers: []));
      // await _local.deleteProducts();

      final response = await _remote.initializeProduct(page);
      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      await _local.insertProd(response.products);
      return right(response);
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> fetchTopProducts() async {
    try {
      final _dis = await _local.fetchDistributor();
      final response = await _remote.fetchTopProducts(distributorId: _dis?.id);
      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      return right(response);
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, DashBoardResponse>> fetchRecentlyBought() async {
    try {
      final _ret = await _local.fetchRetailer();
      final _dis = await _local.fetchDistributor();
      final response = await _remote.fetchRecentBought(
          distributorId: _dis?.id, retId: _ret?.id);

      if (response.error != null && response.error!.length > 0)
        return left(response.error!);

      return right(response);
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }

  @override
  Future<Either<String, TransportResponse>> fetchTransport(int retId) async {
    try {
      final response = await _remote.fetchTransport(retId);
      if (response.errors != null && response.errors!.length > 0)
        return left(response.errors!);

      return right(response);
    } catch (e) {
      print(e.toString());
      return left(returnFailure(e));
    }
  }
}
