// import 'package:restaurant_ui_kit/screens/sales/retailer.dart';
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/features/domain/models/Cart/salesman_cart_model.dart';
import 'package:biz_mobile_app/features/presentation/bloc/new_arrivals/new_arrivals_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/place_order/place_order_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/product_paginated/product_paginated_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/checkout_args.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/Order/OrderModel.dart';
import 'package:biz_mobile_app/features/presentation/bloc/delete_cart/delete_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/distributor/distributor_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_cart_quantity/get_cart_quantity_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/main/main_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/refresh_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key, this.goToHome, required this.salesmam})
      : super(key: key);
  final bool salesmam;

  @override
  _CartScreenState createState() => _CartScreenState();
  // final CartResponse? cartResponse;
  // final MainBloc bloc;
  final VoidCallback? goToHome;
}

//TODO cart offline message

Completer<void> _refreshCompleter = new Completer<void>();

class _CartScreenState extends State<CartScreen> {
  // CartModel? cart;
  late final mainBloc = getIt<MainBloc>();
  late final bloc = getIt<DeleteCartBloc>();
  late final _distBloc = getIt<DistributorBloc>();
  late final _scrollController = ScrollController();
  late final _placeOrderBloc = getIt<PlaceOrderBloc>();

  String _total = "";
  List<OrderModel> _orders = [];
  List<SalesManCartModel> _salesmanCart = const [];
  double _maxScroll = 0.0;

  @override
  void initState() {
    mainBloc.add(FetchCartEvent());
    // _scrollController.addListener(_findPosition);
    _distBloc.add(FetchDistributorEvent());
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    mainBloc.close();
    super.dispose();
    _distBloc.close();
    // _scrollController.removeListener(_findPosition);
    _scrollController.dispose();
    _placeOrderBloc.close();
  }

