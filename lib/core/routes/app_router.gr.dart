// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../../features/domain/models/Category/CategoryModel.dart' as _i25;
import '../../features/domain/models/distributors/about_model.dart' as _i28;
import '../../features/domain/models/offers/offer_model.dart' as _i26;
import '../../features/domain/models/ProductImages/ProductImagesModel.dart'
    as _i29;
import '../../features/domain/models/RetailOrder/retail_order_model.dart'
    as _i27;
import '../../features/presentation/screens/about_us_page.dart' as _i19;
import '../../features/presentation/screens/all_categories.dart' as _i10;
import '../../features/presentation/screens/all_offers.dart' as _i11;
import '../../features/presentation/screens/categories_screen.dart' as _i17;
import '../../features/presentation/screens/distributors.dart' as _i18;
import '../../features/presentation/screens/home/home_page.dart' as _i20;
import '../../features/presentation/screens/initialize/initialize_screen.dart'
    as _i6;
import '../../features/presentation/screens/login.dart' as _i5;
import '../../features/presentation/screens/more_products.dart' as _i16;
import '../../features/presentation/screens/new_arrivals.dart' as _i21;
import '../../features/presentation/screens/notifications.dart' as _i9;
import '../../features/presentation/screens/offer_detail_screen.dart' as _i12;
import '../../features/presentation/screens/order_history.dart' as _i13;
import '../../features/presentation/screens/order_history_details.dart' as _i14;
import '../../features/presentation/screens/product_details/components/picture_screen.dart'
    as _i22;
import '../../features/presentation/screens/product_details/details_screen.dart'
    as _i7;
import '../../features/presentation/screens/product_details/see_more_details.dart'
    as _i23;
import '../../features/presentation/screens/profile.dart' as _i15;
import '../../features/presentation/screens/search.dart' as _i8;
import '../../features/presentation/screens/splash.dart' as _i3;
import '../../features/presentation/screens/uknown_page.dart' as _i24;
import '../../features/presentation/screens/walkthrough.dart' as _i4;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i3.SplashScreen();
        }),
    IntroPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i4.IntroPage();
        }),
    LoginPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i5.LoginPage();
        }),
    InitializePageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i6.InitializePage();
        }),
    ProductDetailsScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<ProductDetailsScreenRouteArgs>();
          return _i7.ProductDetailsScreen(
              key: args.key, detailsArguments: args.detailsArguments);
        }),
    SearchScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i8.SearchScreen();
        }),
    NotificationsRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i9.Notifications();
        }),
    AllCategoriesRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<AllCategoriesRouteArgs>();
          return _i10.AllCategories(key: args.key, categories: args.categories);
        }),
    AllOffersScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<AllOffersScreenRouteArgs>();
          return _i11.AllOffersScreen(key: args.key, offers: args.offers);
        }),
    OfferDetailScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<OfferDetailScreenRouteArgs>();
          return _i12.OfferDetailScreen(
              key: args.key,
              offerId: args.offerId,
              initialQuantity: args.initialQuantity);
        }),
    OrderHistoryRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<OrderHistoryRouteArgs>(
              orElse: () => const OrderHistoryRouteArgs());
          return _i13.OrderHistory(key: args.key, orderId: args.orderId);
        }),
    OrderHistoryDetailsRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<OrderHistoryDetailsRouteArgs>();
          return _i14.OrderHistoryDetails(
              key: args.key, retailOrder: args.retailOrder);
        }),
    ProfileRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i15.Profile();
        }),
    ViewMoreScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i16.ViewMoreScreen();
        }),
    CategoriesScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<CategoriesScreenRouteArgs>();
          return _i17.CategoriesScreen(
              key: args.key, categoryModel: args.categoryModel);
        }),
    DistributorRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i18.Distributor();
        }),
    ABoutUsPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<ABoutUsPageRouteArgs>();
          return _i19.ABoutUsPage(key: args.key, about: args.about);
        }),
    HomePageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i20.HomePage();
        }),
    NewArrivalScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i21.NewArrivalScreen();
        }),
    PictureScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<PictureScreenRouteArgs>();
          return _i22.PictureScreen(
              key: args.key, images: args.images, image: args.image);
        },
        fullscreenDialog: true),
    SeeMoreDetailsRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<SeeMoreDetailsRouteArgs>();
          return _i23.SeeMoreDetails(key: args.key, data: args.data);
        },
        fullscreenDialog: true),
    UnknownPageRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i24.UnknownPage();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(SplashScreenRoute.name, path: '/'),
        _i1.RouteConfig(IntroPageRoute.name, path: '/intro-page'),
        _i1.RouteConfig(LoginPageRoute.name, path: '/login-page'),
        _i1.RouteConfig(InitializePageRoute.name, path: '/initialize-page'),
        _i1.RouteConfig(ProductDetailsScreenRoute.name,
            path: '/product-details-screen'),
        _i1.RouteConfig(SearchScreenRoute.name, path: '/search-screen'),
        _i1.RouteConfig(NotificationsRoute.name, path: '/Notifications'),
        _i1.RouteConfig(AllCategoriesRoute.name, path: '/all-categories'),
        _i1.RouteConfig(AllOffersScreenRoute.name, path: '/all-offers-screen'),
        _i1.RouteConfig(OfferDetailScreenRoute.name,
            path: '/offer-detail-screen'),
        _i1.RouteConfig(OrderHistoryRoute.name, path: '/order-history'),
        _i1.RouteConfig(OrderHistoryDetailsRoute.name,
            path: '/order-history-details'),
        _i1.RouteConfig(ProfileRoute.name, path: '/Profile'),
        _i1.RouteConfig(ViewMoreScreenRoute.name, path: '/view-more-screen'),
        _i1.RouteConfig(CategoriesScreenRoute.name, path: '/categories-screen'),
        _i1.RouteConfig(DistributorRoute.name, path: '/Distributor'),
        _i1.RouteConfig(ABoutUsPageRoute.name, path: '/a-bout-us-page'),
        _i1.RouteConfig(HomePageRoute.name, path: '/home-page'),
        _i1.RouteConfig(NewArrivalScreenRoute.name,
            path: '/new-arrival-screen'),
        _i1.RouteConfig(PictureScreenRoute.name, path: '/picture-screen'),
        _i1.RouteConfig(SeeMoreDetailsRoute.name, path: '/see-more-details'),
        _i1.RouteConfig(UnknownPageRoute.name, path: '*')
      ];
}

