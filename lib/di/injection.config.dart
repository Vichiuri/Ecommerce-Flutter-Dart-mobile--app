// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_messaging/firebase_messaging.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:location/location.dart' as _i9;
import 'package:shared_preferences/shared_preferences.dart' as _i15;
import 'package:speech_to_text/speech_to_text.dart' as _i16;

import '../core/network/HandleNetworkCall.dart' as _i20;
import '../core/utils/CheckAuthentication.dart' as _i7;
import '../database/app_database.dart' as _i3;
import '../database/banners/banner_dao.dart' as _i4;
import '../database/cart/cart_dao.dart' as _i5;
import '../database/cart/retail_salesman_dao.dart' as _i13;
import '../database/categories/category_dao.dart' as _i6;
import '../database/offer/offer_dao.dart' as _i11;
import '../database/products/product_dao.dart' as _i12;
import '../database/retailer/retailer_dao.dart' as _i14;
import '../features/data/datasourse/api/api.dart' as _i21;
import '../features/data/datasourse/firebase/firebase.dart' as _i17;
import '../features/data/datasourse/local/local_data_source.dart' as _i18;
import '../features/data/datasourse/location/location_data_source.dart' as _i10;
import '../features/data/datasourse/remote/remote_data.dart' as _i22;
import '../features/data/datasourse/speech/speech.dart' as _i19;
import '../features/data/repositories/repository_impl.dart' as _i24;
import '../features/domain/repositories/repository.dart' as _i23;
import '../features/domain/usecase/add_offer_to_cart.dart' as _i31;
import '../features/domain/usecase/add_remove_to_fav.dart' as _i33;
import '../features/domain/usecase/add_single_to_cart.dart' as _i35;
import '../features/domain/usecase/add_to_cart.dart' as _i36;
import '../features/domain/usecase/change_distributor.dart' as _i38;
import '../features/domain/usecase/change_password.dart' as _i39;
import '../features/domain/usecase/check_auth_user.dart' as _i40;
import '../features/domain/usecase/CheckFirstTime.dart' as _i41;
import '../features/domain/usecase/confirm_delivery.dart' as _i42;
import '../features/domain/usecase/delete_cart.dart' as _i43;
import '../features/domain/usecase/delete_order.dart' as _i45;
import '../features/domain/usecase/fetch_by_category.dart' as _i46;
import '../features/domain/usecase/fetch_distributor.dart' as _i50;
import '../features/domain/usecase/fetch_notifications.dart' as _i52;
import '../features/domain/usecase/fetch_profile.dart' as _i53;
import '../features/domain/usecase/fetch_retailer.dart' as _i54;
import '../features/domain/usecase/fetch_transport.dart' as _i55;
import '../features/domain/usecase/FetchCart.dart' as _i48;
import '../features/domain/usecase/FetchDashBoard.dart' as _i49;
import '../features/domain/usecase/FetchLocalUser.dart' as _i51;
import '../features/domain/usecase/filter_orders.dart' as _i56;
import '../features/domain/usecase/forgot_password.dart' as _i57;
import '../features/domain/usecase/get_banners.dart' as _i59;
import '../features/domain/usecase/get_cart_quantity.dart' as _i61;
import '../features/domain/usecase/get_categories.dart' as _i63;
import '../features/domain/usecase/get_current_distributer.dart' as _i64;
import '../features/domain/usecase/get_description.dart' as _i65;
import '../features/domain/usecase/get_favourites.dart' as _i66;
import '../features/domain/usecase/get_initial_message.dart' as _i68;
import '../features/domain/usecase/get_offers.dart' as _i69;
import '../features/domain/usecase/get_order_history.dart' as _i70;
import '../features/domain/usecase/get_paginated_products.dart' as _i71;
import '../features/domain/usecase/get_price_level.dart' as _i72;
import '../features/domain/usecase/get_recently_bought.dart' as _i73;
import '../features/domain/usecase/get_related.dart' as _i74;
import '../features/domain/usecase/get_single_category.dart' as _i76;
import '../features/domain/usecase/get_single_offet.dart' as _i77;
import '../features/domain/usecase/get_single_product.dart' as _i78;
import '../features/domain/usecase/get_slabs.dart' as _i79;
import '../features/domain/usecase/get_top_products.dart' as _i80;
import '../features/domain/usecase/initialize_product.dart' as _i82;
import '../features/domain/usecase/login.dart' as _i84;
import '../features/domain/usecase/logout.dart' as _i85;
import '../features/domain/usecase/new_arrivals.dart' as _i87;
import '../features/domain/usecase/place_order.dart' as _i94;
import '../features/domain/usecase/reorder.dart' as _i99;
import '../features/domain/usecase/SaveFirstTime.dart' as _i25;
import '../features/domain/usecase/search_products.dart' as _i26;
import '../features/domain/usecase/search_retailer.dart' as _i27;
import '../features/domain/usecase/send_location.dart' as _i28;
import '../features/domain/usecase/stream_on_message.dart' as _i29;
import '../features/domain/usecase/stream_on_message_opened_app.dart' as _i30;
import '../features/presentation/bloc/add_offer_to_cart/add_offer_to_cart_bloc.dart'
    as _i32;