  // void _findPosition() {
  //   print("SCROLLPOSITION" + _scrollController.position.pixels.toString());
  //   _maxScroll = _scrollController.position.maxScrollExtent;
  // }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    print("MAX SCROLL: $_maxScroll");
    print("SCREEN HEIGHT: $_height");
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => mainBloc),
        BlocProvider(create: (BuildContext context) => bloc),
        BlocProvider(create: (create) => _placeOrderBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<PlaceOrderBloc, PlaceOrderState>(
            listener: (context, state) {
              if (state is PlaceOrderLoading) {
                ScaffoldMessenger.maybeOf(context)!
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      duration: Duration(minutes: 10),
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularProgressIndicator.adaptive(),
                          Text(
                            "Placing order...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
              }
              if (state is PlaceOrderSuccess) {
                mainBloc.add(FetchCartEvent());
                context.read<GetCartQuantityBloc>()
                  ..add(GetCartQuantityStarted());

                // context.read<GetBannersBloc>().add(GetBannerUpdate());
                // context.read<GetOfferBloc>().add(GetOfferUpdate());
                // context.read<GetCategoryBloc>().add(GetCategoryUpdate(page: 1));
                context.read<ProductPaginatedBloc>().add(
                    GetProductPaginatedUpdate(
                        product: [], position: 0, page: 1));
                context
                    .read<NewArrivalsBloc>()
                    .add(UpdateNewArrivals(product: [], position: 0, page: 1));
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                showSimpleNotification(
                  Text(state.message),
                  position: NotificationPosition.bottom,
                  background: Colors.greenAccent,
                );
              }
              if (state is PlaceOrderError) {
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                showSimpleNotification(
                  Text(state.message),
                  background: Colors.red,
                  position: NotificationPosition.bottom,
                );
              }
            },
          ),
          BlocListener<MainBloc, MainState>(
            listener: (context, state) {
              if (state is MainLoadedState) {
                _refreshCompleter.complete();
                _refreshCompleter = Completer();
                // cart = state.cartResponse.cart;

                // if (state.cartResponse.salesmanCart.isNotEmpty) {
                _salesmanCart = state.cartResponse.salesmanCart;
                // return;s
                // }
                _orders = state.cartResponse.cart?.orders ?? [];
                _total = state.cartResponse.cart?.total ?? "";
              }
            },
          ),
          BlocListener<DeleteCartBloc, DeleteCartState>(
            listener: (context, state) {
              if (state is DeleteCartLoading) {
                ScaffoldMessenger.maybeOf(context)!
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularProgressIndicator.adaptive(),
                          Text(
                            "Processing...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
              }
              if (state is DeleteCartSuccess) {
                // context.read<GetBannersBloc>().add(GetBannerUpdate());
                // context.read<GetOfferBloc>().add(GetOfferUpdate());
                // context.read<GetCategoryBloc>().add(GetCategoryUpdate(page: 1));
                _orders.removeWhere((element) => element.id == state.id);
                mainBloc.add(UpdateCartEvent());
                context.read<ProductPaginatedBloc>().add(
                    GetProductPaginatedUpdate(
                        product: [], position: 0, page: 1));
                context
                    .read<NewArrivalsBloc>()
                    .add(UpdateNewArrivals(product: [], position: 0, page: 1));
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                // mainBloc.add(FetchCartEvent());
                showSimpleNotification(
                  Text(state.message),
                  position: NotificationPosition.bottom,
                  background: Colors.green,
                );
                context
                    .read<GetCartQuantityBloc>()
                    .add(GetCartQuantityStarted());
              }
              if (state is DeleteCartError) {
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                showSimpleNotification(
                  Text(state.message),
                  position: NotificationPosition.bottom,
                  background: Colors.red,
                );
              }
            },
          )
        ],
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, mainState) {
            if (mainState is MainLoadingState) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (mainState is MainInitial) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            return RefreshWidget(
              onRefresh: () {
                mainBloc.add(UpdateCartEvent());
                return _refreshCompleter.future;
              },
              child: Column(
                children: [
                  _orders.isEmpty && _salesmanCart.isEmpty
                      ? Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: GestureDetector(
                            onTap: widget.goToHome,
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Container(
                                      child: Lottie.asset(
                                        "assets/lottie/cart_empty.json",
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "NO ITEMS",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "Lets Go Shopping",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            child: Column(
                              children: [
                                //!LIST
                                BlocBuilder<DeleteCartBloc, DeleteCartState>(
                                  builder: (context, deleteState) =>
                                      _salesmanCart.isNotEmpty
                                          //!SALESMANNNNNN
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: _salesmanCart.length,
                                              itemBuilder: (c, index) {
                                                return Card(
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            _salesmanCart[index]
                                                                .retailer
                                                                .name
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green),
                                                          ),
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            _salesmanCart[index]
                                                                .cart
                                                                .orders
                                                                .length,
                                                        itemBuilder: (c, i) {
                                                          final _order =
                                                              _salesmanCart[
                                                                      index]
                                                                  .cart
                                                                  .orders[i];
                                                          return Container(
                                                            width:
                                                                double.infinity,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                              vertical: 2,
                                                              horizontal: 5,
                                                            ),
                                                            child: InkWell(
                                                              splashColor: Colors
                                                                  .blue
                                                                  .withOpacity(
                                                                      0.3),
                                                              enableFeedback:
                                                                  true,
                                                              excludeFromSemantics:
                                                                  false,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onLongPress: () {
                                                                print(
                                                                    "SELECTED HII ORDER");
                                                              },
                                                              onTap: () {
                                                                _order.applied_offer !=
                                                                        null
                                                                    ? AutoRouter.of(
                                                                            context)
                                                                        .push(
                                                                            OfferDetailScreenRoute(
                                                                          offerId:
                                                                              _order.offer_id ?? 0,
                                                                          initialQuantity: (_order.total_qty! - _order.free_qty!) == 0
                                                                              ? _order.total_qty
                                                                              : (_order.total_qty! - _order.free_qty!),
                                                                        ))
                                                                        .then((value) =>
                                                                            mainBloc.add(
                                                                                UpdateCartEvent()))
                                                                    : AutoRouter.of(
                                                                            context)
                                                                        .push(
                                                                            ProductDetailsScreenRoute(
                                                                          detailsArguments:
                                                                              ProductDetailsArguments(
                                                                            product:
                                                                                _order.product,
                                                                            initialValue:
                                                                                _order.qty,
                                                                          ),
                                                                        ))
                                                                        .then((value) =>
                                                                            mainBloc.add(UpdateCartEvent()));
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Flexible(
                                                                        flex: 1,
                                                                        child:
                                                                            Container(
                                                                          margin:
                                                                              EdgeInsets.all(5),
                                                                          child: _order.product.product_images.isEmpty
                                                                              ? Image.asset("assets/images/placeholder.png")
                                                                              : CachedNetworkImage(
                                                                                  imageUrl: IMAGE_URL + _order.product.product_images.first.image!,
                                                                                  placeholder: (c, s) => Image.asset("assets/images/placeholder.png"),
                                                                                  errorWidget: (c, s, o) => Image.asset("assets/images/placeholder.png"),
                                                                                ),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        flex: 3,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "${_order.product.name}",
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              "Price Per Item: ${_order.pricePer ?? ""}",
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                            ),
                                                                            _order.applied_offer != null
                                                                                ? Container(
                                                                                    child: Text(
                                                                                      "Offer: " + _order.applied_offer.toString(),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      maxLines: 2,
                                                                                      style: TextStyle(
                                                                                        fontSize: 11.0,
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : Container(),
                                                                            _order.applied_offer != null
                                                                                ? (_order.total_qty! - _order.free_qty!) == 0
                                                                                    ? Text(
                                                                                        "Ordered Quantity: " + _order.qty.toString(),
                                                                                        style: TextStyle(
                                                                                          fontSize: 11.0,
                                                                                          fontWeight: FontWeight.w300,
                                                                                        ),
                                                                                      )
                                                                                    : Text(
                                                                                        "Ordered Quantity: " + (_order.total_qty! - _order.free_qty!).toString(),
                                                                                        style: TextStyle(
                                                                                          fontSize: 11.0,
                                                                                          fontWeight: FontWeight.w300,
                                                                                        ),
                                                                                      )
                                                                                : Container(),
                                                                            _order.free_qty != null && _order.free_qty != 0
                                                                                ? Text(
                                                                                    "Free Quantity: " + _order.free_qty!.toString(),
                                                                                    style: TextStyle(
                                                                                      fontSize: 11.0,
                                                                                      fontWeight: FontWeight.w300,
                                                                                    ),
                                                                                  )
                                                                                : Container(),
                                                                            Text(
                                                                              "Total Quantity: " + _order.qty.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 11.0,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text.rich(
                                                                                  TextSpan(children: [
                                                                                    TextSpan(
                                                                                      text: "Total Price: ",
                                                                                      style: TextStyle(
                                                                                        fontSize: 11.0,
                                                                                        fontWeight: FontWeight.w300,
                                                                                      ),
                                                                                    ),
                                                                                    TextSpan(
                                                                                      text: _order.order_price,
                                                                                      style: TextStyle(
                                                                                        fontSize: 11.0,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: Theme.of(context).accentColor,
                                                                                      ),
                                                                                    )
                                                                                  ]),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.zero,
                                                                                  child: IconButton(
                                                                                    onPressed: () => showDialog(
                                                                                      context: context,
                                                                                      builder: (builder) => AlertDialog(
                                                                                        title: Text("DELETE"),
                                                                                        content: Text("Are you sure you want to delete?"),
                                                                                        actions: [
                                                                                          TextButton(
                                                                                            onPressed: () => Navigator.of(context).pop(),
                                                                                            child: Text("CANCEL"),
                                                                                          ),
                                                                                          TextButton(
                                                                                            onPressed: () => Navigator.of(context).pop(true),
                                                                                            child: Text(
                                                                                              "DELETE",
                                                                                              style: TextStyle(color: Colors.red),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ).then((value) {
                                                                                      if (value != null && value) {
                                                                                        // bloc.add(DeleteCartPressed(ret: _orders[i].retailerModel, prod: _orders[i].product, orderId: _orders[i].id));
                                                                                        bloc.add(DeleteCartPressed(orderId: _order.id, prod: _order.product, ret: _salesmanCart[index].retailer.id));
                                                                                      }
                                                                                    }).catchError((e, s) {
                                                                                      print("$e,$s");
                                                                                    }),
                                                                                    iconSize: 20,
                                                                                    icon: Icon(Icons.delete),
                                                                                    color: Colors.red,
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              _salesmanCart[
                                                                          index]
                                                                      .cart
                                                                      .total ??
                                                                  "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                            MaterialButton(
                                                              color:
                                                                  Colors.blue,
                                                              onPressed: () {
                                                                if (_salesmanCart
                                                                    .isEmpty) {
                                                                  showSimpleNotification(
                                                                    Text(
                                                                        "No Items in cart"),
                                                                    background:
                                                                        Colors
                                                                            .red,
                                                                    position:
                                                                        NotificationPosition
                                                                            .bottom,
                                                                  );
                                                                  return;
                                                                }
                                                                if (_salesmanCart[index]
                                                                            .cart
                                                                            .total ==
                                                                        null ||
                                                                    _salesmanCart[index]
                                                                            .cart
                                                                            .total!
                                                                            .toLowerCase() ==
                                                                        "offline") {
                                                                  showSimpleNotification(
                                                                    Text(
                                                                        "Cant place cart offline"),
                                                                    background:
                                                                        Colors
                                                                            .red,
                                                                    position:
                                                                        NotificationPosition
                                                                            .bottom,
                                                                  );
                                                                  return;
                                                                }
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (builder) =>
                                                                      PlaceOrderDialog(
                                                                          total:
                                                                              _salesmanCart[index].cart.total ?? ""),
                                                                ).then((value) {
                                                                  if (value !=
                                                                          null &&
                                                                      value
                                                                          .ok) {
                                                                    _placeOrderBloc
                                                                        .add(
                                                                            PlaceOrderStarted(
                                                                      retId: _salesmanCart[
                                                                              index]
                                                                          .retailer
                                                                          .id,
                                                                      notes: value
                                                                          .notes,
                                                                    ));
                                                                    print(value
                                                                        .notes);
                                                                    // _notes.clear()
                                                                  }
                                                                }).catchError(
                                                                    (e, s) {
                                                                  print(
                                                                      "ERROR PLACING SALESMAN ORDERS");
                                                                });
                                                              },
                                                              child: Text(
                                                                "PLACE ORDER",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            )

                                          //!RETAILERSs

                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: _orders.length,
                                              itemBuilder: (c, i) => Card(
                                                elevation: 0,
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 2,
                                                  horizontal: 5,
                                                ),
                                                child: InkWell(
                                                  splashColor: Colors.blue
                                                      .withOpacity(0.3),
                                                  enableFeedback: true,
                                                  excludeFromSemantics: false,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onLongPress: () {
                                                    print("SELECTED HII ORDER");
                                                  },
                                                  onTap: () {
                                                    _orders[i].applied_offer !=
                                                            null
                                                        ? AutoRouter.of(context)
                                                            .push(
                                                                OfferDetailScreenRoute(
                                                              offerId: _orders[
                                                                          i]
                                                                      .offer_id ??
                                                                  0,
                                                              initialQuantity: (_orders[i]
                                                                              .total_qty! -
                                                                          _orders[i]
                                                                              .free_qty!) ==
                                                                      0
                                                                  ? _orders[i]
                                                                      .total_qty
                                                                  : (_orders[i]
                                                                          .total_qty! -
                                                                      _orders[i]
                                                                          .free_qty!),
                                                            ))
                                                            .then((value) =>
                                                                mainBloc.add(
                                                                    UpdateCartEvent()))
                                                        : AutoRouter.of(context)
                                                            .push(
                                                                ProductDetailsScreenRoute(
                                                              detailsArguments:
                                                                  ProductDetailsArguments(
                                                                product:
                                                                    _orders[i]
                                                                        .product,
                                                                initialValue:
                                                                    _orders[i]
                                                                        .qty,
                                                              ),
                                                            ))
                                                            .then((value) =>
                                                                mainBloc.add(
                                                                    UpdateCartEvent()));
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        // height: 120,
                                                        width: double.infinity,
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              flex: 1,
                                                              child: Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: _orders[
                                                                            i]
                                                                        .product
                                                                        .product_images
                                                                        .isEmpty
                                                                    ? Image.asset(
                                                                        "assets/images/placeholder.png")
                                                                    : CachedNetworkImage(
                                                                        imageUrl:
                                                                            IMAGE_URL +
                                                                                _orders[i].product.product_images.first.image!,
                                                                        placeholder:
                                                                            (c, s) =>
                                                                                Image.asset("assets/images/placeholder.png"),
                                                                        errorWidget: (c,
                                                                                s,
                                                                                o) =>
                                                                            Image.asset("assets/images/placeholder.png"),
                                                                      ),
                                                              ),
                                                            ),
                                                            Flexible(
                                                              flex: 3,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${_orders[i].product.name}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Price Per Item: ${_orders[i].pricePer ?? ""}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  ),
                                                                  _orders[i].applied_offer !=
                                                                          null
                                                                      ? Container(
                                                                          child:
                                                                              Text(
                                                                            "Offer: " +
                                                                                _orders[i].applied_offer.toString(),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                2,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 11.0,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                  _orders[i].applied_offer !=
                                                                          null
                                                                      ? (_orders[i].total_qty! - _orders[i].free_qty!) ==
                                                                              0
                                                                          ? Text(
                                                                              "Ordered Quantity: " + _orders[i].qty.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 11.0,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                            )
                                                                          : Text(
                                                                              "Ordered Quantity: " + (_orders[i].total_qty! - _orders[i].free_qty!).toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 11.0,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                            )
                                                                      : Container(),
                                                                  _orders[i].free_qty !=
                                                                              null &&
                                                                          _orders[i].free_qty !=
                                                                              0
                                                                      ? Text(
                                                                          "Free Quantity: " +
                                                                              _orders[i].free_qty!.toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11.0,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                  Text(
                                                                    "Total Quantity: " +
                                                                        _orders[i]
                                                                            .qty
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text.rich(
                                                                        TextSpan(
                                                                            children: [
                                                                              TextSpan(
                                                                                text: "Total Price: ",
                                                                                style: TextStyle(
                                                                                  fontSize: 11.0,
                                                                                  fontWeight: FontWeight.w300,
                                                                                ),
                                                                              ),
                                                                              TextSpan(
                                                                                text: _orders[i].order_price,
                                                                                style: TextStyle(
                                                                                  fontSize: 11.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Theme.of(context).accentColor,
                                                                                ),
                                                                              )
                                                                            ]),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        child:
                                                                            IconButton(
                                                                          onPressed: () =>
                                                                              showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (builder) =>
                                                                                AlertDialog(
                                                                              title: Text("DELETE"),
                                                                              content: Text("Are you sure you want to delete?"),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.of(context).pop(),
                                                                                  child: Text("CANCEL"),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.of(context).pop(true),
                                                                                  child: Text(
                                                                                    "DELETE",
                                                                                    style: TextStyle(color: Colors.red),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ).then((value) {
                                                                            if (value != null &&
                                                                                value) {
                                                                              bloc.add(DeleteCartPressed(ret: null, prod: _orders[i].product, orderId: _orders[i].id));
                                                                            }
                                                                          }).catchError((e, s) {
                                                                            print("$e,$s");
                                                                          }),
                                                                          iconSize:
                                                                              20,
                                                                          icon:
                                                                              Icon(Icons.delete),
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: Icon(
                                                            Icons.check_circle,
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  _orders.isEmpty
                      ? Opacity(opacity: 0)
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                    text: "Total Price: ",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  TextSpan(
                                    text: mainState is UpdateLoadingState
                                        ? "Updating..."
                                        : _total,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  )
                                ]),
                              ),
                              MaterialButton(
                                child: Text(
                                  "CHECKOUT",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  if (_orders.isEmpty) {
                                    showSimpleNotification(
                                      Text("No Items in cart"),
                                      background: Colors.red,
                                      position: NotificationPosition.bottom,
                                    );
                                    return;
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (builder) =>
                                        PlaceOrderDialog(total: _total),
                                  ).then((value) {
                                    if (value != null && value.ok) {
                                      _placeOrderBloc.add(PlaceOrderStarted(
                                          retId: null, notes: value.notes));
                                      print(value.notes);
                                      // _notes.clear()
                                    }
                                  }).catchError((e, s) {
                                    print("ERROR PLACING ORDERS");
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlaceOrderDialog extends StatefulWidget {
  const PlaceOrderDialog({
    Key? key,
    required String total,
  })  : _total = total,
        super(key: key);

  final String _total;

  @override
  _PlaceOrderDialogState createState() => _PlaceOrderDialogState();
}

class _PlaceOrderDialogState extends State<PlaceOrderDialog> {
  late final TextEditingController _notes = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _notes.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("PLACE ORDER"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Total Price: ",
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                TextSpan(
                  text: widget._total,
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).accentColor,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5),
          TextField(
            controller: _notes,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[100],
              hintText: "Enter Notes",
            ),
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "CANCEL",
            style: TextStyle(
              color: Colors.red,
              letterSpacing: 1,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            CheckoutArgs(
              notes: _notes.text.trim(),
              ok: true,
            ),
          ),
          child: Text(
            "PLACE ORDER",
            style: TextStyle(
              color: Colors.green,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
