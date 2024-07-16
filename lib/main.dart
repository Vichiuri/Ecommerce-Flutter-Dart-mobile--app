import 'package:biz_mobile_app/features/presentation/bloc/get_category/get_category_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:biz_mobile_app/features/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/fetch_current_distributor/fetch_current_distributor_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/initial_message/initial_message_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/on_message/on_message_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/search_product/search_product_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/splash/splash_bloc.dart';

import 'core/routes/app_router.gr.dart';
import 'core/utils/const.dart';
import 'core/utils/simple_bloc_observer.dart';
import 'di/injection.dart';
import 'features/presentation/bloc/get_banners/get_banners_bloc.dart';
import 'features/presentation/bloc/get_cart_quantity/get_cart_quantity_bloc.dart';
import 'features/presentation/bloc/get_offer/get_offer_bloc.dart';
import 'features/presentation/bloc/new_arrivals/new_arrivals_bloc.dart';
import 'features/presentation/bloc/notifications_bloc/notifications_bloc.dart';
import 'features/presentation/bloc/on_message_oppened/on_message_opened_bloc.dart';
import 'features/presentation/bloc/product_paginated/product_paginated_bloc.dart';
import 'features/presentation/bloc/recent_buy/recent_bought_bloc.dart';
import 'features/presentation/bloc/top_product/top_product_bloc.dart';
import 'features/presentation/components/network_dialogue.dart';

///main entry
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await configureInjection(Env.dev);
  await Firebase.initializeApp();
  runApp(MyApp());
}

//*handling background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

