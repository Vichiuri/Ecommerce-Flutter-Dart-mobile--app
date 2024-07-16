import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/core/utils/hex_color.dart';
import 'package:biz_mobile_app/core/utils/parse_date.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_offer_to_cart/add_offer_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_cart_quantity/get_cart_quantity_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/single_offer/single_offer_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/default_button.dart';
import 'package:biz_mobile_app/features/presentation/components/error_widget.dart';
import 'package:biz_mobile_app/features/presentation/components/rounded_icon_btn.dart';
import 'package:biz_mobile_app/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

//
class OfferDetailScreen extends StatefulWidget {
  final int offerId;
  final int? initialQuantity;

  const OfferDetailScreen({
    Key? key,
    required this.offerId,
    this.initialQuantity,
  }) : super(key: key);

  @override
  _OfferDetailScreenState createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  String title = "";
  OfferModel? initialOffer;
  int quantity = 0;
  int number = 0;
  List<OfferModel> _offers = [];
  PageController _pageController = PageController(initialPage: 0);
  late final _offerController = ScrollController();
  int _currentPage = 0;

  TextEditingController _offerInput = TextEditingController();

  AddOfferToCartBloc bloc = getIt<AddOfferToCartBloc>();
  SingleOfferBloc _singleOfferBloc = getIt<SingleOfferBloc>();

  @override
  void initState() {
    _singleOfferBloc.add(GetSingleOfferStarted(
      offerId: widget.offerId,
    ));
    // initialOffer = widget.model;

    super.initState();
  }

  @override
  void dispose() {
    _singleOfferBloc.close();
    _pageController.dispose();
    _offerController.dispose();
    bloc.close();
    _offerInput.dispose();
    super.dispose();
  }

