import 'dart:convert';

import 'package:biz_mobile_app/features/domain/models/Cart/CartModel.dart';
import 'package:biz_mobile_app/features/domain/models/Cart/salesman_cart_model.dart';
import 'package:biz_mobile_app/features/domain/models/Order/OrderModel.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:biz_mobile_app/database/app_database.dart';
import 'package:biz_mobile_app/database/banners/banner_dao.dart';
import 'package:biz_mobile_app/database/cart/cart_dao.dart';
import 'package:biz_mobile_app/database/cart/retail_salesman_dao.dart';
import 'package:biz_mobile_app/database/categories/category_dao.dart';
import 'package:biz_mobile_app/database/offer/offer_dao.dart';
import 'package:biz_mobile_app/database/products/product_dao.dart';
import 'package:biz_mobile_app/database/retailer/retailer_dao.dart';
import 'package:biz_mobile_app/features/domain/models/Category/CategoryModel.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/models/SalesMan/SalesManModel.dart';
import 'package:biz_mobile_app/features/domain/models/banners/BannerModel.dart';
import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';

import '../../../../core/errors/exeptions.dart';
import '../../../../core/utils/constants.dart';
import '../../../domain/models/retailers/RetailerModel.dart';
import '../../../domain/models/token_model.dart';

abstract class LocalDataSource {
  Future<void> cacheToken({required TokenModel model});
  Future<TokenModel>? getToken();
  Future<void> clearPrefs();
  Future<bool> logOutUser();
  Future<bool> checkFirstTime();
  Future<bool> checkAuthenticatedUser();
  Future<RetailerModel> getUser();
  Future<void> saveuser(RetailerModel retailer);
  Future<void> saveSalesman(SalesManModel retailer);
  Future<void> saveFirstTime();
  Future<void> saveFirstDistributor(DistributorsModel distributors);
  Future<void> saveRetailer(RetailerModel retailerModel);
  Future<DistributorsModel>? fetchDistributor();
  Future<RetailerModel>? fetchRetailer();
  Future<void> saveSalesmanDistributor(DistributorsModel distributors);
  Future<DistributorsModel>? getSalesmanDistributor();

  //*Producst
  Future insertProd(List<ProductModel> product);
  Future<List<ProductModel>> getProducts({required int? page});
  Future<List<ProductModel>> getFavourite();
  Future<ProductModel?> getSingleProduct(int id);
  Future deleteProducts();
  Future updateProdQuantity({required int qty, required int id});
  Future resetProdQuantity(int id);
  Future<int> productCount();
  Future<List<ProductModel>> getNewArrival({required int? page});
  Future<int> getNewArrivalsCount();
  Future<List<ProductModel>> getByCat({required int? page, required catId});
  Future<int> getByCatCount({required int catId});
  Future<List<ProductModel>> searchProduct({required String? query});

  //*Arrivals
  // Future insertArr(List<ProductModel> product);
  // Future<List<ProductModel>> getArrivals();
  // Future deleteArrivals();
  // Future updateArrQuantity({required int qty, required int id});

  //*BAnners
  Future insertBanners(List<BannerModel> banner);
  Future<List<BannerModel>> getBanners();
  Future deleteBanners();

  //*categories
  Future insertCategories(List<CategoryModel> banner);
  Future<List<CategoryModel>> getCategories({required int? page});
  Future<int> countCats();
  Future deleteCategories();
  Future<CategoryModel?> getSingleCategory(int id);
  Future<List<CategoryModel>> getSubCategory({required List<int> id});

  //*Offers
  Future insertOffers(List<OfferModel> offer);
  Future<List<OfferModel>> getOffers();
  Future deleteOffers();

  //*cart
  Future insertCart({
    required List<InsertCartObject> cart,
    required RetailerSalesModel ret,
  });
  Future<List<SalesManCartModel>> getCart();
  Future<int?> fetchCartQty({required retId, required ProductModel prod});
  // Future<List<OrderModel>> getCart();
  // Future deleteCart({required ProductModel model, required RetailerModel ret});
  // Future<int> countCart();
  // Future<int?> getSingleCart({
  //   required ProductModel product,
  //   required RetailerModel ret,
  // });

  Future<int> countCart(int id);

  Future deleteCartItem({required int retId, required int prodId});

  Future deleteCartWhereRet(int id);
  Future deleteAllCart();

  //*retailer
  Future insertRetailers({required List<RetailerModel> retailers});
  Future<List<RetailerModel>> getRetailers(String? query);
  Future deleteAllRetailers();
  Future<RetailerModel?> getSingleRetaile(int id);
}

