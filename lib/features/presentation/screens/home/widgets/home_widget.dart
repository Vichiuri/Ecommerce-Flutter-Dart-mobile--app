import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/features/presentation/bloc/recent_buy/recent_bought_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/top_product/top_product_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shimmer/shimmer.dart';

import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/features/domain/models/Category/CategoryModel.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/models/banners/BannerModel.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_banners/get_banners_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_cart_quantity/get_cart_quantity_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_category/get_category_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_fav/get_favourites_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_offer/get_offer_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/new_arrivals/new_arrivals_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/product_paginated/product_paginated_bloc.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';

import 'cart_single_widget.dart';
import 'favourite_widget.dart';

//favourites
class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with AutomaticKeepAliveClientMixin {
  //  _prodCard = GlobalKey();
  List<CategoryModel> _categoryModel = [];
  List<ProductModel> _products = [];
  List<ProductModel> _arrivals = [];
  List<ProductModel> _recent = [];
  List<ProductModel> _top = [];
  List<OfferModel> _offers = [];
  List<BannerModel> _banners = [];
  Completer<void> _refreshCompler = Completer<void>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<TopProductBloc>().add(TopProductStarted());
      context.read<RecentBoughtBloc>().add(RecentBoughtEventStarted());
      context.read<GetBannersBloc>().add(GetBannerStated());
      context.read<GetOfferBloc>().add(GetOfferStarted());
      context.read<GetCategoryBloc>().add(GetCategoryStarted(page: null));
      context
          .read<ProductPaginatedBloc>()
          .add(GetProductPaginatedEvent(product: [], position: 0, page: null));
      context.read<NewArrivalsBloc>().add(
          GetNewArrivalePaginatedEvent(product: [], position: 0, page: null));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _width = MediaQuery.of(context).size.width;
    print("SCREEN WIDTH: $_width");
    final _cardWidth = (_width < 480)
        ? (_width - 20) / 3
        : (_width > 600)
            ? 150.0
            : (_width - 20) / 4;
    return MultiBlocListener(
      listeners: [
        BlocListener<TopProductBloc, TopProductState>(
          listener: (c, state) {
            if (state is TopProductSuccess) {
              _top = state.response.products;
            }
          },
        ),
        BlocListener<RecentBoughtBloc, RecentBoughtState>(
          listener: (c, state) {
            if (state is RecentBoughtSuccess) {
              _recent = state.response.products;
            }
          },
        ),
        //*ADD TO CART
        BlocListener<AddToCartBloc, AddToCartState>(
          listener: (context, state) {
            if (state is AddToCartInitial) {
              _isLoading = true;
            }
            // if (state is AddToCartLoading) {
            //   _isLoading = true;
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
              context.read<ProductPaginatedBloc>().add(
                  GetProductPaginatedUpdate(product: [], position: 0, page: 0));
              context
                  .read<NewArrivalsBloc>()
                  .add(UpdateNewArrivals(product: [], position: 0, page: 0));
              context.read<GetCartQuantityBloc>().add(GetCartQuantityStarted());

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
              _isLoading = false;
            }
            if (state is AddToCartError) {
              _isLoading = false;
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
            // if (state is AddRemoveToFavLoading) {
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
            //               "Processing...",
            //               style: TextStyle(color: Colors.white),
            //             ),
            //           ],
            //         ),
            //       ),object
            //     );
            // }
            if (state is AddRemoveToFavSuccess) {
              context.read<GetFavouritesBloc>().add(GetFavouritesUpdated());
              print("Success");
              showSimpleNotification(
                Text(state.message),
                background: Colors.green,
                duration: Duration(seconds: 1),
                position: NotificationPosition.bottom,
              );
              ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
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
        BlocListener<GetBannersBloc, GetBannersState>(
          listener: (context, state) {
            if (state is GetBannersSuccess) {
              _banners = state.banners;
              _refreshCompler.complete();
              _refreshCompler = Completer();
            }
            if (state is GetBannersError) {
              _refreshCompler.complete();
              _refreshCompler = Completer();
            }
          },
        ),
        BlocListener<GetOfferBloc, GetOfferState>(
          listener: (context, state) {
            if (state is GetOfferSuccess) {
              _offers = state.offers;
              _refreshCompler.complete();
              _refreshCompler = Completer();
            }
            if (state is GetOfferError) {
              _refreshCompler.complete();
              _refreshCompler = Completer();
            }
          },
        ),
        BlocListener<GetCategoryBloc, GetCategoryState>(
          listener: (context, state) {
            if (state is GetCategorySuccess) {
              _categoryModel = state.response.categories;
              _refreshCompler.complete();
              _refreshCompler = Completer();
            }
            if (state is GetCategoryError) {
              _refreshCompler.complete();
              _refreshCompler = Completer();
            }
          },
        ),
        BlocListener<NewArrivalsBloc, NewArrivalsState>(
          listener: (context, state) {
            if (state is NewArrivalsSuccess) {
              _arrivals = state.response.products;
              _refreshCompler.complete();
              _refreshCompler = Completer();
            }
            if (state is NewArrivalsError) {
              _refreshCompler.complete();
              _refreshCompler = Completer();
            }
          },
        ),
        BlocListener<ProductPaginatedBloc, ProductPaginatedState>(
          listener: (context, state) {
            if (state is ProductPaginatedSuccess) {
              _products = state.response.products;
              _refreshCompler.complete();
              _refreshCompler = Completer();
            }
            if (state is ProductPaginatedError) {
              _refreshCompler.complete();
              _refreshCompler = Completer();
            }
          },
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () {
          context.read<TopProductBloc>().add(TopProductUpdate());
          context.read<RecentBoughtBloc>().add(RecentBoughtEventUpdated());
          context.read<GetBannersBloc>().add(GetBannerUpdate());
          context.read<GetOfferBloc>().add(GetOfferUpdate());
          context.read<GetCategoryBloc>().add(GetCategoryUpdate(page: 1));
          context.read<ProductPaginatedBloc>().add(
              GetProductPaginatedUpdate(product: [], position: 0, page: 0));
          context
              .read<NewArrivalsBloc>()
              .add(UpdateNewArrivals(product: [], position: 0, page: 0));
          return _refreshCompler.future;
        },
        child: SingleChildScrollView(
          key: PageStorageKey<String>('home'),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                BlocBuilder<GetBannersBloc, GetBannersState>(
                  builder: (context, state) {
                    if (state is GetBannersLoading) {
                      return CarouselSlider(
                        items: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.white,
                                child: Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Image.asset(
                                    'assets/images/placeholder_rectangle.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor: Colors.white,
                                child: Text(
                                  "Loading...",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                        options: CarouselOptions(
                          height: 170,
                          autoPlay: false,
                          viewportFraction: 1.0,
                          aspectRatio: 2.67,
                          enableInfiniteScroll: true,
                          autoPlayInterval: Duration(seconds: 5),
                        ),
                      );
                    }

                    return CarouselSlider(
                      items: _banners
                          .map((banner) => InkWell(
                                onTap: () {
                                  if (banner.status == "Product") {
                                    AutoRouter.of(context)
                                        .push(ProductDetailsScreenRoute(
                                            detailsArguments:
                                                ProductDetailsArguments(
                                      product: banner.product!,
                                      initialValue:
                                          banner.product!.cartQty ?? 0,
                                    )))
                                        .then((value) {
                                      context.read<ProductPaginatedBloc>().add(
                                          GetProductPaginatedUpdate(
                                              product: [],
                                              position: 0,
                                              page: 0));
                                      context.read<NewArrivalsBloc>().add(
                                          UpdateNewArrivals(
                                              product: [],
                                              position: 0,
                                              page: 0));
                                      context
                                          .read<GetCartQuantityBloc>()
                                          .add(GetCartQuantityStarted());
                                    });
                                  } else if (banner.status == "Offer") {
                                    AutoRouter.of(context)
                                        .push(OfferDetailScreenRoute(
                                      offerId: banner.offer!.id,
                                    ));
                                  } else {
                                    print(
                                        "I've got Goodness, and I've got Mercy");
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Colors.white,
                                      ),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: IMAGE_URL + "${banner.pic}",
                                        placeholder: (c, s) => Image.asset(
                                          'assets/images/placeholder_rectangle.png',
                                          fit: BoxFit.fill,
                                        ),
                                        errorWidget: (c, s, o) => Image.asset(
                                          'assets/images/placeholder_rectangle.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      // child: FadeInImage.assetNetwork(
                                      //   fit: BoxFit.fill,
                                      //   image: IMAGE_URL + "${banner.pic}",
                                      //   placeholder:
                                      //       'assets/images/placeholder_rectangle.png',
                                      //   placeholderScale: 1,
                                      // imageErrorBuilder: (c, s, k) => Image.asset(
                                      //     'assets/images/placeholder_rectangle.png'),
                                      // ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${banner.text}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        height: 170,
                        autoPlay: true,
                        viewportFraction: 1.0,
                        aspectRatio: 2.67,
                        enableInfiniteScroll: true,
                        autoPlayInterval: Duration(seconds: 10),
                      ),
                    );
                  },
                ),
                //!OFFERS
                BlocBuilder<GetOfferBloc, GetOfferState>(
                  builder: (context, state) {
                    if (state is GetOfferLoading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Offers",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ), //TODO add bool
                          BlocBuilder<GetOfferBloc, GetOfferState>(
                            builder: (context, state) {
                              return _offers.isEmpty
                                  ? Opacity(opacity: 0)
                                  : GestureDetector(
                                      onTap: () => AutoRouter.of(context).push(
                                          AllOffersScreenRoute(
                                              offers: _offers)),
                                      child: Text(
                                        "View All",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                            },
                          )
                        ],
                      );
                    }
                    return _offers.isEmpty
                        ? Opacity(opacity: 0)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Offers",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ), //TODO add bool
                              BlocBuilder<GetOfferBloc, GetOfferState>(
                                builder: (context, state) {
                                  return _offers.isEmpty
                                      ? Opacity(opacity: 0)
                                      : GestureDetector(
                                          onTap: () => AutoRouter.of(context)
                                              .push(AllOffersScreenRoute(
                                                  offers: _offers)),
                                          child: Text(
                                            "View All",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                },
                              )
                            ],
                          );
                  },
                ),

                BlocBuilder<GetOfferBloc, GetOfferState>(
                  builder: (context, state) {
                    if (state is GetOfferLoading) {
                      return Container(
                        height: 120,
                        child: ListView.builder(
                          itemCount: 5,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (c, i) => Card(
                            elevation: 0,
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              width: 120,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        width: 120,
                                        child: Image.asset(
                                          "assets/images/placeholder.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[400]!,
                                    highlightColor: Colors.white,
                                    period: Duration(milliseconds: 500),
                                    child: Text(
                                      "Loading...",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    //!SUCCESS
                    return _offers.isEmpty
                        ? Opacity(opacity: 0)
                        : Container(
                            height: 120,
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount: _offers.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (c, i) => GestureDetector(
                                  onTap: () => AutoRouter.of(context).push(
                                      OfferDetailScreenRoute(
                                          offerId: _offers[i].id)),
                                  child: Card(
                                    elevation: 0,
                                    margin: EdgeInsets.symmetric(horizontal: 3),
                                    child: Container(
                                      width: 120,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.all(20),
                                              width: 120,
                                              child: CachedNetworkImage(
                                                errorWidget: (c, s, o) =>
                                                    Image.asset(
                                                  "assets/images/placeholder.png",
                                                ),
                                                fit: BoxFit.fill,
                                                placeholderFadeInDuration:
                                                    const Duration(
                                                        milliseconds: 400),
                                                imageUrl:
                                                    IMAGE_URL + _offers[i].pic,
                                                fadeInDuration: const Duration(
                                                    milliseconds: 400),
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                        "assets/images/placeholder.png"),
                                              ),
                                              // child: FadeInImage.assetNetwork(
                                              //   placeholder:
                                              //       "assets/images/placeholder.png",
                                              //   image: IMAGE_URL + _offers[i].pic,
                                              //   imageErrorBuilder: (c, s, o) =>
                                              //       Image.asset(
                                              //     "assets/images/placeholder.png",
                                              //   ),
                                              // ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${_offers[i].name}",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          // Text(
                                          //   "${_offers[i].detailName}",
                                          //   overflow: TextOverflow.ellipsis,
                                          //   style: TextStyle(
                                          //     color: Colors.black,
                                          //     fontWeight: FontWeight.w400,
                                          //     fontSize: 10,
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                  },
                ),

                //!CATEGORIES
                BlocBuilder<GetCategoryBloc, GetCategoryState>(
                  builder: (context, state) {
                    if (state is GetCategoryLoading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          //TODO Add Lopp
                          MaterialButton(
                            onPressed: () => AutoRouter.of(context)
                                .push(AllCategoriesRoute(
                                    categories: _categoryModel))
                                .then((value) {
                              context.read<ProductPaginatedBloc>().add(
                                  GetProductPaginatedUpdate(
                                      product: [], position: 0, page: 0));
                              context.read<NewArrivalsBloc>().add(
                                  UpdateNewArrivals(
                                      product: [], position: 0, page: 0));
                              context
                                  .read<GetCartQuantityBloc>()
                                  .add(GetCartQuantityStarted());
                            }),
                            child: Text(
                              "View All",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return _categoryModel.isEmpty
                        ? Opacity(opacity: 0)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Categories",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              //TODO Add Lopp
                              MaterialButton(
                                onPressed: () => AutoRouter.of(context)
                                    .push(AllCategoriesRoute(
                                        categories: _categoryModel))
                                    .then((value) {
                                  context.read<ProductPaginatedBloc>().add(
                                      GetProductPaginatedUpdate(
                                          product: [], position: 0, page: 0));
                                  context.read<NewArrivalsBloc>().add(
                                      UpdateNewArrivals(
                                          product: [], position: 0, page: 0));
                                  context
                                      .read<GetCartQuantityBloc>()
                                      .add(GetCartQuantityStarted());
                                }),
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                  },
                ),
                BlocBuilder<GetCategoryBloc, GetCategoryState>(
                  builder: (context, state) {
                    if (state is GetCategoryLoading) {
                      return Container(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (c, i) => Card(
                            margin: i != 0
                                ? EdgeInsets.symmetric(horizontal: 3)
                                : EdgeInsets.only(right: 3),
                            child: Container(
                              width: _cardWidth,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 15,
                                          bottom: 30,
                                        ),
                                        width: 120,
                                        child: Image.asset(
                                          "assets/images/placeholder.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[500]!,
                                    highlightColor: Colors.white,
                                    child: Text(
                                      "Loading...",
                                      overflow: TextOverflow.ellipsis,
                                      // maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    //!SUCCESS
                    return _categoryModel.isEmpty
                        ? Opacity(opacity: 0)
                        : Container(
                            height: 170,
                            child: Scrollbar(
                              // showTrackOnHover: true,
                              // isAlwaysShown: true,
                              child: ListView.builder(
                                itemCount: _categoryModel.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () => AutoRouter.of(context)
                                      .push(CategoriesScreenRoute(
                                    categoryModel: _categoryModel[index],
                                  ))
                                      .then((value) {
                                    context.read<ProductPaginatedBloc>().add(
                                        GetProductPaginatedUpdate(
                                            product: [], position: 0, page: 0));
                                    context.read<NewArrivalsBloc>().add(
                                        UpdateNewArrivals(
                                            product: [], position: 0, page: 0));
                                    context
                                        .read<GetCartQuantityBloc>()
                                        .add(GetCartQuantityStarted());
                                  }),
                                  child: Card(
                                    margin: index != 0
                                        ? EdgeInsets.symmetric(horizontal: 2)
                                        : EdgeInsets.only(right: 2),
                                    elevation: 0,
                                    child: Container(
                                      width: _cardWidth,
                                      height: double.infinity,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                left: 23,
                                                right: 23,
                                                top: 15,
                                                bottom: 31,
                                              ),
                                              width: 120,
                                              child: _categoryModel[index]
                                                          .category_pic !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      errorWidget: (c, s, o) =>
                                                          Image.asset(
                                                        "assets/images/placeholder.png",
                                                      ),
                                                      fit: BoxFit.fill,
                                                      placeholderFadeInDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  400),
                                                      fadeInDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  400),
                                                      imageUrl: IMAGE_URL +
                                                          _categoryModel[index]
                                                              .category_pic!,
                                                      placeholder: (c, s) =>
                                                          Image.asset(
                                                        "assets/images/placeholder.png",
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      "assets/images/placeholder.png",
                                                    ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  _categoryModel[index].name ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  // maxLines: 2,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  "${_categoryModel[index].productcount} items",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  // maxLines: 2,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                  },
                ),

                SizedBox(height: 5),
                //!RECENT
                BlocBuilder<RecentBoughtBloc, RecentBoughtState>(
                  builder: (context, state) {
                    if (state is RecentBoughtLoading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Recent Buys",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Opacity(opacity: 0)
                        ],
                      );
                    }
                    return _recent.isEmpty
                        ? Opacity(opacity: 0)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Recent Buys",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Opacity(opacity: 0)
                            ],
                          );
                  },
                ),
                BlocBuilder<RecentBoughtBloc, RecentBoughtState>(
                  builder: (context, state) {
                    if (state is RecentBoughtLoading) {
                      return Container(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (c, i) => Card(
                            margin: EdgeInsets.all(2),
                            child: Container(
                              width: 150,
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        // child: _prod[i].product_images.isEmpty
                                        child: Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.fill,
                                        ),
                                        // : FadeInImage.assetNetwork(
                                        //     fit: BoxFit.fill,
                                        //     imageErrorBuilder: (c, s, o) =>
                                        //         Image.asset(
                                        //       "assets/images/placeholder.png",
                                        //       fit: BoxFit.fill,
                                        //     ),
                                        //     placeholder:
                                        //         "assets/images/placeholder.png",
                                        //     image: IMAGE_URL +
                                        //         _prod[i]
                                        //             .product_images
                                        //             .first
                                        //             .image!,
                                        //   ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    // flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[500]!,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                "Loading",
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[400]!,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                "Loading",
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    //!SUCCESS
                    return _recent.isEmpty
                        ? Opacity(opacity: 0)
                        : Container(
                            height: 170,
                            child: Scrollbar(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _recent.length,
                                itemBuilder: (c, i) => GestureDetector(
                                  onTap: () {
                                    AutoRouter.of(context)
                                        .push(ProductDetailsScreenRoute(
                                      detailsArguments: ProductDetailsArguments(
                                          product: _recent[i],
                                          initialValue:
                                              _recent[i].cartQty ?? 0),
                                    ))
                                        .then((value) {
                                      context.read<ProductPaginatedBloc>().add(
                                          GetProductPaginatedUpdate(
                                              product: [],
                                              position: 0,
                                              page: 0));
                                      context.read<NewArrivalsBloc>().add(
                                          UpdateNewArrivals(
                                              product: [],
                                              position: 0,
                                              page: 0));
                                      context
                                          .read<GetCartQuantityBloc>()
                                          .add(GetCartQuantityStarted());
                                    });
                                  },
                                  child: Card(
                                    margin: i != 0
                                        ? EdgeInsets.symmetric(horizontal: 2)
                                        : EdgeInsets.only(right: 2),
                                    elevation: 0,
                                    child: Container(
                                      width: _cardWidth,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              constraints: BoxConstraints(
                                                minHeight: 50,
                                              ),
                                              child: _recent[i]
                                                      .product_images
                                                      .isEmpty
                                                  ? Image.asset(
                                                      "assets/images/placeholder.png",
                                                      fit: BoxFit.fill,
                                                    )
                                                  // : FadeInImage.assetNetwork(
                                                  //     fit: BoxFit.fill,
                                                  //     imageErrorBuilder: (c, s, o) =>
                                                  //         Image.asset(
                                                  //       "assets/images/placeholder.png",
                                                  //       fit: BoxFit.fill,
                                                  //     ),
                                                  //     placeholder:
                                                  //         "assets/images/placeholder.png",
                                                  // image: IMAGE_URL +
                                                  //     _arrivals[i]
                                                  //         .product_images
                                                  //         .first
                                                  //         .image!,
                                                  //   ),
                                                  : CachedNetworkImage(
                                                      errorWidget: (c, s, o) =>
                                                          Image.asset(
                                                        "assets/images/placeholder.png",
                                                      ),
                                                      fit: BoxFit.fill,
                                                      imageUrl: IMAGE_URL +
                                                          _recent[i]
                                                              .product_images
                                                              .first
                                                              .image!,
                                                      placeholderFadeInDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  400),
                                                      fadeInDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  400),
                                                      placeholder: (c, s) =>
                                                          Image.asset(
                                                        "assets/images/placeholder.png",
                                                      ),
                                                    ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${_recent[i].name}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 9.0,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${_recent[i].price_s}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FavouriteWidget(
                                                  isFav:
                                                      _recent[i].isFavourite ??
                                                          false,
                                                  id: _recent[i].id,
                                                ),
                                                CartSingleWidget(
                                                  product: _recent[i],
                                                  cartQty:
                                                      _recent[i].cartQty ?? 0,
                                                  id: _recent[i].id,
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
                            ),
                          );
                  },
                ),

                SizedBox(height: 5),

                //!TOP
                BlocBuilder<TopProductBloc, TopProductState>(
                  builder: (context, state) {
                    if (state is TopProductLoading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Top Products",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Opacity(opacity: 0)
                        ],
                      );
                    }
                    return _top.isEmpty
                        ? Opacity(opacity: 0)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Top Products",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Opacity(opacity: 0)
                            ],
                          );
                  },
                ),
                BlocBuilder<TopProductBloc, TopProductState>(
                  builder: (context, state) {
                    if (state is TopProductLoading) {
                      return Container(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (c, i) => Card(
                            margin: EdgeInsets.all(2),
                            child: Container(
                              width: 150,
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        // child: _prod[i].product_images.isEmpty
                                        child: Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.fill,
                                        ),
                                        // : FadeInImage.assetNetwork(
                                        //     fit: BoxFit.fill,
                                        //     imageErrorBuilder: (c, s, o) =>
                                        //         Image.asset(
                                        //       "assets/images/placeholder.png",
                                        //       fit: BoxFit.fill,
                                        //     ),
                                        //     placeholder:
                                        //         "assets/images/placeholder.png",
                                        //     image: IMAGE_URL +
                                        //         _prod[i]
                                        //             .product_images
                                        //             .first
                                        //             .image!,
                                        //   ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    // flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[500]!,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                "Loading",
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[400]!,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                "Loading",
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    //!SUCCESS
                    return _top.isEmpty
                        ? Opacity(opacity: 0)
                        : Container(
                            height: 170,
                            child: Scrollbar(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _top.length,
                                itemBuilder: (c, i) => GestureDetector(
                                  onTap: () {
                                    AutoRouter.of(context)
                                        .push(ProductDetailsScreenRoute(
                                      detailsArguments: ProductDetailsArguments(
                                          product: _top[i],
                                          initialValue: _top[i].cartQty ?? 0),
                                    ))
                                        .then((value) {
                                      context.read<ProductPaginatedBloc>().add(
                                          GetProductPaginatedUpdate(
                                              product: [],
                                              position: 0,
                                              page: 0));
                                      context.read<NewArrivalsBloc>().add(
                                          UpdateNewArrivals(
                                              product: [],
                                              position: 0,
                                              page: 0));
                                      context
                                          .read<GetCartQuantityBloc>()
                                          .add(GetCartQuantityStarted());
                                    });
                                  },
                                  child: Card(
                                    margin: i != 0
                                        ? EdgeInsets.symmetric(horizontal: 2)
                                        : EdgeInsets.only(right: 2),
                                    elevation: 0,
                                    child: Container(
                                      width: _cardWidth,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              constraints: BoxConstraints(
                                                minHeight: 50,
                                              ),
                                              child: _top[i]
                                                      .product_images
                                                      .isEmpty
                                                  ? Image.asset(
                                                      "assets/images/placeholder.png",
                                                      fit: BoxFit.fill,
                                                    )
                                                  // : FadeInImage.assetNetwork(
                                                  //     fit: BoxFit.fill,
                                                  //     imageErrorBuilder: (c, s, o) =>
                                                  //         Image.asset(
                                                  //       "assets/images/placeholder.png",
                                                  //       fit: BoxFit.fill,
                                                  //     ),
                                                  //     placeholder:
                                                  //         "assets/images/placeholder.png",
                                                  // image: IMAGE_URL +
                                                  //     _arrivals[i]
                                                  //         .product_images
                                                  //         .first
                                                  //         .image!,
                                                  //   ),
                                                  : CachedNetworkImage(
                                                      errorWidget: (c, s, o) =>
                                                          Image.asset(
                                                        "assets/images/placeholder.png",
                                                      ),
                                                      fit: BoxFit.fill,
                                                      imageUrl: IMAGE_URL +
                                                          _top[i]
                                                              .product_images
                                                              .first
                                                              .image!,
                                                      placeholderFadeInDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  400),
                                                      fadeInDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  400),
                                                      placeholder: (c, s) =>
                                                          Image.asset(
                                                        "assets/images/placeholder.png",
                                                      ),
                                                    ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${_top[i].name}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 9.0,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${_top[i].price_s}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FavouriteWidget(
                                                  isFav: _top[i].isFavourite ??
                                                      false,
                                                  id: _top[i].id,
                                                ),
                                                CartSingleWidget(
                                                  product: _top[i],
                                                  cartQty: _top[i].cartQty ?? 0,
                                                  id: _top[i].id,
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
                            ),
                          );
                  },
                ),
                //!NEW ARRIVALS
                BlocBuilder<NewArrivalsBloc, NewArrivalsState>(
                  builder: (context, state) {
                    if (state is NewArrivalsLoading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "New Arrivals",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          // Opacity(opacity: 0)
                          TextButton(
                            onPressed: () => {
                              AutoRouter.of(context)
                                  .push(NewArrivalScreenRoute())
                                  .then((value) {
                                context.read<ProductPaginatedBloc>().add(
                                    GetProductPaginatedUpdate(
                                        product: [], position: 0, page: 0));
                                context.read<NewArrivalsBloc>().add(
                                    UpdateNewArrivals(
                                        product: [], position: 0, page: 0));
                                context
                                    .read<GetCartQuantityBloc>()
                                    .add(GetCartQuantityStarted());
                              })
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return _arrivals.isEmpty
                        ? Opacity(opacity: 0)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "New Arrivals",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              // Opacity(opacity: 0)
                              TextButton(
                                onPressed: () => {
                                  AutoRouter.of(context)
                                      .push(NewArrivalScreenRoute())
                                      .then((value) {
                                    context.read<ProductPaginatedBloc>().add(
                                        GetProductPaginatedUpdate(
                                            product: [], position: 0, page: 0));
                                    context.read<NewArrivalsBloc>().add(
                                        UpdateNewArrivals(
                                            product: [], position: 0, page: 0));
                                    context
                                        .read<GetCartQuantityBloc>()
                                        .add(GetCartQuantityStarted());
                                  })
                                },
                                child: Text(
                                  "View All",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                  },
                ),
                BlocBuilder<NewArrivalsBloc, NewArrivalsState>(
                  builder: (context, state) {
                    if (state is NewArrivalsLoading) {
                      return Container(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (c, i) => Card(
                            margin: EdgeInsets.all(2),
                            child: Container(
                              width: 150,
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[200]!,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        // child: _prod[i].product_images.isEmpty
                                        child: Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.fill,
                                        ),
                                        // : FadeInImage.assetNetwork(
                                        //     fit: BoxFit.fill,
                                        //     imageErrorBuilder: (c, s, o) =>
                                        //         Image.asset(
                                        //       "assets/images/placeholder.png",
                                        //       fit: BoxFit.fill,
                                        //     ),
                                        //     placeholder:
                                        //         "assets/images/placeholder.png",
                                        //     image: IMAGE_URL +
                                        //         _prod[i]
                                        //             .product_images
                                        //             .first
                                        //             .image!,
                                        //   ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    // flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[500]!,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                "Loading",
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[400]!,
                                              highlightColor: Colors.white,
                                              child: Text(
                                                "Loading",
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    //!SUCCESS
                    return _arrivals.isEmpty
                        ? Opacity(opacity: 0)
                        : Container(
                            height: 170,
                            child: Scrollbar(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: _arrivals.length,
                                itemBuilder: (c, i) => GestureDetector(
                                  onTap: () {
                                    AutoRouter.of(context)
                                        .push(ProductDetailsScreenRoute(
                                      detailsArguments: ProductDetailsArguments(
                                          product: _arrivals[i],
                                          initialValue:
                                              _arrivals[i].cartQty ?? 0),
                                    ))
                                        .then((value) {
                                      context.read<ProductPaginatedBloc>().add(
                                          GetProductPaginatedUpdate(
                                              product: [],
                                              position: 0,
                                              page: 0));
                                      context.read<NewArrivalsBloc>().add(
                                          UpdateNewArrivals(
                                              product: [],
                                              position: 0,
                                              page: 0));
                                      context
                                          .read<GetCartQuantityBloc>()
                                          .add(GetCartQuantityStarted());
                                    });
                                  },
                                  child: Card(
                                    margin: i != 0
                                        ? EdgeInsets.symmetric(horizontal: 2)
                                        : EdgeInsets.only(right: 2),
                                    elevation: 0,
                                    child: Container(
                                      width: _cardWidth,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            fit: FlexFit.tight,
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              constraints: BoxConstraints(
                                                minHeight: 50,
                                              ),
                                              child: _arrivals[i]
                                                      .product_images
                                                      .isEmpty
                                                  ? Image.asset(
                                                      "assets/images/placeholder.png",
                                                      fit: BoxFit.fill,
                                                    )
                                                  // : FadeInImage.assetNetwork(
                                                  //     fit: BoxFit.fill,
                                                  //     imageErrorBuilder: (c, s, o) =>
                                                  //         Image.asset(
                                                  //       "assets/images/placeholder.png",
                                                  //       fit: BoxFit.fill,
                                                  //     ),
                                                  //     placeholder:
                                                  //         "assets/images/placeholder.png",
                                                  // image: IMAGE_URL +
                                                  //     _arrivals[i]
                                                  //         .product_images
                                                  //         .first
                                                  //         .image!,
                                                  //   ),
                                                  : CachedNetworkImage(
                                                      errorWidget: (c, s, o) =>
                                                          Image.asset(
                                                        "assets/images/placeholder.png",
                                                      ),
                                                      fit: BoxFit.fill,
                                                      imageUrl: IMAGE_URL +
                                                          _arrivals[i]
                                                              .product_images
                                                              .first
                                                              .image!,
                                                      placeholderFadeInDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  400),
                                                      fadeInDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  400),
                                                      placeholder: (c, s) =>
                                                          Image.asset(
                                                        "assets/images/placeholder.png",
                                                      ),
                                                    ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.all(5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${_arrivals[i].name}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 9.0,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${_arrivals[i].price_s}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FavouriteWidget(
                                                  isFav: _arrivals[i]
                                                          .isFavourite ??
                                                      false,
                                                  id: _arrivals[i].id,
                                                ),
                                                CartSingleWidget(
                                                  product: _arrivals[i],
                                                  cartQty:
                                                      _arrivals[i].cartQty ?? 0,
                                                  id: _arrivals[i].id,
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
                            ),
                          );
                  },
                ),

                SizedBox(
                  height: 5,
                ),
                //!PRODUCTS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Products",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: TextButton(
                        onPressed: () => {
                          AutoRouter.of(context)
                              .push(ViewMoreScreenRoute())
                              .then((value) {
                            context.read<ProductPaginatedBloc>().add(
                                GetProductPaginatedUpdate(
                                    product: [], position: 0, page: 0));
                            context.read<NewArrivalsBloc>().add(
                                UpdateNewArrivals(
                                    product: [], position: 0, page: 0));
                            context
                                .read<GetCartQuantityBloc>()
                                .add(GetCartQuantityStarted());
                          }),
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<ProductPaginatedBloc, ProductPaginatedState>(
                  builder: (context, state) {
                    if (state is ProductPaginatedLoading) {
                      return GridView.builder(
                          itemCount: 4,
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150,
                            childAspectRatio: 2 / 2.5,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
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
                                    child: Shimmer.fromColors(
                                      highlightColor: Colors.white,
                                      baseColor: Colors.grey[100]!,
                                      child: Container(
                                        margin: EdgeInsets.all(20),
                                        constraints: BoxConstraints(
                                          minHeight: 50,
                                        ),
                                        child: Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.fill,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Shimmer.fromColors(
                                              highlightColor: Colors.white,
                                              baseColor: Colors.grey[200]!,
                                              child: Text(
                                                "Loading...",
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ),
                                            Shimmer.fromColors(
                                              highlightColor: Colors.white,
                                              baseColor: Colors.grey[200]!,
                                              child: Text(
                                                "Loading...",
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                    if (state is ProductPaginatedSuccess) {
                      // final _cardWidth = _prodCard.currentContext?.size?.width;
                      // print("CARD WIDTH: $_cardWidth");
                    }
                    //SUCCESS
                    return GestureDetector(
                      child: GridView.builder(
                        itemCount: _products.length,
                        shrinkWrap: true,
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          childAspectRatio: 2 / 3,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          String imageEnd = '';
                          final bool isFav =
                              _products[index].isFavourite ?? false;
                          if (_products[index].product_images.length > 0) {
                            imageEnd = IMAGE_URL +
                                _products[index].product_images[0].image!;
                          } else {
                            imageEnd =
                                'https://image.freepik.com/free-vector/empty-concept-illustration_114360-1253.jpg';
                          }
                          return GestureDetector(
                            onTap: () {
                              AutoRouter.of(context)
                                  .push(ProductDetailsScreenRoute(
                                detailsArguments: ProductDetailsArguments(
                                    product: _products[index],
                                    initialValue:
                                        _products[index].cartQty ?? 0),
                              ))
                                  .then((value) {
                                context.read<ProductPaginatedBloc>().add(
                                    GetProductPaginatedUpdate(
                                        product: [], position: 0, page: 0));
                                context.read<NewArrivalsBloc>().add(
                                    UpdateNewArrivals(
                                        product: [], position: 0, page: 0));
                                context
                                    .read<GetCartQuantityBloc>()
                                    .add(GetCartQuantityStarted());
                              });
                            },
                            child: Card(
                              // key: _prodCard,
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
                                      // child: FadeInImage.assetNetwork(
                                      //     fit: BoxFit.fill,
                                      //     imageErrorBuilder: (c, s, o) =>
                                      //         Image.asset(
                                      //           "assets/images/placeholder.png",
                                      //           fit: BoxFit.fill,
                                      //         ),
                                      //     placeholder:
                                      //         "assets/images/placeholder.png",
                                      //     image: imageEnd),
                                      child: CachedNetworkImage(
                                        errorWidget: (c, s, o) => Image.asset(
                                          "assets/images/placeholder.png",
                                        ),
                                        fit: BoxFit.fill,
                                        imageUrl: imageEnd,
                                        placeholderFadeInDuration:
                                            const Duration(milliseconds: 400),
                                        fadeInDuration:
                                            const Duration(milliseconds: 400),
                                        placeholder: (c, s) => Image.asset(
                                          "assets/images/placeholder.png",
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                            _products[index].name ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 9.0,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          Text(
                                            "${_products[index].price_s}",
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
                                          isFav: _products[index].isFavourite ??
                                              false,
                                          id: _products[index].id,
                                        ),
                                        CartSingleWidget(
                                          product: _products[index],
                                          cartQty:
                                              _products[index].cartQty ?? 0,
                                          id: _products[index].id,
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
                SizedBox(height: 30)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