  _controlSlider() {
    if (_currentPage < 5) {
      if (_pageController.hasClients) {
        _currentPage++;
      }
    } else {
      if (_pageController.hasClients) {
        _currentPage = 0;
      }
    }

    _pageController.animateToPage(
      _currentPage,
      duration: Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
  }

  // @override
  // void didUpdateWidget(OfferDetailScreen oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }

  //TODO offers price
  //TODO refresh homepage
  //TODO offer to nav firebase
  //TODO offer price

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => bloc),
        BlocProvider(create: (context) => _singleOfferBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SingleOfferBloc, SingleOfferState>(
            listener: (context, state) {
              if (state is SingleOfferSuccess) {
                _offers = state.respose.otherOffers ?? [];
                if (_offers.isNotEmpty) {
                  initialOffer = _offers.singleWhere(
                    (element) => element.id == widget.offerId,
                  );
                }
                number = initialOffer?.xAmt ?? 0;
                quantity = widget.initialQuantity ?? number;
                setState(() {
                  title = initialOffer?.name ?? "";
                });
                _offerInput = TextEditingController(text: quantity.toString());

                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                  if (_offers.isNotEmpty) {
                    final _index = _offers.indexWhere(
                      (element) => element.id == widget.offerId,
                    );
                    if (_offerController.hasClients) {
                      _offerController.animateTo(
                        120 * _index.toDouble(),
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    }
                  }
                });
              }
            },
          ),
          BlocListener<AddOfferToCartBloc, AddOfferToCartState>(
            listener: (context, state) {
              if (state is AddOfferToCartSuccess) {
                context
                    .read<GetCartQuantityBloc>()
                    .add(GetCartQuantityStarted());
                ScaffoldMessenger.maybeOf(context)!.hideCurrentSnackBar();
                print("Places");
                Navigator.of(context).pop();
                showSimpleNotification(
                  Text("Added Successfully"),
                  position: NotificationPosition.bottom,
                  background: Colors.greenAccent,
                  duration: Duration(seconds: 1),
                );
              }
              if (state is AddOfferToCartLoading) {
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
              if (state is AddOfferToCartError) {
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                showSimpleNotification(
                  Text(state.message),
                  position: NotificationPosition.bottom,
                  background: Colors.red,
                  duration: Duration(seconds: 1),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
          ),
          body: BlocBuilder<SingleOfferBloc, SingleOfferState>(
            builder: (context, state) {
              if (state is SingleOfferLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SingleOfferInitial) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SingleOfferError) {
                return DashboardErrorWidget(
                  refresh: () => _singleOfferBloc.add(GetSingleOfferStarted(
                    offerId: widget.offerId,
                  )),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          //!hapa

                          Container(
                            // clipBehavior: Clip.antiAliasWithSaveLayer,
                            height: MediaQuery.of(context).size.height * 0.2,
                            margin: EdgeInsets.all(8),
                            width: double.infinity,
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  "assets/images/placeholder_rectangle.png",
                              image: IMAGE_URL + initialOffer!.pic,
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                "assets/images/placeholder_rectangle.png",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "PRODUCT",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          //!HAPA MSEE

                          // Container(
                          //   height: 150,
                          //   constraints: BoxConstraints(maxHeight: 200),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Expanded(
                          //         child: Column(
                          //           children: [
                          //             initialOffer!.xItem.product_images.isEmpty
                          //                 ? Container(
                          //                     clipBehavior:
                          //                         Clip.antiAliasWithSaveLayer,
                          //                     height: 100,
                          //                     margin: EdgeInsets.all(8),
                          //                     width: 100,
                          //                     decoration: BoxDecoration(
                          //                       borderRadius:
                          //                           BorderRadius.circular(10),
                          //                       image: DecorationImage(
                          //                         image: AssetImage(
                          //                           "assets/images/placeholder_rectangle.png",
                          //                         ),
                          //                         fit: BoxFit.contain,
                          //                       ),
                          //                     ),
                          //                   )
                          //                 : Container(
                          //                     clipBehavior:
                          //                         Clip.antiAliasWithSaveLayer,
                          //                     height: 100,
                          //                     margin: EdgeInsets.all(8),
                          //                     width: 100,
                          //                     decoration: BoxDecoration(
                          //                       borderRadius:
                          //                           BorderRadius.circular(10),
                          //                       image: DecorationImage(
                          //                         image: NetworkImage(
                          //                           IMAGE_URL +
                          //                               initialOffer!
                          //                                   .xItem
                          //                                   .product_images
                          //                                   .first
                          //                                   .image!,
                          //                         ),
                          //                         fit: BoxFit.contain,
                          //                       ),
                          //                     ),
                          //                   ),
                          //             Expanded(
                          //                 child: Text(
                          //               initialOffer!.xItem.name ?? "",
                          //             )),
                          //           ],
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          //       initialOffer?.yItem != null
                          //           ? Expanded(
                          //               child: Column(
                          //                 children: [
                          //                   Container(
                          //                     clipBehavior:
                          //                         Clip.antiAliasWithSaveLayer,
                          //                     height: 100,
                          //                     margin: EdgeInsets.all(8),
                          //                     width: 100,
                          //                     decoration: BoxDecoration(
                          //                       borderRadius:
                          //                           BorderRadius.circular(10),
                          //                       image: DecorationImage(
                          //                         image: NetworkImage(
                          //                           IMAGE_URL +
                          //                               initialOffer!
                          //                                   .yItem!
                          //                                   .product_images
                          //                                   .first
                          //                                   .image!,
                          //                         ),
                          //                         fit: BoxFit.contain,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Expanded(
                          //                       child: Text(
                          //                           initialOffer!.yItem!.name ?? ""))
                          //                 ],
                          //               ),
                          //             )
                          //           : Container(),
                          //       // initialOffer.yItem != null
                          //       //     ?
                          //       //     : Container(),
                          //     ],
                          //   ),
                          // ),
                          //! Stack()
                          Stack(
                            children: [
                              if (initialOffer == null ||
                                  initialOffer!.xItem.product_images.isEmpty)
                                Container(
                                  height: 220,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Card(
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/images/placeholder.png",
                                        image: EMPTY_IMAGE_URL,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          "assets/images/placeholder.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (initialOffer != null &&
                                  initialOffer!.xItem.product_images.isNotEmpty)
                                Container(
                                  height: 220,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: StreamBuilder<Object>(
                                    stream: Stream.periodic(
                                            Duration(seconds: 8))
                                        .asyncMap((event) => _controlSlider()),
                                    builder: (context, snapshot) =>
                                        PageView.builder(
                                      itemCount: initialOffer!
                                          .xItem.product_images.length,
                                      controller: _pageController,
                                      itemBuilder: (context, index) => Card(
                                        elevation: 0,
                                        child: Padding(
                                            padding: const EdgeInsets.all(30.0),
                                            child: FadeInImage.assetNetwork(
                                              imageErrorBuilder: (context,
                                                      error, stackTrace) =>
                                                  Image.asset(
                                                "assets/images/placeholder.png",
                                              ),
                                              placeholder:
                                                  "assets/images/placeholder.png",
                                              image: IMAGE_URL +
                                                  initialOffer!
                                                      .xItem
                                                      .product_images[index]
                                                      .image!,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Card(
                            elevation: 0,
                            child: Container(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      initialOffer?.xItem.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    initialOffer?.xItem.brand != null
                                        ? RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: "Brand: ",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${initialOffer?.xItem.brand}",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              )
                                            ]),
                                          )
                                        : Opacity(opacity: 0),
                                    SizedBox(height: 10),
                                    Text(
                                      initialOffer?.xItem.price_s
                                              ?.toUpperCase() ??
                                          "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    SizedBox(height: 5),
                                    initialOffer != null &&
                                            initialOffer!
                                                .xItem.colors.isNotEmpty
                                        ? Column(
                                            children: [
                                              Text(
                                                "Colors",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    ?.copyWith(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              Container(
                                                height: 20,
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (c, i) =>
                                                      Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: HexColor(
                                                          "${initialOffer!.xItem.colors[i].color}"),
                                                    ),
                                                  ),
                                                  separatorBuilder: (c, i) =>
                                                      SizedBox(
                                                    width: 5,
                                                  ),
                                                  itemCount: initialOffer!
                                                      .xItem.colors.length,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Opacity(opacity: 0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "PRODUCT DETAILS",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Card(
                            elevation: 0,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  // key: _htmlKey,
                                  width: double.infinity,
                                  // height: 150,
                                  decoration: BoxDecoration(),
                                  constraints: BoxConstraints(
                                    maxHeight: 150,
                                    minHeight: 20,
                                  ),
                                  // alignment: Alignment.bottomCenter,
                                  child: Text(
                                      initialOffer?.xItem.briefDescription ??
                                          "")),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () => AutoRouter.of(context).push(
                              SeeMoreDetailsRoute(
                                data: initialOffer?.xItem.description ?? "",
                              ),
                            ),
                            child: Text("See More Details"),
                          ),

                          SizedBox(height: 10),
                          initialOffer != null &&
                                  initialOffer!.scheme == BUYXYFREE
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        "FREE PRODUCT",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Stack(
                                      children: [
                                        if (initialOffer?.yItem == null ||
                                            initialOffer!
                                                .yItem!.product_images.isEmpty)
                                          Container(
                                            height: 220,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: Card(
                                              elevation: 0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(30.0),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      "assets/images/placeholder.png",
                                                  image: EMPTY_IMAGE_URL,
                                                  imageErrorBuilder: (context,
                                                          error, stackTrace) =>
                                                      Image.asset(
                                                    "assets/images/placeholder.png",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (initialOffer?.yItem != null &&
                                            initialOffer!.yItem!.product_images
                                                .isNotEmpty)
                                          Container(
                                            height: 220,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: StreamBuilder<Object>(
                                              stream: Stream.periodic(
                                                      Duration(seconds: 8))
                                                  .asyncMap((event) =>
                                                      _controlSlider()),
                                              builder: (context, snapshot) =>
                                                  PageView.builder(
                                                itemCount: initialOffer!.yItem!
                                                    .product_images.length,
                                                controller: _pageController,
                                                itemBuilder: (context, index) =>
                                                    Card(
                                                  elevation: 0,
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              30.0),
                                                      child: FadeInImage
                                                          .assetNetwork(
                                                        imageErrorBuilder:
                                                            (context, error,
                                                                    stackTrace) =>
                                                                Image.asset(
                                                          "assets/images/placeholder.png",
                                                        ),
                                                        placeholder:
                                                            "assets/images/placeholder.png",
                                                        image: IMAGE_URL +
                                                            initialOffer!
                                                                .yItem!
                                                                .product_images[
                                                                    index]
                                                                .image!,
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Card(
                                      elevation: 0,
                                      child: Container(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                initialOffer?.yItem?.name ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    ?.copyWith(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              initialOffer?.yItem?.brand != null
                                                  ? RichText(
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                          text: "Brand: ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              "${initialOffer?.yItem?.brand}",
                                                          style: TextStyle(
                                                            color: Colors.blue,
                                                          ),
                                                        )
                                                      ]),
                                                    )
                                                  : Opacity(opacity: 0),
                                              SizedBox(height: 10),
                                              Text(
                                                initialOffer?.yItem?.price_s
                                                        ?.toUpperCase() ??
                                                    "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    ?.copyWith(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                              ),
                                              SizedBox(height: 5),
                                              initialOffer?.yItem != null &&
                                                      initialOffer!.yItem!
                                                          .colors.isNotEmpty
                                                  ? Column(
                                                      children: [
                                                        Text(
                                                          "Colors",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .subtitle1
                                                                  ?.copyWith(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          child: ListView
                                                              .separated(
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (c, i) =>
                                                                    Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: HexColor(
                                                                    "${initialOffer!.yItem?.colors[i].color}"),
                                                              ),
                                                            ),
                                                            separatorBuilder:
                                                                (c, i) =>
                                                                    SizedBox(
                                                              width: 5,
                                                            ),
                                                            itemCount:
                                                                initialOffer!
                                                                    .yItem!
                                                                    .colors
                                                                    .length,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Opacity(opacity: 0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        "PRODUCT DETAILS",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Card(
                                      elevation: 0,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            // key: _htmlKey,
                                            width: double.infinity,
                                            // height: 150,
                                            decoration: BoxDecoration(),
                                            constraints: BoxConstraints(
                                              maxHeight: 150,
                                              minHeight: 20,
                                            ),
                                            // alignment: Alignment.bottomCenter,
                                            child: Text(initialOffer
                                                    ?.yItem?.briefDescription ??
                                                "")),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () =>
                                          AutoRouter.of(context).push(
                                        SeeMoreDetailsRoute(
                                          data: initialOffer
                                                  ?.yItem?.description ??
                                              "",
                                        ),
                                      ),
                                      child: Text("See More Details"),
                                    ),
                                  ],
                                )
                              : Opacity(opacity: 0),
                          SizedBox(
                            height: 5,
                          ),
                          Card(
                            elevation: 0,
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    initialOffer!.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    initialOffer!.detailName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("CountDown"),
                                      StreamBuilder(
                                          stream: Stream.periodic(
                                            Duration(seconds: 1),
                                            (i) => i,
                                          ),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<int> snapshot) {
                                            // DateFormat format = DateFormat("mm:ss");
                                            final _estimated = DateTime.parse(
                                              initialOffer!.dateTo,
                                            );
                                            final _now = DateTime.now();
                                            final _remaining =
                                                _estimated.difference(_now);
                                            final dateString =
                                                formatDuration(_remaining);
                                            return Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                dateString.toString(),
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    color: Color(0xFFF6F7F9),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              focusColor: Colors.black,
                                              border: InputBorder.none,
                                              fillColor: Colors.white,
                                              filled: true,
                                            ),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  4),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            keyboardType: TextInputType.number,
                                            controller: _offerInput,
                                            onChanged: (String? value) {},
                                          ),
                                        ),
                                        RoundedIconBtn(
                                          icon: Icons.remove,
                                          press: () {
                                            if (quantity ==
                                                initialOffer!.xAmt) {
                                            } else {
                                              setState(() {
                                                quantity--;
                                              });
                                            }
                                            _offerInput = TextEditingController(
                                                text: quantity.toString());
                                          },
                                          key: new Key(""),
                                        ),
                                        SizedBox(
                                            width: getProportionateScreenWidth(
                                                10)),
                                        RoundedIconBtn(
                                          icon: Icons.add,
                                          showShadow: true,
                                          press: () {
                                            setState(() {
                                              quantity++;
                                            });

                                            _offerInput = TextEditingController(
                                                text: quantity.toString());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  DefaultButton(
                                    text: "Add To Cart",
                                    press: () {
                                      if (int.parse(
                                              _offerInput.text.toString()) <
                                          initialOffer!.xAmt) {
                                        showSimpleNotification(
                                          Text(
                                              "Cannot place ammount less than ${initialOffer!.xAmt}"),
                                          position: NotificationPosition.bottom,
                                          background: Colors.red,
                                        );
                                        return;
                                      }
                                      bloc.add(AddOfferToCartStarted(
                                          offerId: initialOffer!.id,
                                          qty: int.parse(
                                              _offerInput.text.toString())));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OTHER OFFERS",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          _offers.isEmpty
                              ? Container()
                              : Container(
                                  height: 120,
                                  child: ListView.builder(
                                    controller: _offerController,
                                    itemCount: _offers.length,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () {
                                        AutoRouter.of(context)
                                            .popAndPush(OfferDetailScreenRoute(
                                          offerId: _offers[index].id,
                                        ));
                                      },
                                      child: Card(
                                        margin: EdgeInsets.all(1),
                                        child: Container(
                                          width: 120,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(20),
                                                  height: double.maxFinite,
                                                  width: 120,
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        "assets/images/placeholder.png",
                                                    image: IMAGE_URL +
                                                        _offers[index].pic,
                                                    imageErrorBuilder:
                                                        (context, o, s) =>
                                                            Image.asset(
                                                      "assets/images/placeholder.png",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                _offers[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: initialOffer ==
                                                          _offers[index]
                                                      ? Colors.yellow[600]
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
