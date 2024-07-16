import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/utils/const.dart';
import 'package:biz_mobile_app/features/presentation/widgets/smooth_star_rating.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/Category/CategoryModel.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/all_category/all_category_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/fetch_by_cat/fetch_by_category_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_category/get_category_bloc.dart';
import 'package:biz_mobile_app/features/presentation/screens/home/widgets/cart_single_widget.dart';
import 'package:biz_mobile_app/features/presentation/screens/home/widgets/favourite_widget.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';

//all category screen
class AllCategories extends StatefulWidget {
  AllCategories({Key? key, required List<CategoryModel> categories})
      : _categories = categories,
        super(key: key);
  final List<CategoryModel> _categories;

  @override
  _AllCategoriesState createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  late final _allCatBloc = getIt<AllCategoryBloc>();
  late final _catBloc = getIt<GetCategoryBloc>();
  late final _fetchByCat = getIt<FetchByCategoryBloc>();
  late final _catNameCotroller = ScrollController();
  late final _addToCartBloc = getIt<AddToCartBloc>();
  late final _addToFavBloc = getIt<AddRemoveToFavBloc>();

  late final PagingController<int, CategoryModel> _pagingController =
      PagingController(firstPageKey: 1);

  late List<CategoryModel> _list = [];
  late List<CategoryModel> _subCat = [];
  late List<ProductModel> _prod = [];
  late String _catTitle = "All Categories";
  late bool _isGridView = true;

  late int _cartId;

