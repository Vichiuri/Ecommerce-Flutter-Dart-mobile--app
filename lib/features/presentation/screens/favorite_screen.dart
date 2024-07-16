import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_cart_quantity/get_cart_quantity_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_fav/get_favourites_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/error_paginated.dart';
import 'package:biz_mobile_app/features/presentation/components/error_widget.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:biz_mobile_app/features/presentation/widgets/bottom_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import 'home/widgets/cart_single_widget.dart';
import 'home/widgets/favourite_widget.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with AutomaticKeepAliveClientMixin {
  late final _scrollController = ScrollController();
  late final addBloc = getIt<AddRemoveToFavBloc>();
  late final addToCartBloc = getIt<AddToCartBloc>();
  List<ProductModel> products = [];
  Completer<void>? _refreshCompleter;
  int currentPage = 1;
  int lastPage = 1;
  bool _isUpdating = false;
  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) => {
          context
              .read<GetFavouritesBloc>()
              .add(GetFavouritesStarted(page: 1, products: [])),
          _scrollController.addListener(_onsCroll)
        });
    super.initState();
  }

  @override
  void dispose() {
    addToCartBloc.close();
    addBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  void _onsCroll() {
    late final _maxScroll = _scrollController.position.maxScrollExtent;
    late final _currentScroll = _scrollController.position.pixels;
    if (_currentScroll == _maxScroll) {
      if (currentPage < lastPage) {
        _isUpdating = true;
        context.read<GetFavouritesBloc>().add(
            GetFavouritePaginated(page: currentPage + 1, products: products));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        // BlocProvider(create: (context) => bloc),
        BlocProvider(create: (context) => addBloc),
        BlocProvider(create: (_) => addToCartBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddToCartBloc, AddToCartState>(
            listener: (context, state) {
              if (state is AddToCartSuccess) {
                // context.read<DashboardBloc>()..add(UpdateDashBoardEvent());
                context.read<GetFavouritesBloc>().add(GetFavouritesUpdated());
                context
                    .read<GetCartQuantityBloc>()
                    .add(GetCartQuantityStarted());
                // context.read<DashboardBloc>()..add(UpdateDashBoardEvent());
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                showSimpleNotification(
                  Text(state.message),
                  background: Colors.greenAccent,
                  position: NotificationPosition.bottom,
                  duration: Duration(seconds: 1),
                );
                // Navigator.of(context).pop();
                print("Succeeess yeeeii");
              }
              if (state is AddToCartError) {
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                showSimpleNotification(
                  Text(state.message),
                  background: Colors.red,
                  position: NotificationPosition.bottom,
                );
              }
            },
          ),
          BlocListener<GetFavouritesBloc, GetFavouritesState>(
            listener: (context, state) {
              if (state is GetFavouritesSuccess) {
                _isUpdating = false;
                products = state.products;
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
                currentPage = state.currentPage ?? 1;
                lastPage = state.lastPage ?? 1;

                print("LAST PAGE:${state.lastPage}");
                print("CURRENT PAGE:${state.currentPage}");
              }
              if (state is GetFavouritesPaginatedError) {
                _isUpdating = false;
              }
            },
          ),
          BlocListener<AddRemoveToFavBloc, AddRemoveToFavState>(
            listener: (context, state) {
              if (state is AddRemoveToFavLoading) {
                ScaffoldMessenger.maybeOf(context)!
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoActivityIndicator(),
                          Text(
                            "Processing...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
              }
              if (state is AddRemoveToFavSuccess) {
                print("Success");
                showSimpleNotification(
                  Text(state.message),
                  background: Colors.green,
                  duration: Duration(seconds: 1),
                  position: NotificationPosition.bottom,
                );
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                // context.read<GetFavouritesBloc>().add(GetFavouritesUpdated());
                products.removeWhere((element) => element.id == state.id);
                // context.read<DashboardBloc>()..add(UpdateDashBoardEvent());
              }
              if (state is AddRemoveToFavError) {
                showSimpleNotification(
                  Text(state.message),
                  background: Colors.red,
                  position: NotificationPosition.bottom,
                );
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
              }
            },
          ),
        ],
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: BlocBuilder<GetFavouritesBloc, GetFavouritesState>(
            // buildWhen: (previous, current) {
            //   if (previous ) {

            //   }
            // },
            builder: (context, state1) {
              if (state1 is GetFavouritesLoading) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (state1 is GetFavouritesError) {
                return DashboardErrorWidget(
                  refresh: () => context
                      .read<GetFavouritesBloc>()
                      .add(GetFavouritesStarted(page: 1, products: [])),
                );
              }

              return BlocBuilder<AddToCartBloc, AddToCartState>(
                builder: (context, state) => RefreshIndicator(
                  onRefresh: () {
                    context
                        .read<GetFavouritesBloc>()
                        .add(GetFavouritesUpdated());
                    return _refreshCompleter!.future;
                  },
                  child: products.isEmpty
                      ? SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text("EMPTY"),
                            ),
                          ),
                        )
                      : GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(top: 5),
                          // primary: false,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            childAspectRatio: 2 / 3,
                          ),
                          itemCount: products.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == products.length) {
                              return _isUpdating
                                  ? BottomLoader()
                                  : state1 is GetFavouritesPaginatedError
                                      ? ErrorPaginated(
                                          onRefresh: () {
                                            _isUpdating = true;
                                            context
                                                .read<GetFavouritesBloc>()
                                                .add(GetFavouritePaginated(
                                                    page: currentPage + 1,
                                                    products: products));
                                          },
                                        )
                                      : Opacity(opacity: 0);
                              // return BottomLoader();
                            }
                            return GestureDetector(
                              onTap: () {
                                AutoRouter.of(context).push(
                                  ProductDetailsScreenRoute(
                                    detailsArguments: ProductDetailsArguments(
                                        product: products[index],
                                        initialValue:
                                            products[index].cartQty ?? 0),
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.all(2),
                                elevation: 0,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      fit: FlexFit.tight,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        constraints: BoxConstraints(
                                          minHeight: 50,
                                        ),
                                        child: products[index]
                                                .product_images
                                                .isNotEmpty
                                            ? CachedNetworkImage(
                                                errorWidget: (c, s, o) =>
                                                    Image.asset(
                                                  "assets/images/placeholder.png",
                                                ),
                                                placeholderFadeInDuration:
                                                    Duration(milliseconds: 400),
                                                fadeOutDuration:
                                                    Duration(milliseconds: 400),
                                                imageUrl: IMAGE_URL +
                                                    products[index]
                                                        .product_images[0]
                                                        .image!,
                                                placeholder: (c, s) =>
                                                    Image.asset(
                                                  "assets/images/placeholder.png",
                                                ),
                                              )
                                            : Image.asset(
                                                "assets/images/placeholder.png",
                                              ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      // flex: 1,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                products[index].name ?? "",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              Text(
                                                "${products[index].price_s}",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FavouriteWidget(
                                            isFav:
                                                products[index].isFavourite ??
                                                    false,
                                            id: products[index].id,
                                          ),
                                          CartSingleWidget(
                                            product: products[index],
                                            cartQty:
                                                products[index].cartQty ?? 0,
                                            id: products[index].id,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
