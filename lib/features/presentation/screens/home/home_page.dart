import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/data/datasourse/local/local_data_source.dart';
import 'package:biz_mobile_app/features/data/responses/DashBoardResponse.dart';
import 'package:biz_mobile_app/features/domain/models/Category/CategoryModel.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/fetch_current_distributor/fetch_current_distributor_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_cart_quantity/get_cart_quantity_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_fav/get_favourites_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/main/main_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/recent_buy/recent_bought_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/splash/splash_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/top_product/top_product_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/back_ground.dart';
import 'package:biz_mobile_app/features/presentation/components/bottom_bar.dart';
import 'package:biz_mobile_app/features/presentation/screens/cart.dart';
import 'package:biz_mobile_app/features/presentation/screens/favorite_screen.dart';
import 'package:biz_mobile_app/features/presentation/screens/home/widgets/home_widget.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:biz_mobile_app/features/presentation/widgets/more.dart';
import 'package:biz_mobile_app/features/presentation/widgets/notification_badge.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_support/overlay_support.dart';

//home page that holds the widgets
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  //*Variables
  int cartQuantity = 0;
  String currentDist = "";
  int distId = 0;
  DateTime? _currentBackPressTime;
  int _selectedIndex = 0;
  String _salesmandist = "";
  final _fcm = FirebaseMessaging.instance;
  String text = "";
  final _pageController = PageController();
  String _selectedRetailer = "";
  bool _isLoading = false;

  //*home

  List<CategoryModel> categoryModel = [];
  DashBoardResponse response =
      DashBoardResponse(banners: [], products: [], categories: [], offers: []);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fcm.getToken().then((value) => print("FCM TOKENS: ${value ?? " "}"));

    //* handle app from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("Title: ${message.notification!.title}");
        print("Body: ${message.notification!.body}");
        print("STATUS: ${message.data['status']}");
        // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});

        if (message.data['status'] == "Product") {
          AutoRouter.of(context).push(
            ProductDetailsScreenRoute(
                detailsArguments: ProductDetailsArguments(
              product: null,
              initialValue: 0,
              id: int.parse(message.data['product']),
            )),
          );
        } else if (message.data['status'] == "Offer") {
          AutoRouter.of(context).push(OfferDetailScreenRoute(
              offerId: int.parse(message.data['offer'])));
        } else if (message.data['status'] == "Order") {
          AutoRouter.of(context).push(
              OrderHistoryRoute(orderId: int.parse(message.data['order'])));
        } else {
          AutoRouter.of(context).push(NotificationsRoute());
          print("Notifications");
        }
      }
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          print("Title: ${message.notification!.title}");
          print("Body: ${message.notification!.body}");
          print("DATA: ${message.data}");
          print("STATUS: ${message.data['status']}");

          showSimpleNotification(
            Text(message.notification?.title ?? ""),
            subtitle: Text(
              message.notification?.body ?? "",
              style: TextStyle(fontSize: 11),
            ),
            // ignore: deprecated_member_use
            slideDismiss: true,
            position: NotificationPosition.top,
            // background: Theme.of(context).accentColor,
            autoDismiss: true,
            // ignore: deprecated_member_use
            //slideDismiss: true,
            trailing: Builder(
              builder: (context) {
                return TextButton(
                  // textColor:
                  onPressed: () {
                    if (message.data['status'] == "Product") {
                      AutoRouter.of(context).push(
                        ProductDetailsScreenRoute(
                            detailsArguments: ProductDetailsArguments(
                          product: null,
                          initialValue: 0,
                          id: int.parse(
                              // state.model.singleNotification!.product,
                              message.data['product']),
                        )),
                      );
                    } else if (message.data['status'] == "Offer") {
                      AutoRouter.of(context).push(OfferDetailScreenRoute(
                          offerId: int.parse(message.data['offer']
                              // state.model.singleNotification!.offer,
                              )));
                    } else if (message.data['status'] == "Order") {
                      AutoRouter.of(context).push(OrderHistoryRoute(
                          orderId: int.parse(message.data['order'])));
                    } else {
                      AutoRouter.of(context).push(NotificationsRoute());
                      print("Notifications");
                    }
                  },
                  child: Text(
                    'View',
                    style: TextStyle(
                      color: Colors.yellow,
                    ),
                  ),
                );
              },
            ),
            duration: Duration(seconds: 10),
          );
        }
      },
    );

    //* Also handle any interaction when the app is in the background via a
    //* Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          print("Title: ${message.notification!.title}");
          print("Body: ${message.notification!.body}");
          print("STATUS: ${message.data['status']}");

          if (message.data['status'] == "Product") {
            AutoRouter.of(context).push(
              ProductDetailsScreenRoute(
                  detailsArguments: ProductDetailsArguments(
                product: null,
                initialValue: 0,
                id: int.parse(message.data['product']),
              )),
            );
          } else if (message.data['status'] == "Offer") {
            AutoRouter.of(context).push(OfferDetailScreenRoute(
                offerId: int.parse(message.data['offer'])));
          } else if (message.data['status'] == "Order") {
            AutoRouter.of(context).push(
                OrderHistoryRoute(orderId: int.parse(message.data['order'])));
          } else {
            AutoRouter.of(context).push(NotificationsRoute());
            print("Notifications");
          }
        }
      },
    );

    //*Blocs
    // WidgetsBinding.instance?.addPostFrameCallback(
    //   (timeStamp) => context.read<DashboardBloc>()..add(FetchDashBoardEvent()),
    // );
    // _categoryBloc.add(GetCategoryStarted());
    // _favBloc.add(GetFavouritesStarted());
    // _cartBloc.add(FetchCartEvent());

    //*appbar
    _getDistName();
    _favBloc.add(GetFavouritesStarted(page: 1, products: []));
  }

  @override
  void dispose() {
    super.dispose();
    _addBloc.close();
    // _categoryBloc.close();
    _favBloc.close();
    _cartBloc.close();

    _pageController.dispose();

    // _categoryBloc.close();
    // _productPaginated.close();
    // _newArrivalsBloc.close();
    // _getBannerBloc.close();
    _addToFavBloc.close();
    _addToCart.close();

    // _getOfferBloc.close();
  }

  late final _addToFavBloc = getIt<AddRemoveToFavBloc>();
  late final _addToCart = getIt<AddToCartBloc>();
  late final _addBloc = getIt<AddRemoveToFavBloc>();
  late final _favBloc = getIt<GetFavouritesBloc>();
  late final _cartBloc = getIt<MainBloc>();

  bool _salesman = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.read<GetCartQuantityBloc>()..add(GetCartQuantityStarted());
    context.read<FetchCurrentDistributorBloc>()..add(FetchCurrentStarted());
    context.read<NotificationsBloc>().add(GetNotificationStarted());

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _favBloc),
        BlocProvider(create: (context) => _addBloc),
        BlocProvider(create: (create) => _addToFavBloc),
        BlocProvider(create: (create) => _addToCart),
      ],
      child: MultiBlocListener(
        listeners: [
          //*Dashboard
          BlocListener<DashboardBloc, DashboardState>(
            listener: (context, state) {
              if (state is DashBoardLoaded) {
                // _keyRefresh.currentState?
                response = state.response;
              }
            },
          ),
          //*Categories
          // BlocListener<GetCategoryBloc, GetCategoryState>(
          //   listener: (context, state) {
          //     if (state is GetCategorySuccess) {
          //       categoryModel = state.response.categories;
          //     }
          //   },
          // ),
          //*Distributor
          BlocListener<FetchCurrentDistributorBloc,
              FetchCurrentDistributorState>(
            listener: (context, state) {
              if (state is FetchCurrentDistributorSuccess) {
                currentDist = state.distributor?.name ?? _salesmandist;
                distId = state.distributor?.id ?? state.retailerModel?.id ?? 0;
              }
              if (state is FetchCurrentDistributorError) {
                currentDist = "Netbot";
              }
            },
          ),
          //*Add Remove To Fav

          //*Logged Out
          BlocListener<SplashBloc, SplashState>(
            listener: (context, state) {
              if (state is SplashToLogin) {
                AutoRouter.of(context).replace(LoginPageRoute());
                // _navKey.currentContext?.router.replace(LoginPageRoute());
              }
            },
          ),
          //*Splash Quantity
          BlocListener<GetCartQuantityBloc, GetCartQuantityState>(
            listener: (context, state) {
              if (state is GetCartQuantitySuccess) {
                cartQuantity = state.cartQuantity.quantity;
              }
              if (state is GetCartQuantityError) {
                if (state.message == UNAUTHENTICATED_FAILURE_MESSAGE) {
                  context.read<SplashBloc>()..add(LogoutEvent());
                }
              }
            },
          ),
        ],
        //*WillPopScope
        child: WillPopScope(
          onWillPop: () => Future.value(_onWilPop()),
          child: Scaffold(
            // backgroundColor: Colors.grey[200],
            // extendBody: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: BlocBuilder<FetchCurrentDistributorBloc,
                  FetchCurrentDistributorState>(
                builder: (context, state) {
                  return Text(
                    currentDist.toUpperCase(),
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: BlocBuilder<NotificationsBloc, NotificationsState>(
                    builder: (context, state) {
                      if (state is NotificationsSuccess) {
                        text = state.response.notifications.length.toString();
                      }
                      return NotificationIconBadge(
                        icon: Icons.notifications,
                        size: 22.0,
                        text: text,
                      );
                    },
                  ),
                  onPressed: () {
                    AutoRouter.of(context).push(NotificationsRoute());
                  },
                  tooltip: "Notifications",
                ),
              ],
            ),
            body: BackGroundWidget(
              child: Column(
                children: [
                  BlocBuilder<FetchCurrentDistributorBloc,
                      FetchCurrentDistributorState>(
                    builder: (context, state) {
                      if (state is FetchCurrentDistributorSuccess) {
                        if (state.retailerModel != null) {
                          return Container(
                            margin: EdgeInsets.all(2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Current Retailer:",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "${state.retailerModel?.name}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            // : DropdownButton<RetailerModel>(
                            //     value: _singleRet,
                            //     hint: Text("Select Retailer"),
                            //     onChanged: (ret) {
                            //       _singleRet = ret;
                            //       _distributorBloc
                            //           .add(ChangeDistributorEvent(
                            //         distributorId: ret!.id,
                            //       ));
                            //     },
                            //     items: _retailers
                            //         .map((e) =>
                            //             DropdownMenuItem<RetailerModel>(
                            //               child: Text(e.name),
                            //               value: e,
                            //             ))
                            //         .toList(),
                            //   ),
                          );
                        }

                        // Text("${state.retailerModel?.name}")
                        return Opacity(opacity: 0);
                      }
                      return Opacity(opacity: 0);
                    },
                  ),
                  Expanded(
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      // pageSnapping: ,
                      children: [
                        HomeWidget(),
                        FavoriteScreen(),
                        CartScreen(
                          salesmam: _salesman,
                          goToHome: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                            _pageController.jumpToPage(0);
                          },
                        ),
                        NavDrawer(),
                      ],
                      onPageChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              elevation: 4.0,
              child: Icon(
                Icons.search,
              ),
              onPressed: () => {
                print("Search"),
                // AutoRouter.of(context).push(SearchScreenRoute())
                AutoRouter.of(context).push(ViewMoreScreenRoute())
              },
            ),
            bottomNavigationBar:
                BlocBuilder<GetCartQuantityBloc, GetCartQuantityState>(
              builder: (context, state) {
                // return BottomAppBar(
                //   shape: CircularNotchedRectangle(),
                //   clipBehavior: Clip.antiAlias,
                //   notchMargin: 5,
                //   child: BottomNavigationBar(
                //     currentIndex: _selectedIndex,
                //     onTap: _onItemTapped,
                //     selectedItemColor: Colors.blue,
                //     unselectedItemColor: Colors.grey,
                //     items: [
                //       BottomNavigationBarItem(
                //         icon: Icon(Icons.home),
                //         label: "Home",
                //       ),
                //       BottomNavigationBarItem(
                //         icon: Icon(Icons.favorite),
                //         label: "Favourites",
                //       ),
                //       BottomNavigationBarItem(
                //         label: "Cart",
                //         icon: CartIconBadge(
                //           icon: Icons.shopping_cart,
                //           qty: cartQuantity,
                //           size: 24,
                //         ),
                //       ),
                //       BottomNavigationBarItem(
                //         icon: Icon(Icons.person),
                //         label: "Account",
                //       ),
                //     ],
                //   ),
                // );
                return FABBottomAppBar(
                  currentIndex: _selectedIndex,
                  selectedColor: Colors.blue,
                  color: Colors.grey,
                  notchedShape: CircularNotchedRectangle(),
                  onTabSelected: _onItemTapped,
                  items: [
                    FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
                    FABBottomAppBarItem(
                        iconData: Icons.favorite, text: 'Favourites'),
                    FABBottomAppBarItem(
                      iconData: Icons.shopping_cart,
                      text: 'Cart',
                      badget: true,
                      qty: cartQuantity,
                    ),
                    FABBottomAppBarItem(
                        iconData: Icons.person, text: 'Account'),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _getDistName() async {
    final _name = await getIt<LocalDataSource>().getSalesmanDistributor();

    setState(() {
      _salesmandist = _name?.name ?? "";
    });
  }

  //tap twice to exit app
  bool _onWilPop() {
    DateTime now = DateTime.now();
    if (_selectedIndex == 0) {
      if (_currentBackPressTime == null ||
          now.difference(_currentBackPressTime!) > Duration(seconds: 1)) {
        _currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Tap Again To Exit");
        return false;
      }
      return true;
    } else {
      setState(() {
        _selectedIndex = 0;
      });
      _pageController.jumpToPage(0);
      return false;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }
}