import '../features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart'
    as _i34;
import '../features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart'
    as _i37;
import '../features/presentation/bloc/all_category/all_category_bloc.dart'
    as _i109;
import '../features/presentation/bloc/auth/auth_bloc.dart' as _i110;
import '../features/presentation/bloc/dashboard/dashboard_bloc.dart' as _i111;
import '../features/presentation/bloc/delete_cart/delete_cart_bloc.dart'
    as _i44;
import '../features/presentation/bloc/delete_order/delete_order_bloc.dart'
    as _i112;
import '../features/presentation/bloc/description_bloc/description_bloc.dart'
    as _i113;
import '../features/presentation/bloc/distributor/distributor_bloc.dart'
    as _i114;
import '../features/presentation/bloc/fetch_by_cat/fetch_by_category_bloc.dart'
    as _i47;
import '../features/presentation/bloc/fetch_current_distributor/fetch_current_distributor_bloc.dart'
    as _i115;
import '../features/presentation/bloc/forgot_password/forgot_password_bloc.dart'
    as _i58;
import '../features/presentation/bloc/get_banners/get_banners_bloc.dart'
    as _i60;
import '../features/presentation/bloc/get_cart_quantity/get_cart_quantity_bloc.dart'
    as _i62;
import '../features/presentation/bloc/get_category/get_category_bloc.dart'
    as _i116;
import '../features/presentation/bloc/get_fav/get_favourites_bloc.dart' as _i67;
import '../features/presentation/bloc/get_offer/get_offer_bloc.dart' as _i117;
import '../features/presentation/bloc/get_retailer/get_retailer_bloc.dart'
    as _i75;
import '../features/presentation/bloc/initial_message/initial_message_bloc.dart'
    as _i81;
import '../features/presentation/bloc/initialize_prod/initialize_product_bloc.dart'
    as _i83;
import '../features/presentation/bloc/main/main_bloc.dart' as _i86;
import '../features/presentation/bloc/new_arrivals/new_arrivals_bloc.dart'
    as _i88;
import '../features/presentation/bloc/notifications_bloc/notifications_bloc.dart'
    as _i89;
import '../features/presentation/bloc/on_message/on_message_bloc.dart' as _i90;
import '../features/presentation/bloc/on_message_oppened/on_message_opened_bloc.dart'
    as _i91;
import '../features/presentation/bloc/order_history/order_history_bloc.dart'
    as _i92;
import '../features/presentation/bloc/password/password_bloc.dart' as _i93;
import '../features/presentation/bloc/place_order/place_order_bloc.dart'
    as _i95;
import '../features/presentation/bloc/price_level/price_level_bloc.dart'
    as _i96;
import '../features/presentation/bloc/product_paginated/product_paginated_bloc.dart'
    as _i97;
import '../features/presentation/bloc/profile/profile_bloc.dart' as _i98;
import '../features/presentation/bloc/recent_buy/recent_bought_bloc.dart'
    as _i100;
import '../features/presentation/bloc/related/related_bloc.dart' as _i101;
import '../features/presentation/bloc/search_product/search_product_bloc.dart'
    as _i102;
import '../features/presentation/bloc/single_offer/single_offer_bloc.dart'
    as _i103;
import '../features/presentation/bloc/single_product/single_product_bloc.dart'
    as _i104;