  CategoryModel? _cat;
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(
        (pageKey) => _allCatBloc.add(GetAllCategoryEvent(page: pageKey)));
    _list = widget._categories;
    _cartId = widget._categories.first.id;
    _catBloc
        .add(GetCategorySingleEvent(categoryId: widget._categories.first.id));
  }

  @override
  void dispose() {
    super.dispose();
    _catBloc.close();
    _fetchByCat.close();
    _catNameCotroller.dispose();
    _pagingController.dispose();
    _allCatBloc.close();
    _addToCartBloc.close();
    _addToFavBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => _catBloc),
        BlocProvider(create: (create) => _fetchByCat),
        BlocProvider(create: (create) => _allCatBloc),
        BlocProvider(create: (create) => _addToCartBloc),
        BlocProvider(create: (create) => _addToFavBloc)
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddToCartBloc, AddToCartState>(
            listener: (context, state) {
              // if (state is AddToCartLoading) {
              //   ScaffoldMessenger.maybeOf(context)!
              //     ..hideCurrentSnackBar()
              //     ..showSnackBar(
              //       SnackBar(
              //         backgroundColor: Colors.blue,
              //         padding: EdgeInsets.symmetric(horizontal: 20),
              //         content: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             CupertinoActivityIndicator(),
              //             Text(
              //               "Adding to cart...",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              // }
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
          BlocListener<AllCategoryBloc, AllCategoryState>(
            listener: (context, state) {
              if (state is AllCategorySuccess) {
                _list = state.categories;
                final _current = state.currentPage ?? 1;
                int _lastPage = state.lastPage ?? 1;
                final _next = 1 + _current;
                if (_next > _lastPage) {
                  _pagingController.appendLastPage(_list);
                } else {
                  _pagingController.appendPage(_list, _next);
                }
              }
              if (state is AllCategoryError) {
                _pagingController.error = state.error;
              }
            },
          ),
          BlocListener<GetCategoryBloc, GetCategoryState>(
            listener: (context, state) {
              if (state is GetCategorySuccess) {
                _cat = state.response.category;
                // categories = state.response.categories;
                _subCat = state.response.categories;
                _cartId =
                    state.response.category?.id ?? widget._categories.first.id;
                //!TODO
                _fetchByCat.add(
                    FetchByCategoryStarted(categoryId: _cartId, product: []));
              }
            },
          ),
          BlocListener<FetchByCategoryBloc, FetchByCategoryState>(
            listener: (context, state) {
              if (state is FetchByCategorySuccess) {
                _prod = state.product;
              }
            },
          )
        ],
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: BlocBuilder<GetCategoryBloc, GetCategoryState>(
              builder: (context, state) {
                if (state is GetCategorySuccess) {
                  // categories = state.response.categories;
                  _catTitle = state.response.category?.name ?? "All Categories";
                }
                if (state is GetCategoryLoading) {
                  _catTitle = "Loading...";
                }
                return Text(_catTitle);
              },
            ),
          ),
          body: Container(
            height: _height,
            width: _width,
            child: Row(
              children: [
                BlocBuilder<GetCategoryBloc, GetCategoryState>(
                  builder: (context, state) {
                    return BlocBuilder<AllCategoryBloc, AllCategoryState>(
                      builder: (context, state) {
                        return Container(
                          color: Colors.grey[200],
                          width: _width * 0.33,
                          child: PagedListView<int, CategoryModel>.separated(
                            separatorBuilder: (c, i) => SizedBox(height: 3),
                            pagingController: _pagingController,
                            builderDelegate:
                                PagedChildBuilderDelegate<CategoryModel>(
                              itemBuilder: (contex, category, index) =>
                                  GestureDetector(
                                onTap: () => {
                                  _catBloc.add(
                                    GetCategorySingleEvent(
                                        categoryId: category.id),
                                  ),
                                },
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  color: _cartId == category.id
                                      ? Colors.transparent
                                      : Colors.white,
                                  elevation: 0,
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(5),
                                    height: 60,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${category.name}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // child: ListView.separated(
                          //   itemCount: widget._categories.length,
                          //   controller: _catNameCotroller,
                          //   itemBuilder: (c, i) => GestureDetector(
                          // onTap: () => {
                          //   _catBloc.add(
                          //     GetCategorySingleEvent(
                          //         categoryId: widget._categories[i].id),
                          //   ),
                          // },
                          // child: Card(
                          //   margin: EdgeInsets.zero,
                          //   color: _cartId == widget._categories[i].id
                          //       ? Colors.transparent
                          //       : Colors.white,
                          //   elevation: 0,
                          //   child: Container(
                          //     width: double.infinity,
                          //     padding: EdgeInsets.all(5),
                          //     height: 60,
                          //     alignment: Alignment.center,
                          //     child: Text(
                          //       "${widget._categories[i].name}",
                          //       textAlign: TextAlign.center,
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //       maxLines: 4,
                          //       overflow: TextOverflow.ellipsis,
                          //     ),
                          //   ),
                          // ),
                          // ),
                          //   separatorBuilder: (c, i) => SizedBox(height: 3),
                          // ),
                        );
                      },
                    );
                  },
                ),
                Expanded(
                  child: BlocBuilder<GetCategoryBloc, GetCategoryState>(
                    builder: (context, state) {
                      if (state is GetCategoryLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        color: Colors.grey[200],
                        child: Column(
                          children: [
                            SizedBox(height: 1),
                            _cat != null && _subCat.isNotEmpty
                                ? Column(
                                    children: [
                                      //!test
                                      Text("SUB-CATEGORIES"),
                                      Container(
                                        height: 100,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _subCat.length,
                                          itemBuilder: (c, i) =>
                                              GestureDetector(
                                            onTap: () {
                                              _catBloc.add(
                                                GetCategorySingleEvent(
                                                    categoryId: _subCat[i].id),
                                              );
                                            },
                                            child: Card(
                                              margin: EdgeInsets.all(3),
                                              elevation: 0,
                                              child: Container(
                                                width: 100,
                                                height: double.infinity,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(20),
                                                        width: 120,
                                                        child: _subCat[i]
                                                                    .category_pic !=
                                                                null
                                                            ? FadeInImage
                                                                .assetNetwork(
                                                                placeholder:
                                                                    "assets/images/placeholder.png",
                                                                image: IMAGE_URL +
                                                                    _subCat[i]
                                                                        .category_pic!,
                                                                imageErrorBuilder:
                                                                    (c, o, s) =>
                                                                        Image
                                                                            .asset(
                                                                  'assets/images/placeholder.png',
                                                                ),
                                                              )
                                                            : Image.asset(
                                                                "assets/images/placeholder.png",
                                                              ),
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          _subCat[i].name ?? "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          // maxLines: 2,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${_subCat[i].productcount} items",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          // maxLines: 2,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                //!PRODUCTS
                                //  _cat != null && _cat!.productcount > 0
                                : Opacity(opacity: 1),
                            _cat != null && _cat!.productcount > 0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("PRODUCTS"),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isGridView = !_isGridView;
                                            });
                                          },
                                          icon: Icon(
                                            _isGridView
                                                ? Icons.grid_view
                                                : Icons.list,
                                          )),
                                    ],
                                  )
                                : Opacity(opacity: 0),
                            SizedBox(
                              height: 5,
                            ),
                            _cat != null && _cat!.productcount > 0
                                ? Expanded(
                                    child: BlocBuilder<FetchByCategoryBloc,
                                        FetchByCategoryState>(
                                      builder: (context, state) {
                                        if (state is FetchByCategoryLoading) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return _isGridView
                                            ? GridView.builder(
                                                itemCount: _prod.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 150,
                                                  childAspectRatio: 2 / 3,
                                                ),
                                                itemBuilder: (c, i) =>
                                                    GestureDetector(
                                                  onTap: () {
                                                    AutoRouter.of(context).push(
                                                        ProductDetailsScreenRoute(
                                                      detailsArguments:
                                                          ProductDetailsArguments(
                                                              product: _prod[i],
                                                              initialValue: _prod[
                                                                          i]
                                                                      .cartQty ??
                                                                  0),
                                                    ));
                                                  },
                                                  child: Card(
                                                    margin: EdgeInsets.all(2),
                                                    elevation: 0,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                          flex: 3,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    20),
                                                            constraints:
                                                                BoxConstraints(
                                                              minHeight: 50,
                                                            ),
                                                            child: _prod[i]
                                                                    .product_images
                                                                    .isEmpty
                                                                ? Image.asset(
                                                                    "assets/images/placeholder.png",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  )
                                                                : FadeInImage
                                                                    .assetNetwork(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    imageErrorBuilder: (c,
                                                                            s,
                                                                            o) =>
                                                                        Image
                                                                            .asset(
                                                                      "assets/images/placeholder.png",
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                    placeholder:
                                                                        "assets/images/placeholder.png",
                                                                    image: IMAGE_URL +
                                                                        _prod[i]
                                                                            .product_images
                                                                            .first
                                                                            .image!,
                                                                  ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          // flex: 1,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  _prod[i].name ??
                                                                      "",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        9.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${_prod[i].price_s}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              FavouriteWidget(
                                                                isFav: _prod[i]
                                                                        .isFavourite ??
                                                                    false,
                                                                id: _prod[i].id,
                                                              ),
                                                              CartSingleWidget(
                                                                product:
                                                                    _prod[i],
                                                                cartQty: _prod[
                                                                            i]
                                                                        .cartQty ??
                                                                    0,
                                                                id: _prod[i].id,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : ListView.separated(
                                                // shrinkWrap: true,
                                                // primary: false,
                                                // physics:
                                                //     NeverScrollableScrollPhysics(),
                                                itemCount: _prod.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  // if (index ==
                                                  //     _products.length) {
                                                  //   return _isBottomLoading
                                                  //       ? BottomLoader()
                                                  //       : state
                                                  //               is ProductPaginatedError
                                                  //           ? ErrorPaginated(
                                                  //               onRefresh: () {
                                                  //                 _paginatedBloc.add(GetProductPaginatedEvent(
                                                  //                     product:
                                                  //                         _products,
                                                  //                     position:
                                                  //                         0,
                                                  //                     page:
                                                  //                         _currentPage));
                                                  //               },
                                                  //             )
                                                  //           : Opacity(
                                                  //               opacity: 0);
                                                  // }
                                                  final product = _prod[index];
                                                  return ListTile(
                                                    tileColor: Colors.white,
                                                    title: Text(
                                                      product.name ?? "",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    leading: Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: product
                                                              .product_images
                                                              .isEmpty
                                                          ? Image.asset(
                                                              "assets/images/placeholder.png")
                                                          : FadeInImage
                                                              .assetNetwork(
                                                              imageErrorBuilder: (context,
                                                                      error,
                                                                      stackTrace) =>
                                                                  Image.asset(
                                                                      "assets/images/placeholder.png"),
                                                              placeholder:
                                                                  "assets/images/placeholder.png",
                                                              image: IMAGE_URL +
                                                                  "${product.product_images.first.image}",
                                                            ),
                                                    ),
                                                    trailing: Text(r""),
                                                    subtitle: Row(
                                                      children: <Widget>[
                                                        SmoothStarRating(
                                                          starCount: 1,
                                                          color: Constants
                                                              .ratingBG,
                                                          allowHalfRating: true,
                                                          rating: 5.0,
                                                          size: 8.0,
                                                        ),
                                                        SizedBox(width: 2.0),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            "Price: ",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.black)),
                                                                    TextSpan(
                                                                        text: product
                                                                            .price_s,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.green,
                                                                        ))
                                                                  ]),
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            "Cart Quantity: ",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                8,
                                                                            color:
                                                                                Colors.black)),
                                                                    TextSpan(
                                                                        text: product
                                                                            .cartQty
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              8,
                                                                          color:
                                                                              Colors.red,
                                                                        ))
                                                                  ]),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    onTap: () => Navigator.of(
                                                            context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetailsScreen(
                                                        detailsArguments:
                                                            ProductDetailsArguments(
                                                          product: product,
                                                          initialValue:
                                                              product.cartQty ??
                                                                  0,
                                                        ),
                                                      ),
                                                    )),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Divider();
                                                },
                                              );
                                      },
                                    ),
                                  )
                                : Opacity(opacity: 0)
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
