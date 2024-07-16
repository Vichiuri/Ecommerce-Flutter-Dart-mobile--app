import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/new_arrivals/new_arrivals_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/search_product/search_product_bloc.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:biz_mobile_app/features/presentation/widgets/cart_icon_badge.dart';
import 'package:biz_mobile_app/features/presentation/widgets/search/product_search_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:overlay_support/overlay_support.dart';

import 'home/widgets/cart_single_widget.dart';
import 'home/widgets/favourite_widget.dart';

class NewArrivalScreen extends StatefulWidget {
  const NewArrivalScreen({Key? key}) : super(key: key);

  @override
  _NewArrivalScreenState createState() => _NewArrivalScreenState();
}

class _NewArrivalScreenState extends State<NewArrivalScreen> {
  late final _newArrivalsBloc = getIt<NewArrivalsBloc>();
  late final _addToFavBloc = getIt<AddRemoveToFavBloc>();
  late final _addSingleToCartBloc = getIt<AddToCartBloc>();
  late final _searchBloc = getIt<SearchProductBloc>();

  static const _pageSize = 10;
  List<ProductModel> _arrivals = [];
  Completer<void> _refreshCompleter = Completer<void>();
  int? _lastPage;
  int? _nextPage;

  final PagingController<int, ProductModel> _pagingController =
      PagingController(firstPageKey: 1);
  // List<bool> _isFav = [];
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(
      (pageKey) => _newArrivalsBloc.add(GetNewArrivalePaginatedEvent(
          page: pageKey, product: _arrivals, position: pageKey.toDouble())),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
    _addToFavBloc.close();
    _newArrivalsBloc.close();
    _addSingleToCartBloc.close();
    _searchBloc.close();
  }

  // _fetchPage(int pageKey) {
  //   final _last = _arrivals.length < _pageSize;
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => _newArrivalsBloc),
        BlocProvider(create: (create) => _addToFavBloc),
        BlocProvider(create: (create) => _addSingleToCartBloc),
        BlocProvider(create: (create) => _searchBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          //*ADD TO CART
          BlocListener<AddToCartBloc, AddToCartState>(
            listener: (context, state) {
              if (state is AddToCartSuccess) {
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
          BlocListener<AddRemoveToFavBloc, AddRemoveToFavState>(
            listener: (context, state) {
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
          BlocListener<NewArrivalsBloc, NewArrivalsState>(
            listener: (context, state) {
              if (state is NewArrivalsSuccess) {
                _arrivals = state.response.products;
                _lastPage = state.response.lastPage;

                final _next = 1 + state.response.currentPage!;
                // _isFav = _arrivals.map((e) => e.isFavourite ?? false).toList();
                if (_next > _lastPage!) {
                  _pagingController.appendLastPage(_arrivals);
                } else {
                  _pagingController.appendPage(_arrivals, _next);
                }

                _refreshCompleter.complete();
                _refreshCompleter = Completer();
              }
              if (state is NewArrivalsError) {
                _pagingController.error = state.error;
                _refreshCompleter.complete();
                _refreshCompleter = Completer();
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text("New Arrivals"),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => showSearch<ProductModel?>(
                    context: context,
                    delegate: ProductSearchDelegate(
                      bloc: _searchBloc,
                      isNewArrival: true,
                      searchFieldLabel: "Search New Arrivals",
                    )).then((value) {
                  if (value != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                        detailsArguments: ProductDetailsArguments(
                          product: value,
                          initialValue: value.cartQty ?? 0,
                        ),
                      ),
                    ));
                  }
                }).catchError((e, s) {
                  print("SEARCH DELEGATE ERROR: $e,$s");
                }),
                icon: Icon(Icons.search),
              )
            ],
          ),
          body: BlocBuilder<NewArrivalsBloc, NewArrivalsState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () => Future.sync(() => _pagingController.refresh()),
                child: PagedGridView<int, ProductModel>(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    childAspectRatio: 2 / 3,
                  ),
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ProductModel>(
                    itemBuilder: (context, product, index) => GestureDetector(
                      onTap: () {
                        AutoRouter.of(context).push(ProductDetailsScreenRoute(
                          detailsArguments: ProductDetailsArguments(
                              product: product,
                              initialValue: product.cartQty ?? 0),
                        ));
                      },
                      child: Card(
                        margin: EdgeInsets.all(2),
                        elevation: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                child: product.product_images.isEmpty
                                    ? Image.asset(
                                        "assets/images/placeholder.png",
                                        fit: BoxFit.fill,
                                      )
                                    : FadeInImage.assetNetwork(
                                        fit: BoxFit.fill,
                                        imageErrorBuilder: (c, s, o) =>
                                            Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.fill,
                                        ),
                                        placeholder:
                                            "assets/images/placeholder.png",
                                        image: IMAGE_URL +
                                            product.product_images.first.image!,
                                      ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            Flexible(
                              // flex: 1,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      "${product.price_s}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FavouriteWidget(
                                    isFav: product.isFavourite ?? false,
                                    id: product.id,
                                  ),
                                  CartSingleWidget(
                                    product: product,
                                    cartQty: product.cartQty ?? 0,
                                    id: product.id,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