//* nots plugin

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final _navKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  bool _isOpen = false;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final _fcm = FirebaseMessaging.instance;
  final _appRouter = AppRouter(_navKey);

  final _onMessageBloc = getIt<OnMessageBloc>();
  final _onMessageOpenedBloc = getIt<OnMessageOpenedBloc>();
  // final _networkBloc = getIt<NetworkBloc>();
  final _getCartQuantityBloc = getIt<GetCartQuantityBloc>();
  final _splashBloc = getIt<SplashBloc>();
  final _fetchCurrentDistributorBloc = getIt<FetchCurrentDistributorBloc>();
  final _searchProductBloc = getIt<SearchProductBloc>();
  final _dashboardBloc = getIt<DashboardBloc>();
  final _initialMessageBloc = getIt<InitialMessageBloc>();
  final _notificationsBloc = getIt<NotificationsBloc>();

  //*Not Sure About this
  late final _categoryBloc = getIt<GetCategoryBloc>();
  late final _productPaginated = getIt<ProductPaginatedBloc>();
  late final _newArrivalsBloc = getIt<NewArrivalsBloc>();
  late final _getOfferBloc = getIt<GetOfferBloc>();
  late final _getBannerBloc = getIt<GetBannersBloc>();
  late final _topProductBloc = getIt<TopProductBloc>();
  late final _recentProductBloc = getIt<RecentBoughtBloc>();

  @override
  void initState() {
    super.initState();

    // _initialMessageBloc.add(GetInitialMessageEventStarted());
    // _onMessageOpenedBloc.add(OnMessageOppenedStarted());
    // _onMessageBloc.add(OnMessageStarted());
  }

  @override
  void dispose() {
    super.dispose();
    _dashboardBloc.close();
    _initialMessageBloc.close();
    _onMessageBloc.close();
    _onMessageOpenedBloc.close();
    // _networkBloc.close();
    _getCartQuantityBloc.close();
    _splashBloc.close();
    _fetchCurrentDistributorBloc.close();
    _searchProductBloc.close();
    _notificationsBloc.close();

    //!HAPA
    _categoryBloc.close();
    _productPaginated.close();
    _newArrivalsBloc.close();
    _getBannerBloc.close();
    _getOfferBloc.close();
    _topProductBloc.close();
    _recentProductBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    // final _width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Colors.white,
    //     systemNavigationBarColor: Colors.white,
    //     systemNavigationBarDividerColor: Colors.white,
    //   ),
    // );
    // SystemChrome.restoreSystemUIOverlays();
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return LayoutBuilder(
        // stream: null,
        builder: (context, constrains) {
      // if (constrains.minHeight) {}
      return MultiBlocProvider(
        providers: [
          // BlocProvider(create: (_) => _networkBloc),
          BlocProvider(create: (_) => _onMessageBloc),
          BlocProvider(create: (_) => _onMessageOpenedBloc),
          BlocProvider(create: (_) => _getCartQuantityBloc),
          BlocProvider(create: (_) => _splashBloc),
          BlocProvider(create: (_) => _fetchCurrentDistributorBloc),
          BlocProvider(create: (_) => _searchProductBloc),
          BlocProvider(create: (_) => _dashboardBloc),
          BlocProvider(create: (_) => _initialMessageBloc),
          BlocProvider(create: (_) => _notificationsBloc),
          //!HaPA SIKO SURE
          BlocProvider(create: (create) => _categoryBloc),
          BlocProvider(create: (create) => _productPaginated),
          BlocProvider(create: (create) => _newArrivalsBloc),
          BlocProvider(create: (create) => _getBannerBloc),
          BlocProvider(create: (create) => _getOfferBloc),
          BlocProvider(create: (create) => _topProductBloc),
          BlocProvider(create: (create) => _recentProductBloc)
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<SplashBloc, SplashState>(
              listener: (context, state) {
                if (state is SplashToLogin) {
                  // _navKey.currentContext?.router.replace(LoginPageRoute());
                }
              },
            ),
            BlocListener<InitialMessageBloc, InitialMessageState>(
              listener: (context, state) {
                if (state is InitialMessageSuccess) {
                  print("I do wanna forget how I feel right now");

                  // if (state.model.singleNotification!.status == "Product") {
                  //   _navKey.currentContext?.router.push(
                  //     ProductDetailsScreenRoute(
                  //         detailsArguments: ProductDetailsArguments(
                  //       product: null,
                  //       initialValue: 0,
                  //       id: int.parse(
                  //         state.model.singleNotification!.product,
                  //       ),
                  //     )),
                  //   );
                  // } else if (state.model.singleNotification!.status == "Offer") {
                  //   _navKey.currentContext?.router.push(OfferDetailScreenRoute(
                  //       offerId: int.parse(
                  //     state.model.singleNotification!.offer,
                  //   )));
                  // } else {
                  //   _navKey.currentContext?.router.push(NotificationsRoute());
                  //   print("Notifications");
                  // }
                }
              },
            ),
            BlocListener<OnMessageOpenedBloc, OnMessageOpenedState>(
              listener: (context, state) {
                if (state is OnMessageOpenedSuccess) {
                  context
                      .read<NotificationsBloc>()
                      .add(GetNotificationStarted());

                  // if (state.model.singleNotification!.status == "Product") {
                  //   _navKey.currentContext?.router.push(
                  //     ProductDetailsScreenRoute(
                  //         detailsArguments: ProductDetailsArguments(
                  //       product: null,
                  //       initialValue: 0,
                  //       id: int.parse(
                  //         state.model.singleNotification!.product,
                  //       ),
                  //     )),
                  //   );
                  // } else if (state.model.singleNotification!.status == "Offer") {
                  //   _navKey.currentContext?.router.push(OfferDetailScreenRoute(
                  //       offerId: int.parse(
                  //     state.model.singleNotification!.offer,
                  //   )));
                  // } else {
                  //   _navKey.currentContext?.router.push(NotificationsRoute());
                  //   print("Notifications");
                  //   print("Notifications");
                  // }
                }
              },
            ),
            BlocListener<OnMessageBloc, OnMessageState>(
              listener: (context, state) {
                if (state is OnMessageSuccess) {
                  context
                      .read<NotificationsBloc>()
                      .add(GetNotificationStarted());
                  print("DATA:");
                  print("${state.model.notificationModel!.message.data}");
                  // _notificationsBloc.add(GetNotificationStarted());
                  // showSimpleNotification(
                  //   Text(state.model.notificationModel!.title),
                  //   subtitle: Text(
                  //     state.model.notificationModel!.body,
                  //     style: TextStyle(fontSize: 11),
                  //   ),
                  //   slideDismiss: true,
                  //   position: NotificationPosition.top,
                  //   // background: Theme.of(context).accentColor,
                  //   autoDismiss: true,
                  //   // slideDismiss: true,
                  //   trailing: Builder(
                  //     builder: (context) {
                  //       return TextButton(
                  //         // textColor:
                  //         onPressed: () {
                  //           if (state.model.singleNotification!.status ==
                  //               "Product") {
                  //             _navKey.currentContext?.router.push(
                  //               ProductDetailsScreenRoute(
                  //                   detailsArguments: ProductDetailsArguments(
                  //                 product: null,
                  //                 initialValue: 0,
                  //                 id: int.parse(
                  //                   state.model.singleNotification!.product,
                  //                 ),
                  //               )),
                  //             );
                  //           } else if (state.model.singleNotification!.status ==
                  //               "Offer") {
                  //             _navKey.currentContext?.router
                  //                 .push(OfferDetailScreenRoute(
                  //                     offerId: int.parse(
                  //               state.model.singleNotification!.offer,
                  //             )));
                  //           } else {
                  //             _navKey.currentState!.push(MaterialPageRoute(
                  //                 builder: (builder) => Notifications()));
                  //             print("Notifications");
                  //             print("Notifications");
                  //           }
                  //         },
                  //         child: Text(
                  //           'View',
                  //           style: TextStyle(
                  //             color: Colors.yellow,
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  //   duration: Duration(seconds: 10),
                  // );
                }
              },
            ),
            // BlocListener<NetworkBloc, NetworkState>(
            //   listener: (context, state) {
            //     if (state is NetworkSuccess) {
            //       if (state.connected) {
            //         //true there is connection
            //         _scaffoldKey.currentState!.hideCurrentSnackBar();
            //         //hide the snackbar
            //         if (_isOpen) {
            //           _navKey.currentState!.pop();
            //         }
            //       } else {
            //         _show();
            //       }
            //     }
            //   },
            // )
          ],
          child: OverlaySupport(
            child: MaterialApp.router(
              scaffoldMessengerKey: _scaffoldKey,
              debugShowCheckedModeBanner: false,
              routeInformationParser: _appRouter.defaultRouteParser(),
              routerDelegate: _appRouter.delegate(),
              title: "Netbot App",
              theme: Constants.lightTheme,
            ),
          ),
        ),
      );
    });
  }

  void _show() {
    final _context = _navKey.currentState?.overlay?.context;
    _isOpen = true;
    showDialog(
      context: _context ?? context,
      builder: (context) => NetworkDialogue(),
    ).then(
      (value) => _isOpen = false,
    );
  }
}