//fetchind data from local database
@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences _prefs;
  final BannerDao _bannerDao;
  final CategoryDao _categoryDao;
  final OfferDao _offerDao;
  final ProductDao _productDao;
  final CartDao _cartDao;
  final RetailerDao _retDao;
  final RetailSalesmanDao _retSalseDao;

  LocalDataSourceImpl(
    this._prefs,
    this._bannerDao,
    this._categoryDao,
    this._offerDao,
    this._productDao,
    this._cartDao,
    this._retDao,
    this._retSalseDao,
  );

  ///check if its device first time
  @override
  Future<bool> checkFirstTime() {
    try {
      final checFirstTime = _prefs.get(CHECK_FIRST_TIME);
      if (checFirstTime != null) {
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  //save on first time open app
  @override
  Future<void> saveFirstTime() {
    try {
      return _prefs.setString(CHECK_FIRST_TIME, 'checked in');
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveuser(RetailerModel retailer) {
    try {
      return _prefs.setString(SAVE_USER, json.encode(retailer.toJson()));
    } catch (e) {
      throw CacheException();
    }
  }

  //get the logged in user
  @override
  Future<RetailerModel> getUser() {
    try {
      if (_prefs.getString(SAVE_USER) != null) {
        String user = _prefs.getString(SAVE_USER)!;
        try {
          return Future.value(RetailerModel.fromJson(json.decode(user)));
        } catch (e) {
          throw UnAuthenticatedException();
        }
      } else {
        throw UnAuthenticatedException();
      }
    } catch (e) {
      throw CacheException();
    }
  }

  //logout  use
  @override
  Future<bool> logOutUser() async {
    try {
      await _prefs.remove(SAVE_USER);
      await _prefs.remove(SAVE_DISTRIBUTOR);
      await _prefs.remove(SAVE_RETAILER);
      await _prefs.remove(SAVE_SALESMAN_DISTRIBUTOR);
      return await _prefs.remove(ACCESS_TOKEN);
    } catch (e) {
      throw CacheException();
    }
  }

  //clear preferences
  @override
  Future<void> clearPrefs() {
    try {
      return _prefs.clear();
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  //cache the access tokem
  @override
  Future<void> cacheToken({required model}) {
    try {
      return _prefs.setString(ACCESS_TOKEN, jsonEncode(model.toJson()));
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  //get the acces token
  @override
  Future<TokenModel>? getToken() {
    try {
      String? token = _prefs.getString(ACCESS_TOKEN);
      if (token != null) {
        return Future.value(TokenModel.fromJson(json.decode(token)));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<bool> checkAuthenticatedUser() {
    try {
      final checkLogin = _prefs.get(ACCESS_TOKEN);
      if (checkLogin != null) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<void> saveFirstDistributor(DistributorsModel distributors) {
    try {
      return _prefs.setString(
          SAVE_DISTRIBUTOR, jsonEncode(distributors.toJson()));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<DistributorsModel>? fetchDistributor() {
    try {
      String? dist = _prefs.getString(SAVE_DISTRIBUTOR);
      if (dist != null) {
        return Future.value(DistributorsModel.fromJson(json.decode(dist)));
      } else {
        return null;
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveRetailer(RetailerModel retailerModel) {
    try {
      return _prefs.setString(
          SAVE_RETAILER, jsonEncode(retailerModel.toJson()));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<RetailerModel>? fetchRetailer() {
    try {
      String? dist = _prefs.getString(SAVE_RETAILER);
      if (dist != null) {
        return Future.value(RetailerModel.fromJson(json.decode(dist)));
      } else {
        return null;
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveSalesman(SalesManModel retailer) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveSalesmanDistributor(DistributorsModel distributors) {
    try {
      return _prefs.setString(
          SAVE_SALESMAN_DISTRIBUTOR, jsonEncode(distributors.toJson()));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<DistributorsModel>? getSalesmanDistributor() {
    try {
      String? dist = _prefs.getString(SAVE_SALESMAN_DISTRIBUTOR);
      if (dist != null) {
        return Future.value(DistributorsModel.fromJson(json.decode(dist)));
      } else {
        return null;
      }
    } catch (e) {
      throw CacheException();
    }
  }

//!PRODUCTS
  @override
  Future insertProd(List<ProductModel> product) async {
    try {
      product.forEach((e) async {
        await _productDao.insertProducts(ProductDataClass(
          id: e.id,
          product_images: e.product_images,
          colors: e.colors,
          category: e.category,
          isNewArrivals: e.isNewArrivals,
          units: e.units,
          name: e.name,
          price_currency: e.price_currency,
          price: e.price,
          stock_qty: e.stock_qty,
          size: e.size,
          brand: e.brand,
          price_s: e.price_s,
          isFavourite: e.isFavourite,
          cartQty: e.cartQty,
          briefDescription: e.briefDescription,
        ));
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getProducts({required int? page}) async {
    try {
      final _data = await _productDao.getProducts(page: page);
      return _data
          .map((e) => ProductModel(
              id: e.id,
              category: e.category,
              isNewArrivals: e.isNewArrivals,
              product_images: e.product_images,
              colors: e.colors,
              units: e.units,
              name: e.name,
              price_currency: e.price_currency,
              price: e.price,
              stock_qty: e.stock_qty,
              size: e.size,
              brand: e.brand,
              price_s: e.price_s,
              isFavourite: e.isFavourite,
              cartQty: e.cartQty,
              briefDescription: e.briefDescription,
              slabs: []))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<int> productCount() async {
    try {
      return await _productDao.countEntries().getSingle();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<ProductModel?> getSingleProduct(int id) async {
    try {
      final e = await _productDao.getSingleProd(id);
      if (e == null) return null;
      return ProductModel(
          id: e.id,
          product_images: e.product_images,
          colors: e.colors,
          units: e.units,
          name: e.name,
          price_currency: e.price_currency,
          price: e.price,
          stock_qty: e.stock_qty,
          size: e.size,
          category: e.category,
          isNewArrivals: e.isNewArrivals,
          brand: e.brand,
          price_s: e.price_s,
          isFavourite: e.isFavourite,
          cartQty: e.cartQty,
          briefDescription: e.briefDescription,
          slabs: []);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future updateProdQuantity({required int qty, required int id}) async {
    try {
      await _productDao.updateProdQuantity(qty: qty, id: id);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getFavourite() async {
    try {
      final _data = await _productDao.getFavourites(page: null);
      return _data
          .map((e) => ProductModel(
              id: e.id,
              category: e.category,
              isNewArrivals: e.isNewArrivals,
              product_images: e.product_images,
              colors: e.colors,
              units: e.units,
              name: e.name,
              price_currency: e.price_currency,
              price: e.price,
              stock_qty: e.stock_qty,
              size: e.size,
              brand: e.brand,
              price_s: e.price_s,
              isFavourite: e.isFavourite,
              cartQty: e.cartQty,
              briefDescription: e.briefDescription,
              slabs: []))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getNewArrival({required int? page}) async {
    try {
      final _data = await _productDao.getNewArrivals(page: page);
      return _data
          .map((e) => ProductModel(
              id: e.id,
              category: e.category,
              isNewArrivals: e.isNewArrivals,
              product_images: e.product_images,
              colors: e.colors,
              units: e.units,
              name: e.name,
              price_currency: e.price_currency,
              price: e.price,
              stock_qty: e.stock_qty,
              size: e.size,
              brand: e.brand,
              price_s: e.price_s,
              isFavourite: e.isFavourite,
              cartQty: e.cartQty,
              briefDescription: e.briefDescription,
              slabs: []))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getByCat(
      {required int? page, required catId}) async {
    try {
      final _data = await _productDao.getByCategory(page: page, catId: catId);
      return _data
          .map((e) => ProductModel(
              id: e.id,
              category: e.category,
              isNewArrivals: e.isNewArrivals,
              product_images: e.product_images,
              colors: e.colors,
              units: e.units,
              name: e.name,
              price_currency: e.price_currency,
              price: e.price,
              stock_qty: e.stock_qty,
              size: e.size,
              brand: e.brand,
              price_s: e.price_s,
              isFavourite: e.isFavourite,
              cartQty: e.cartQty,
              briefDescription: e.briefDescription,
              slabs: []))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> searchProduct({required String? query}) async {
    try {
      final _data = await _productDao.searchProducts(query: query);
      return _data
          .map((e) => ProductModel(
              id: e.id,
              category: e.category,
              isNewArrivals: e.isNewArrivals,
              product_images: e.product_images,
              colors: e.colors,
              units: e.units,
              name: e.name,
              price_currency: e.price_currency,
              price: e.price,
              stock_qty: e.stock_qty,
              size: e.size,
              brand: e.brand,
              price_s: e.price_s,
              isFavourite: e.isFavourite,
              cartQty: e.cartQty,
              briefDescription: e.briefDescription,
              slabs: []))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<int> getNewArrivalsCount() async {
    try {
      return _productDao.countArrivals().then((value) {
        print("COUNT ARRIVALS");
        return value;
      }).onError((error, stackTrace) {
        print("ERROR COUNT NEW: $error,$stackTrace");
        throw DatabaseExeption();
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future deleteProducts() async {
    try {
      await _productDao.deleteAll();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

//!BANNERS
  @override
  Future deleteBanners() async {
    try {
      await _bannerDao.deleteAll();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final _data = await _bannerDao.getBanners();
      return _data
          .map((e) => BannerModel(
                status: e.status,
                id: e.id,
                name: e.name,
                text: e.bannerText,
                pic: e.pic,
              ))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future insertBanners(List<BannerModel> banner) async {
    try {
      banner.forEach((e) async {
        await _bannerDao.insertBanners(BannerDataClass(
          status: e.status,
          id: e.id,
          name: e.name,
          bannerText: e.text,
          pic: e.pic,
        ));
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future deleteCategories() async {
    try {
      await _categoryDao.deleteAll();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategories({required int? page}) async {
    try {
      final _data = await _categoryDao.getCats(page: page);
      return _data
          .map((e) => CategoryModel(
                id: e.id,
                name: e.name,
                category_pic: e.category_pic,
                productcount: e.productcount,
                subCateqory: e.subCategory ?? [],
                parent_category: e.parent_category,
              ))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<CategoryModel?> getSingleCategory(int id) async {
    try {
      final e = await _categoryDao.getSingleCat(id);
      if (e != null)
        return CategoryModel(
          id: e.id,
          name: e.name,
          category_pic: e.category_pic,
          productcount: e.productcount,
          subCateqory: e.subCategory ?? [],
          parent_category: e.parent_category,
        );
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getSubCategory({required List<int> id}) async {
    List<CategoryModel> _cat = [];
    id.forEach((element) async {
      final e = await _categoryDao.getSingleCat(element);
      if (e != null)
        _cat.add(CategoryModel(
          id: e.id,
          name: e.name,
          category_pic: e.category_pic,
          productcount: e.productcount,
          subCateqory: e.subCategory ?? [],
          parent_category: e.parent_category,
        ));
    });

    return Future.value(_cat);
  }

  @override
  Future insertCategories(List<CategoryModel> banner) async {
    try {
      banner.forEach((e) async {
        await _categoryDao.insertCats(CategoryDataClass(
          id: e.id,
          name: e.name,
          subCategory: e.subCateqory,
          category_pic: e.category_pic,
          productcount: e.productcount,
          parent_category: e.parent_category,
        ));
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future deleteOffers() async {
    try {
      await _offerDao.deleteAll();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<OfferModel>> getOffers() async {
    try {
      final _data = await _offerDao.getOffers();
      return _data
          .map((e) => OfferModel(
                id: e.id,
                xItem: e.xItem,
                yItem: e.yItem,
                name: e.name,
                scheme: e.scheme,
                xAmt: e.xAmt,
                yAmt: e.yAmt,
                dateFrom: e.dateFrom,
                dateTo: e.dateTo,
                pic: e.pic,
                detailName: e.detailName,
              ))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future insertOffers(List<OfferModel> offer) async {
    try {
      offer.forEach((e) async {
        await _offerDao.insert(OfferDataClass(
          id: e.id,
          xItem: e.xItem,
          yItem: e.yItem,
          name: e.name,
          scheme: e.scheme,
          xAmt: e.xAmt,
          yAmt: e.yAmt,
          dateFrom: e.dateFrom,
          dateTo: e.dateTo,
          pic: e.pic,
          detailName: e.detailName,
        ));
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<int> getByCatCount({required int catId}) {
    return _productDao
        .countByCategory(catId: catId)
        .then((value) => value)
        .onError((error, stackTrace) => throw DatabaseExeption());
  }

  @override
  Future<int> countCats() {
    return _categoryDao
        .countCats()
        .then((value) => value)
        .onError((error, stackTrace) => throw DatabaseExeption());
  }

  @override
  Future insertRetailers({required List<RetailerModel> retailers}) async {
    try {
      retailers.forEach((e) async {
        await _retDao.insertRetailer(RetailerDataClass(
          id: e.id,
          pinNo: e.pinNo,
          name: e.name,
          phone: e.phone,
          email: e.email,
          pic: e.pic,
          distributors: e.distributors,
        ));
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<RetailerModel>> getRetailers(String? query) async {
    try {
      final _data = await _retDao.getRetailers(query);
      return _data
          .map((e) => RetailerModel(
                id: e.id,
                pinNo: e.pinNo,
                name: e.name,
                phone: e.phone,
                email: e.email,
                pic: e.pic,
                distributors: e.distributors,
              ))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future deleteAllRetailers() async {
    try {
      await _retDao.deleteAll();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<RetailerModel?> getSingleRetaile(int id) async {
    try {
      final e = await _retDao.getSingleRetaile(id);
      if (e != null)
        return RetailerModel(
          id: e.id,
          pinNo: e.pinNo,
          name: e.name,
          phone: e.phone,
          email: e.email,
          pic: e.pic,
          distributors: e.distributors,
        );
    } catch (e) {
      print(e.toString());
      throw DatabaseExeption();
    }
  }

  @override
  Future insertCart(
      {required RetailerSalesModel ret,
      required List<InsertCartObject> cart}) async {
    try {
      await _retSalseDao
          .insertRetailSales(RetailSalesman(id: ret.id, name: ret.name));
      // await _cartDao.addToCart(retId: ret.id, prod: product, cartQty: cartQty);
      cart.forEach((cart) async {
        await _cartDao.addToCart(
            retId: ret.id, prod: cart.product, cartQty: cart.cartQty);
      });
    } catch (e) {
      print(e.toString());
      throw DatabaseExeption();
    }
  }

  @override
  Future<List<SalesManCartModel>> getCart() async {
    try {
      final _data = await _retSalseDao.getOfflineCart();
      // List<OrderModel> _orders = const [];
      return _data.map((e) {
        final _orders = e.cart
            .map(
              (cart) => OrderModel.fromOffline(
                  product: cart.product,
                  qty: cart.cartQty,
                  retName: e.retailSalesman.name),
            )
            .toList();

        if (_orders.isEmpty) {
          _retSalseDao
              .delereWhere(e.retailSalesman.id)
              .then((value) => print("DELeted"));
        }

        return SalesManCartModel(
            retailer: RetailerSalesModel(
              id: e.retailSalesman.id,
              name: e.retailSalesman.name,
            ),
            cart: CartModel.fromOffline(_orders));
      }).toList();

      // if (_orders.isEmpty) return const [];

      // return _model;
    } catch (e) {
      print(e.toString());
      throw DatabaseExeption();
    }
  }

  @override
  Future<int?> fetchCartQty(
      {required retId, required ProductModel prod}) async {
    try {
      return await (_cartDao.fetchCartQty(retId: retId, prod: prod));
    } catch (e) {
      print(e.toString());
      throw DatabaseExeption();
    }
  }

  @override
  Future deleteAllCart() async {
    try {
      await _retSalseDao.delereAllCart();
      await _retSalseDao.deleteAll();
    } catch (e) {
      print(e.toString());
      throw DatabaseExeption();
    }
  }

  @override
  Future deleteCartWhereRet(int id) async {
    try {
      await _retSalseDao.deleteCartWhere(id);
      await _retSalseDao.delereWhere(id);
    } catch (e) {
      print(e.toString());
      throw DatabaseExeption();
    }
  }

  @override
  Future deleteCartItem({required int retId, required int prodId}) async {
    try {
      await _retSalseDao.deleteCartItem(retId: retId, prodId: prodId);
    } catch (e) {
      print(e.toString());
      throw DatabaseExeption();
    }
  }

  @override
  Future<int> countCart(int id) async {
    try {
      // ignore: unused_local_variable
      final _all = await _retSalseDao.countAllCart();
      final _perRet = await _retSalseDao.countCart(id);
      return _perRet;
    } catch (e) {
      print(e.toString());
      throw DatabaseExeption();
    }
  }

  @override
  Future resetProdQuantity(int id) async {
    try {
      await _productDao.resetProdQuantity(id);
    } catch (e) {
      print(e.toString());
      throw DatabaseExeption();
    }
  }
}

class InsertCartObject {
  final int cartQty;
  final ProductModel product;
  InsertCartObject({
    required this.cartQty,
    required this.product,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InsertCartObject &&
        other.cartQty == cartQty &&
        other.product == product;
  }

  @override
  int get hashCode => cartQty.hashCode ^ product.hashCode;

  @override
  String toString() => 'InsertCartObject(cartQty: $cartQty, product: $product)';
}