class SplashScreenRoute extends _i1.PageRouteInfo {
  const SplashScreenRoute() : super(name, path: '/');

  static const String name = 'SplashScreenRoute';
}

class IntroPageRoute extends _i1.PageRouteInfo {
  const IntroPageRoute() : super(name, path: '/intro-page');

  static const String name = 'IntroPageRoute';
}

class LoginPageRoute extends _i1.PageRouteInfo {
  const LoginPageRoute() : super(name, path: '/login-page');

  static const String name = 'LoginPageRoute';
}

class InitializePageRoute extends _i1.PageRouteInfo {
  const InitializePageRoute() : super(name, path: '/initialize-page');

  static const String name = 'InitializePageRoute';
}

class ProductDetailsScreenRoute
    extends _i1.PageRouteInfo<ProductDetailsScreenRouteArgs> {
  ProductDetailsScreenRoute(
      {_i2.Key? key, required _i7.ProductDetailsArguments detailsArguments})
      : super(name,
            path: '/product-details-screen',
            args: ProductDetailsScreenRouteArgs(
                key: key, detailsArguments: detailsArguments));

  static const String name = 'ProductDetailsScreenRoute';
}

class ProductDetailsScreenRouteArgs {
  const ProductDetailsScreenRouteArgs(
      {this.key, required this.detailsArguments});

  final _i2.Key? key;

  final _i7.ProductDetailsArguments detailsArguments;
}

class SearchScreenRoute extends _i1.PageRouteInfo {
  const SearchScreenRoute() : super(name, path: '/search-screen');

  static const String name = 'SearchScreenRoute';
}

class NotificationsRoute extends _i1.PageRouteInfo {
  const NotificationsRoute() : super(name, path: '/Notifications');

  static const String name = 'NotificationsRoute';
}

class AllCategoriesRoute extends _i1.PageRouteInfo<AllCategoriesRouteArgs> {
  AllCategoriesRoute(
      {_i2.Key? key, required List<_i25.CategoryModel> categories})
      : super(name,
            path: '/all-categories',
            args: AllCategoriesRouteArgs(key: key, categories: categories));

  static const String name = 'AllCategoriesRoute';
}

class AllCategoriesRouteArgs {
  const AllCategoriesRouteArgs({this.key, required this.categories});

  final _i2.Key? key;

  final List<_i25.CategoryModel> categories;
}

class AllOffersScreenRoute extends _i1.PageRouteInfo<AllOffersScreenRouteArgs> {
  AllOffersScreenRoute({_i2.Key? key, required List<_i26.OfferModel> offers})
      : super(name,
            path: '/all-offers-screen',
            args: AllOffersScreenRouteArgs(key: key, offers: offers));

  static const String name = 'AllOffersScreenRoute';
}

class AllOffersScreenRouteArgs {
  const AllOffersScreenRouteArgs({this.key, required this.offers});

  final _i2.Key? key;

  final List<_i26.OfferModel> offers;
}

class OfferDetailScreenRoute
    extends _i1.PageRouteInfo<OfferDetailScreenRouteArgs> {
  OfferDetailScreenRoute(
      {_i2.Key? key, required int offerId, int? initialQuantity})
      : super(name,
            path: '/offer-detail-screen',
            args: OfferDetailScreenRouteArgs(
                key: key, offerId: offerId, initialQuantity: initialQuantity));

  static const String name = 'OfferDetailScreenRoute';
}

