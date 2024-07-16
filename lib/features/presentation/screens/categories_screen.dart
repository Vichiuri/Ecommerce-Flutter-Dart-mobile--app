import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/features/presentation/bloc/search_product/search_product_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/bottom_loader.dart';
import 'package:biz_mobile_app/features/presentation/components/error_paginated.dart';
import 'package:biz_mobile_app/features/presentation/widgets/search/product_search_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/Category/CategoryModel.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/fetch_by_cat/fetch_by_category_bloc.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';

import 'home/widgets/cart_single_widget.dart';
import 'home/widgets/favourite_widget.dart';

class CategoriesScreen extends StatefulWidget {
  final CategoryModel categoryModel;
  // final List<CategoryModel> categories;

  const CategoriesScreen({
    Key? key,
    required this.categoryModel,
  }) : super(key: key);
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // String catie = "";
  // List<ProductModel> products_ = [];

  late final bloc = getIt<FetchByCategoryBloc>();
  late final addBloc = getIt<AddRemoveToFavBloc>();
  late final addToCartBloc = getIt<AddToCartBloc>();
  late final _scrollController = ScrollController();
  late final _searchBloc = getIt<SearchProductBloc>();
  late int currentPage = 1;
  late int lastPage = 1;
  late bool _isUpdating = false;

  late List<ProductModel> products = [];
  late int initialId;
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback(
        (timeStamp) => {_scrollController.addListener(_onsCroll)});
    bloc.add(FetchByCategoryStarted(
        categoryId: widget.categoryModel.id, product: products));
    categoryName = widget.categoryModel.name ?? "";
    initialId = widget.categoryModel.id;
    super.initState();
  }

  String categoryName = "";

  @override
  void dispose() {
    addToCartBloc.close();
    super.dispose();
    bloc.close();
    addBloc.close();
    _scrollController.dispose();
  }

  void _onsCroll() {
    late final _maxScroll = _scrollController.position.maxScrollExtent;
    late final _currentScroll = _scrollController.position.pixels;
    print('MAX SCROLL' + _maxScroll.toStringAsFixed(2));
    print("CURRENT SCROLL" + _currentScroll.toStringAsFixed(2));
    if (_currentScroll == _maxScroll) {
      if (currentPage < lastPage) {
        _isUpdating = true;
        bloc.add(FetchByCategoryPaginated(
          page: currentPage + 1,
          categoryId: widget.categoryModel.id,
          product: products,
        ));
        // context.read<GetFavouritesBloc>().add(
        //     GetFavouritePaginated(page: currentPage + 1, products: products));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => bloc),
        BlocProvider(create: (context) => addBloc),
        BlocProvider(create: (_) => addToCartBloc),
        BlocProvider(create: (create) => _searchBloc)
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddToCartBloc, AddToCartState>(
            listener: (context, state) {
              if (state is AddToCartLoading) {
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
                            "Adding to cart...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
              }
              if (state is AddToCartSuccess) {
                bloc..add(UpdateCategoryStarted(categoryId: initialId));
                // context
                //     .read<GetCartQuantityBloc>()
                //     .add(GetCartQuantityStarted());
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
                bloc..add(UpdateCategoryStarted(categoryId: initialId));
              }
              if (state is AddRemoveToFavError) {
                bloc.add(UpdateCategoryStarted(categoryId: initialId));
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
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_backspace,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              categoryName,
            ),
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                onPressed: () => showSearch<ProductModel?>(
                    context: context,
                    delegate: ProductSearchDelegate(
                      bloc: _searchBloc,
                      searchFieldLabel: "Search By Category",
                      catId: widget.categoryModel.id,
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
          body: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: BlocBuilder<FetchByCategoryBloc, FetchByCategoryState>(
              builder: (context, state) {
                if (state is FetchByCategoryInitial) {
                  _isUpdating = true;
                }
                if (state is FetchByCategoryLoading) {
                  return Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                    ),
                  );
                }
                if (state is FetchByCategoryError) {
                  _isUpdating = false;
                }
                if (state is FetchByCategorySuccess) {
                  products = state.product;
                  _isUpdating = false;
                  currentPage = state.currentPage ?? 1;
                  lastPage = state.lastPage ?? 1;
                  print("LAST PAGE:${state.lastPage}");
                  print("CURRENT PAGE:${state.currentPage}");
                }
                return BlocBuilder<AddToCartBloc, AddToCartState>(
                  builder: (context, s) => GridView.builder(
                    // margin: EdgeInsets.all(5),
                    shrinkWrap: true,
                    primary: false,
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: products.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == products.length) {
                        return _isUpdating
                            ? BottomLoader()
                            : state is FetchByCategoryError
                                ? ErrorPaginated(
                                    onRefresh: () {
                                      _isUpdating = true;
                                      bloc.add(FetchByCategoryPaginated(
                                        page: currentPage + 1,
                                        categoryId: widget.categoryModel.id,
                                        product: products,
                                      ));
                                    },
                                  )
                                : Opacity(opacity: 0);
                        // return BottomLoader();
                      }
                      String imageEnd = '';
                      final bool isFav = products[index].isFavourite ?? false;
                      if (products[index].product_images.length > 0) {
                        imageEnd = IMAGE_URL +
                            products[index].product_images[0].image!;
                      } else {
                        imageEnd =
                            'https://image.freepik.com/free-vector/empty-concept-illustration_114360-1253.jpg';
                      }
                      return GestureDetector(
                        onTap: () {
                          AutoRouter.of(context).push(ProductDetailsScreenRoute(
                              detailsArguments: ProductDetailsArguments(
                            product: products[index],
                            initialValue: products[index].cartQty ?? 0,
                          )));
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
                                  child: FadeInImage.assetNetwork(
                                      fit: BoxFit.fill,
                                      imageErrorBuilder: (c, s, o) =>
                                          Image.asset(
                                            "assets/images/placeholder.png",
                                            fit: BoxFit.fill,
                                          ),
                                      placeholder:
                                          "assets/images/placeholder.png",
                                      image: imageEnd),
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
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FavouriteWidget(
                                      isFav:
                                          products[index].isFavourite ?? false,
                                      id: products[index].id,
                                    ),
                                    CartSingleWidget(
                                      product: products[index],
                                      cartQty: products[index].cartQty ?? 0,
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