import '../features/presentation/bloc/slabs/slabs_bloc.dart' as _i105;
import '../features/presentation/bloc/splash/splash_bloc.dart' as _i106;
import '../features/presentation/bloc/top_product/top_product_bloc.dart'
    as _i107;
import '../features/presentation/bloc/transport/transport_bloc.dart' as _i108;
import 'module_injection.dart' as _i118; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final injectionModules = _$InjectionModules();
  gh.lazySingleton<_i3.AppDatabase>(() => _i3.AppDatabase());
  gh.lazySingleton<_i4.BannerDao>(() => _i4.BannerDao(get<_i3.AppDatabase>()));
  gh.lazySingleton<_i5.CartDao>(() => _i5.CartDao(get<_i3.AppDatabase>()));
  gh.lazySingleton<_i6.CategoryDao>(
      () => _i6.CategoryDao(get<_i3.AppDatabase>()));
  gh.lazySingleton<_i7.CheckAuthentication>(() => _i7.CheckAuthentication());
  gh.lazySingleton<_i8.FirebaseMessaging>(() => injectionModules.messaging);
  gh.lazySingleton<_i9.Location>(() => injectionModules.location);
  gh.lazySingleton<_i10.LocationDataSource>(
      () => _i10.LocationSource(get<_i9.Location>()));
  gh.lazySingleton<_i11.OfferDao>(() => _i11.OfferDao(get<_i3.AppDatabase>()));
  gh.lazySingleton<_i12.ProductDao>(
      () => _i12.ProductDao(get<_i3.AppDatabase>()));
  gh.lazySingleton<_i13.RetailSalesmanDao>(
      () => _i13.RetailSalesmanDao(get<_i3.AppDatabase>()));
  gh.lazySingleton<_i14.RetailerDao>(
      () => _i14.RetailerDao(get<_i3.AppDatabase>()));
  await gh.factoryAsync<_i15.SharedPreferences>(() => injectionModules.prefs,
      preResolve: true);
  gh.factory<_i16.SpeechToText>(() => injectionModules.speech);
  gh.lazySingleton<_i17.FirebaseHelper>(
      () => _i17.FirebaseHelperImpl(get<_i8.FirebaseMessaging>()));
  gh.lazySingleton<_i18.LocalDataSource>(() => _i18.LocalDataSourceImpl(
      get<_i15.SharedPreferences>(),
      get<_i4.BannerDao>(),
      get<_i6.CategoryDao>(),
      get<_i11.OfferDao>(),
      get<_i12.ProductDao>(),
      get<_i5.CartDao>(),
      get<_i14.RetailerDao>(),
      get<_i13.RetailSalesmanDao>()));
  gh.lazySingleton<_i19.SpeechSource>(
      () => _i19.SpeechSourceImpl(get<_i16.SpeechToText>()));
  gh.lazySingleton<_i20.HandleNetworkCall>(() =>
      _i20.HandleNetworkCall(localDataSource: get<_i18.LocalDataSource>()));
  gh.lazySingleton<_i21.Api>(
      () => _i21.ApiImpl(networkCall: get<_i20.HandleNetworkCall>()));
  gh.lazySingleton<_i22.RemoteDataSource>(() => _i22.RemoteDataSourceImpl(
      get<_i20.HandleNetworkCall>(), get<_i21.Api>()));
  gh.lazySingleton<_i23.Repository>(() => _i24.RepositoryImplementation(
      get<_i18.LocalDataSource>(),
      get<_i22.RemoteDataSource>(),
      get<_i10.LocationDataSource>(),
      get<_i17.FirebaseHelper>()));
  gh.lazySingleton<_i25.SaveFirstTime>(
      () => _i25.SaveFirstTime(repository: get<_i23.Repository>()));
  gh.lazySingleton<_i26.SearchProducts>(
      () => _i26.SearchProducts(get<_i23.Repository>()));
  gh.lazySingleton<_i27.SearchRetailer>(
      () => _i27.SearchRetailer(get<_i23.Repository>()));
  gh.lazySingleton<_i28.SendLocation>(
      () => _i28.SendLocation(get<_i23.Repository>()));
  gh.lazySingleton<_i29.StreamOnMessage>(
      () => _i29.StreamOnMessage(get<_i23.Repository>()));
  gh.lazySingleton<_i30.StreamOnMessageOpenedApp>(
      () => _i30.StreamOnMessageOpenedApp(get<_i23.Repository>()));
  gh.lazySingleton<_i31.AddOfferToCart>(
      () => _i31.AddOfferToCart(get<_i23.Repository>()));
  gh.factory<_i32.AddOfferToCartBloc>(
      () => _i32.AddOfferToCartBloc(get<_i31.AddOfferToCart>()));
  gh.lazySingleton<_i33.AddRemoveToFav>(
      () => _i33.AddRemoveToFav(get<_i23.Repository>()));
  gh.factory<_i34.AddRemoveToFavBloc>(
      () => _i34.AddRemoveToFavBloc(get<_i33.AddRemoveToFav>()));
  gh.lazySingleton<_i35.AddSingleToCart>(
      () => _i35.AddSingleToCart(get<_i23.Repository>()));
  gh.lazySingleton<_i36.AddToCart>(
      () => _i36.AddToCart(get<_i23.Repository>()));
  gh.factory<_i37.AddToCartBloc>(() =>
      _i37.AddToCartBloc(get<_i36.AddToCart>(), get<_i35.AddSingleToCart>()));
  gh.lazySingleton<_i38.ChangeDistributor>(
      () => _i38.ChangeDistributor(get<_i23.Repository>()));
  gh.lazySingleton<_i39.ChangePassword>(
      () => _i39.ChangePassword(get<_i23.Repository>()));
  gh.lazySingleton<_i40.CheckAuthUser>(
      () => _i40.CheckAuthUser(get<_i23.Repository>()));
  gh.lazySingleton<_i41.CheckFirstTime>(
      () => _i41.CheckFirstTime(repository: get<_i23.Repository>()));
  gh.lazySingleton<_i42.ConfirmDelivery>(
      () => _i42.ConfirmDelivery(get<_i23.Repository>()));
  gh.lazySingleton<_i43.DeleteCart>(
      () => _i43.DeleteCart(get<_i23.Repository>()));
  gh.factory<_i44.DeleteCartBloc>(
      () => _i44.DeleteCartBloc(get<_i43.DeleteCart>()));
  gh.lazySingleton<_i45.DeleteOrder>(
      () => _i45.DeleteOrder(get<_i23.Repository>()));
  gh.lazySingleton<_i46.FetchByCategory>(
      () => _i46.FetchByCategory(get<_i23.Repository>()));
  gh.factory<_i47.FetchByCategoryBloc>(
      () => _i47.FetchByCategoryBloc(get<_i46.FetchByCategory>()));
  gh.lazySingleton<_i48.FetchCart>(
      () => _i48.FetchCart(repository: get<_i23.Repository>()));
  gh.lazySingleton<_i49.FetchDashBoard>(
      () => _i49.FetchDashBoard(repository: get<_i23.Repository>()));
  gh.lazySingleton<_i50.FetchDistributor>(
      () => _i50.FetchDistributor(get<_i23.Repository>()));
  gh.lazySingleton<_i51.FetchLocalUser>(
      () => _i51.FetchLocalUser(repository: get<_i23.Repository>()));
  gh.lazySingleton<_i52.FetchNotifications>(
      () => _i52.FetchNotifications(get<_i23.Repository>()));
  gh.lazySingleton<_i53.FetchProfile>(
      () => _i53.FetchProfile(get<_i23.Repository>()));
  gh.lazySingleton<_i54.FetchRetailer>(
      () => _i54.FetchRetailer(get<_i23.Repository>()));
  gh.lazySingleton<_i55.FetchTransport>(
      () => _i55.FetchTransport(get<_i23.Repository>()));
  gh.lazySingleton<_i56.FilterOrders>(
      () => _i56.FilterOrders(get<_i23.Repository>()));
  gh.lazySingleton<_i57.ForgotPassword>(
      () => _i57.ForgotPassword(get<_i23.Repository>()));
  gh.factory<_i58.ForgotPasswordBloc>(
      () => _i58.ForgotPasswordBloc(get<_i57.ForgotPassword>()));
  gh.lazySingleton<_i59.GetBanners>(
      () => _i59.GetBanners(get<_i23.Repository>()));
  gh.factory<_i60.GetBannersBloc>(
      () => _i60.GetBannersBloc(get<_i59.GetBanners>()));
  gh.lazySingleton<_i61.GetCartQuantity>(
      () => _i61.GetCartQuantity(get<_i23.Repository>()));
  gh.factory<_i62.GetCartQuantityBloc>(
      () => _i62.GetCartQuantityBloc(get<_i61.GetCartQuantity>()));
  gh.lazySingleton<_i63.GetCategories>(
      () => _i63.GetCategories(get<_i23.Repository>()));
  gh.lazySingleton<_i64.GetCurrentDistributor>(
      () => _i64.GetCurrentDistributor(get<_i23.Repository>()));
  gh.lazySingleton<_i65.GetDescription>(
      () => _i65.GetDescription(get<_i23.Repository>()));
  gh.lazySingleton<_i66.GetFavourites>(
      () => _i66.GetFavourites(get<_i23.Repository>()));
  gh.factory<_i67.GetFavouritesBloc>(
      () => _i67.GetFavouritesBloc(get<_i66.GetFavourites>()));
  gh.lazySingleton<_i68.GetInitialMessage>(
      () => _i68.GetInitialMessage(get<_i23.Repository>()));
  gh.lazySingleton<_i69.GetOffers>(
      () => _i69.GetOffers(get<_i23.Repository>()));
  gh.lazySingleton<_i70.GetOrderHistory>(
      () => _i70.GetOrderHistory(get<_i23.Repository>()));
  gh.lazySingleton<_i71.GetPaginatedProduct>(
      () => _i71.GetPaginatedProduct(get<_i23.Repository>()));
  gh.lazySingleton<_i72.GetPriceLevel>(
      () => _i72.GetPriceLevel(get<_i23.Repository>()));
  gh.lazySingleton<_i73.GetRecentlyBought>(
      () => _i73.GetRecentlyBought(get<_i23.Repository>()));
  gh.lazySingleton<_i74.GetRelated>(
      () => _i74.GetRelated(get<_i23.Repository>()));
  gh.factory<_i75.GetRetailerBloc>(
      () => _i75.GetRetailerBloc(get<_i54.FetchRetailer>()));
  gh.lazySingleton<_i76.GetSingleCategory>(
      () => _i76.GetSingleCategory(get<_i23.Repository>()));
  gh.lazySingleton<_i77.GetSingleOffer>(
      () => _i77.GetSingleOffer(get<_i23.Repository>()));
  gh.lazySingleton<_i78.GetSingleProduct>(
      () => _i78.GetSingleProduct(get<_i23.Repository>()));
  gh.lazySingleton<_i79.GetSlabs>(() => _i79.GetSlabs(get<_i23.Repository>()));
  gh.lazySingleton<_i80.GetTopProducts>(
      () => _i80.GetTopProducts(get<_i23.Repository>()));
  gh.factory<_i81.InitialMessageBloc>(
      () => _i81.InitialMessageBloc(get<_i68.GetInitialMessage>()));
  gh.lazySingleton<_i82.InitializeProduct>(
      () => _i82.InitializeProduct(get<_i23.Repository>()));
  gh.factory<_i83.InitializeProductBloc>(
      () => _i83.InitializeProductBloc(get<_i82.InitializeProduct>()));
  gh.lazySingleton<_i84.Login>(() => _i84.Login(get<_i23.Repository>()));
  gh.lazySingleton<_i85.Logout>(() => _i85.Logout(get<_i23.Repository>()));
  gh.factory<_i86.MainBloc>(
      () => _i86.MainBloc(fetchCart: get<_i48.FetchCart>()));
  gh.lazySingleton<_i87.NewArrivals>(
      () => _i87.NewArrivals(get<_i23.Repository>()));
  gh.factory<_i88.NewArrivalsBloc>(
      () => _i88.NewArrivalsBloc(get<_i87.NewArrivals>()));
  gh.factory<_i89.NotificationsBloc>(
      () => _i89.NotificationsBloc(get<_i52.FetchNotifications>()));
  gh.factory<_i90.OnMessageBloc>(
      () => _i90.OnMessageBloc(get<_i29.StreamOnMessage>()));
  gh.factory<_i91.OnMessageOpenedBloc>(
      () => _i91.OnMessageOpenedBloc(get<_i30.StreamOnMessageOpenedApp>()));
  gh.factory<_i92.OrderHistoryBloc>(() => _i92.OrderHistoryBloc(
      get<_i70.GetOrderHistory>(), get<_i56.FilterOrders>()));
  gh.factory<_i93.PasswordBloc>(
      () => _i93.PasswordBloc(get<_i39.ChangePassword>()));
  gh.lazySingleton<_i94.PlaceOrder>(
      () => _i94.PlaceOrder(get<_i23.Repository>()));
  gh.factory<_i95.PlaceOrderBloc>(
      () => _i95.PlaceOrderBloc(get<_i94.PlaceOrder>()));
  gh.factory<_i96.PriceLevelBloc>(
      () => _i96.PriceLevelBloc(get<_i72.GetPriceLevel>()));
  gh.factory<_i97.ProductPaginatedBloc>(() => _i97.ProductPaginatedBloc(
      get<_i71.GetPaginatedProduct>(), get<_i87.NewArrivals>()));
  gh.factory<_i98.ProfileBloc>(
      () => _i98.ProfileBloc(get<_i53.FetchProfile>()));
  gh.lazySingleton<_i99.ReOrder>(() => _i99.ReOrder(get<_i23.Repository>()));
  gh.factory<_i100.RecentBoughtBloc>(
      () => _i100.RecentBoughtBloc(get<_i73.GetRecentlyBought>()));
  gh.factory<_i101.RelatedBloc>(
      () => _i101.RelatedBloc(get<_i74.GetRelated>()));
  gh.factory<_i102.SearchProductBloc>(
      () => _i102.SearchProductBloc(get<_i26.SearchProducts>()));
  gh.factory<_i103.SingleOfferBloc>(
      () => _i103.SingleOfferBloc(get<_i77.GetSingleOffer>()));
  gh.factory<_i104.SingleProductBloc>(
      () => _i104.SingleProductBloc(get<_i78.GetSingleProduct>()));
  gh.factory<_i105.SlabsBloc>(() => _i105.SlabsBloc(get<_i79.GetSlabs>()));
  gh.factory<_i106.SplashBloc>(() => _i106.SplashBloc(
      get<_i85.Logout>(), get<_i40.CheckAuthUser>(), get<_i28.SendLocation>(),
      checkFirstTime: get<_i41.CheckFirstTime>(),
      fetchLocalUser: get<_i51.FetchLocalUser>(),
      saveFirstTime: get<_i25.SaveFirstTime>()));
  gh.factory<_i107.TopProductBloc>(
      () => _i107.TopProductBloc(get<_i80.GetTopProducts>()));
  gh.factory<_i108.TransportBloc>(
      () => _i108.TransportBloc(get<_i55.FetchTransport>()));
  gh.factory<_i109.AllCategoryBloc>(
      () => _i109.AllCategoryBloc(get<_i63.GetCategories>()));
  gh.factory<_i110.AuthBloc>(
      () => _i110.AuthBloc(get<_i84.Login>(), get<_i7.CheckAuthentication>()));
  gh.factory<_i111.DashboardBloc>(
      () => _i111.DashboardBloc(fetchDashBoard: get<_i49.FetchDashBoard>()));
  gh.factory<_i112.DeleteOrderBloc>(() => _i112.DeleteOrderBloc(
      get<_i45.DeleteOrder>(),
      get<_i42.ConfirmDelivery>(),
      get<_i99.ReOrder>()));
  gh.factory<_i113.DescriptionBloc>(
      () => _i113.DescriptionBloc(get<_i65.GetDescription>()));
  gh.factory<_i114.DistributorBloc>(() => _i114.DistributorBloc(
      get<_i50.FetchDistributor>(), get<_i38.ChangeDistributor>()));
  gh.factory<_i115.FetchCurrentDistributorBloc>(() =>
      _i115.FetchCurrentDistributorBloc(get<_i64.GetCurrentDistributor>()));
  gh.factory<_i116.GetCategoryBloc>(() => _i116.GetCategoryBloc(
      get<_i63.GetCategories>(), get<_i76.GetSingleCategory>()));
  gh.factory<_i117.GetOfferBloc>(
      () => _i117.GetOfferBloc(get<_i69.GetOffers>()));
  return get;
}

class _$InjectionModules extends _i118.InjectionModules {}