class OfferDetailScreenRouteArgs {
  const OfferDetailScreenRouteArgs(
      {this.key, required this.offerId, this.initialQuantity});

  final _i2.Key? key;

  final int offerId;

  final int? initialQuantity;
}

class OrderHistoryRoute extends _i1.PageRouteInfo<OrderHistoryRouteArgs> {
  OrderHistoryRoute({_i2.Key? key, int? orderId})
      : super(name,
            path: '/order-history',
            args: OrderHistoryRouteArgs(key: key, orderId: orderId));

  static const String name = 'OrderHistoryRoute';
}

class OrderHistoryRouteArgs {
  const OrderHistoryRouteArgs({this.key, this.orderId});

  final _i2.Key? key;

  final int? orderId;
}

class OrderHistoryDetailsRoute
    extends _i1.PageRouteInfo<OrderHistoryDetailsRouteArgs> {
  OrderHistoryDetailsRoute(
      {_i2.Key? key, required _i27.RetailOrdersModel retailOrder})
      : super(name,
            path: '/order-history-details',
            args: OrderHistoryDetailsRouteArgs(
                key: key, retailOrder: retailOrder));

  static const String name = 'OrderHistoryDetailsRoute';
}

class OrderHistoryDetailsRouteArgs {
  const OrderHistoryDetailsRouteArgs({this.key, required this.retailOrder});

  final _i2.Key? key;

  final _i27.RetailOrdersModel retailOrder;
}

class ProfileRoute extends _i1.PageRouteInfo {
  const ProfileRoute() : super(name, path: '/Profile');

  static const String name = 'ProfileRoute';
}

class ViewMoreScreenRoute extends _i1.PageRouteInfo {
  const ViewMoreScreenRoute() : super(name, path: '/view-more-screen');

  static const String name = 'ViewMoreScreenRoute';
}

class CategoriesScreenRoute
    extends _i1.PageRouteInfo<CategoriesScreenRouteArgs> {
  CategoriesScreenRoute(
      {_i2.Key? key, required _i25.CategoryModel categoryModel})
      : super(name,
            path: '/categories-screen',
            args: CategoriesScreenRouteArgs(
                key: key, categoryModel: categoryModel));

  static const String name = 'CategoriesScreenRoute';
}

class CategoriesScreenRouteArgs {
  const CategoriesScreenRouteArgs({this.key, required this.categoryModel});

  final _i2.Key? key;

  final _i25.CategoryModel categoryModel;
}

class DistributorRoute extends _i1.PageRouteInfo {
  const DistributorRoute() : super(name, path: '/Distributor');

  static const String name = 'DistributorRoute';
}

class ABoutUsPageRoute extends _i1.PageRouteInfo<ABoutUsPageRouteArgs> {
  ABoutUsPageRoute({_i2.Key? key, required _i28.AboutModel? about})
      : super(name,
            path: '/a-bout-us-page',
            args: ABoutUsPageRouteArgs(key: key, about: about));

  static const String name = 'ABoutUsPageRoute';
}

class ABoutUsPageRouteArgs {
  const ABoutUsPageRouteArgs({this.key, required this.about});

  final _i2.Key? key;

  final _i28.AboutModel? about;
}

class HomePageRoute extends _i1.PageRouteInfo {
  const HomePageRoute() : super(name, path: '/home-page');

  static const String name = 'HomePageRoute';
}

class NewArrivalScreenRoute extends _i1.PageRouteInfo {
  const NewArrivalScreenRoute() : super(name, path: '/new-arrival-screen');

  static const String name = 'NewArrivalScreenRoute';
}

class PictureScreenRoute extends _i1.PageRouteInfo<PictureScreenRouteArgs> {
  PictureScreenRoute(
      {_i2.Key? key,
      required List<_i29.ProductImagesModel> images,
      required _i29.ProductImagesModel image})
      : super(name,
            path: '/picture-screen',
            args:
                PictureScreenRouteArgs(key: key, images: images, image: image));

  static const String name = 'PictureScreenRoute';
}

class PictureScreenRouteArgs {
  const PictureScreenRouteArgs(
      {this.key, required this.images, required this.image});

  final _i2.Key? key;

  final List<_i29.ProductImagesModel> images;

  final _i29.ProductImagesModel image;
}

class SeeMoreDetailsRoute extends _i1.PageRouteInfo<SeeMoreDetailsRouteArgs> {
  SeeMoreDetailsRoute({_i2.Key? key, required String data})
      : super(name,
            path: '/see-more-details',
            args: SeeMoreDetailsRouteArgs(key: key, data: data));

  static const String name = 'SeeMoreDetailsRoute';
}

class SeeMoreDetailsRouteArgs {
  const SeeMoreDetailsRouteArgs({this.key, required this.data});

  final _i2.Key? key;

  final String data;
}

class UnknownPageRoute extends _i1.PageRouteInfo {
  const UnknownPageRoute() : super(name, path: '*');

  static const String name = 'UnknownPageRoute';
}
