import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/features/presentation/bloc/description_bloc/description_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/related/related_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/slabs/slabs_bloc.dart';
import 'package:biz_mobile_app/features/presentation/screens/home/widgets/cart_single_widget.dart';
import 'package:biz_mobile_app/features/presentation/screens/home/widgets/favourite_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/core/utils/debouncer.dart';
import 'package:biz_mobile_app/core/utils/hex_color.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/domain/models/Products/slabs_model.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_cart_quantity/get_cart_quantity_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/price_level/price_level_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/single_product/single_product_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/default_button.dart';
import 'package:biz_mobile_app/features/presentation/components/rounded_icon_btn.dart';

class ProductDetailsScreen extends StatefulWidget {
  static String routeName = "/details";

  final ProductDetailsArguments detailsArguments;

  const ProductDetailsScreen({Key? key, required this.detailsArguments})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with AutomaticKeepAliveClientMixin {
  late final _htmlKey = GlobalKey();
  late final _singleProductBloc = getIt<SingleProductBloc>();
  late final _addToFav = getIt<AddRemoveToFavBloc>();
  late final _addToCartBloc = getIt<AddToCartBloc>();
  late final _priceBloc = getIt<PriceLevelBloc>();
  late final _slabsBloc = getIt<SlabsBloc>();
  late final _descBloc = getIt<DescriptionBloc>();
  late final _relatedBloc = getIt<RelatedBloc>();
  late final _debouncer = Debouncer(milliseconds: 500);
  late final PageController _pageController = PageController(initialPage: 0);

  Size? _sizeRed;
  double? size;
  int quantity = 0;
  ProductModel? _product;
  List<ProductModel> _related = [];
  List<SlabsModel> _slabs = [];
  int _currentPage = 0;
  TextEditingController _controller = TextEditingController();
  // SlabsModel? _slabs;
  double _height = 0;
  String _desc = '';
  String _priceLevel = "";

  @override
  void initState() {
    super.initState();
    _product = widget.detailsArguments.product;
    _controller = TextEditingController(
        text: widget.detailsArguments.initialValue.toString());
    _slabsBloc.add(GetSlabsStarted(
      prodId:
          widget.detailsArguments.product?.id ?? widget.detailsArguments.id!,
    ));
    _singleProductBloc.add(
      GetSingleProductStarted(
        productId:
            widget.detailsArguments.product?.id ?? widget.detailsArguments.id!,
      ),
    );
    _descBloc.add(DescriptionStarted(
      prodId:
          widget.detailsArguments.product?.id ?? widget.detailsArguments.id!,
    ));
    _relatedBloc.add(GetRelatedStarted(
      prodId:
          widget.detailsArguments.product?.id ?? widget.detailsArguments.id!,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _slabsBloc.close();
    _priceBloc.close();
    _singleProductBloc.close();
    _addToFav.close();
    _addToCartBloc.close();
    _descBloc.close();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Size size = MediaQuery.of(context).size;

    // final ProductDetailsArguments agrs =
    //     ModalRoute.of(context).settings.arguments;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _singleProductBloc),
        BlocProvider(create: (context) => _addToCartBloc),
        BlocProvider(create: (context) => _addToFav),
        BlocProvider(create: (create) => _priceBloc),
        BlocProvider(create: (create) => _slabsBloc),
        BlocProvider(create: (create) => _descBloc),
        BlocProvider(create: (create) => _relatedBloc)
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RelatedBloc, RelatedState>(
            listener: (context, state) {
              if (state is RelatedSuccess) {
                _related = state.related;
              }
            },
          ),
          BlocListener<SlabsBloc, SlabsState>(
            listener: (context, state) {
              if (state is SlabsSuccess) {
                _slabs = state.slabs;
                print("SLABS: $_slabs");
              }
            },
          ),
          BlocListener<DescriptionBloc, DescriptionState>(
            listener: (context, state) {
              if (state is DescriptionSuccess) {
                _desc = state.desc;
              }
            },
          ),
          BlocListener<AddRemoveToFavBloc, AddRemoveToFavState>(
            listener: (context, state) {
              if (state is AddRemoveToFavSuccess) {
                _singleProductBloc.add(
                  UpdateSingleProductStarted(productId: _product!.id),
                );
              }
            },
          ),
          BlocListener<PriceLevelBloc, PriceLevelState>(
            listener: (context, state) {
              if (state is PriceLevelSuccess) {
                _priceLevel = state.price;
              }
            },
          ),
          BlocListener<SingleProductBloc, SingleProductState>(
            listener: (context, state) {
              if (state is SingleProductSuccess) {
                _product =
                    state.response.product ?? widget.detailsArguments.product;
                quantity =
                    _product?.cartQty ?? widget.detailsArguments.initialValue;
                _related = state.response.related;
                _controller = TextEditingController(
                    text: state.response.product?.cartQty.toString());

                _priceBloc.add(GetPriceLevelEvent(
                  prodId: state.response.product!.id,
                  qty:
                      _product?.cartQty ?? widget.detailsArguments.initialValue,
                  price: state.response.product!.price!,
                ));

                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                  _sizeRed = _htmlKey.currentContext?.size;
                  print("SIZE of Red: $_sizeRed");
                  print("Height of Red: ${_sizeRed?.height}");

                  // if (_sizeRed != null) {
                  setState(() {
                    _height = _sizeRed!.height;
                  });
                  print("Height Size: $_height");
                  // }
                });
                // print("Height Size: $_height");
              }
              if (state is SingleProductError) {
                print("SINGLE PRODUCT ERROR: ${state.message}");
              }
            },
          ),
          BlocListener<AddToCartBloc, AddToCartState>(
            listener: (context, state) {
              if (state is AddToCartLoading) {
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
              if (state is AddToCartSuccess) {
                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                  if (_related.isNotEmpty) {
                    AutoRouter.of(context).popAndPush(ProductDetailsScreenRoute(
                      detailsArguments: ProductDetailsArguments(
                          product: _related[0],
                          initialValue: _related[0].cartQty ?? 0),
                    ));
                    // .then(
                    //   (value) => context.read<DashboardBloc>()
                    //     ..add(UpdateDashBoardEvent()),
                    // );
                  }
                  print("Sasa Related Is Empty");
                });
                context
                    .read<GetCartQuantityBloc>()
                    .add(GetCartQuantityStarted());
                ScaffoldMessenger.maybeOf(context)!
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      content: Text(
                        state.message,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                // Navigator.of(context).pop();
                _singleProductBloc.add(
                  UpdateSingleProductStarted(productId: _product!.id),
                );
                print("Succeeess yeeeii");
              }
              if (state is AddToCartError) {
                ScaffoldMessenger.maybeOf(context)!
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      content: Text(
                        state.message,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            automaticallyImplyLeading: true,
            // elevation: 0,
            title: Text("Details"),
          ),
          body: BlocBuilder<SingleProductBloc, SingleProductState>(
            builder: (context, state) {
              if (state is SingleProductLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        if (_product == null ||
                            _product!.product_images.isEmpty)
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
                                  placeholder: "assets/images/placeholder.png",
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
                        if (_product != null &&
                            _product!.product_images.isNotEmpty)
                          Container(
                            height: 220,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: StreamBuilder<Object>(
                              stream: Stream.periodic(Duration(seconds: 8))
                                  .asyncMap((event) => _controlSlider()),
                              builder: (context, snapshot) => PageView.builder(
                                itemCount: _product!.product_images.length,
                                controller: _pageController,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    AutoRouter.of(context)
                                        .push(PictureScreenRoute(
                                      image: _product!.product_images[index],
                                      images: _product!.product_images,
                                    ));
                                  },
                                  child: Card(
                                    elevation: 0,
                                    child: Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: FadeInImage.assetNetwork(
                                          imageErrorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            "assets/images/placeholder.png",
                                          ),
                                          placeholder:
                                              "assets/images/placeholder.png",
                                          image: IMAGE_URL +
                                              _product!
                                                  .product_images[index].image!,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10),
                    //!HAPA BUDDA
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
                                _product?.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              _product?.brand != null
                                  ? RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: "Brand: ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: "${_product?.brand}",
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        )
                                      ]),
                                    )
                                  : Opacity(opacity: 0),
                              SizedBox(height: 10),
                              Text(
                                _product?.price_s?.toUpperCase() ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              SizedBox(height: 5),
                              _product != null && _product!.colors.isNotEmpty
                                  ? Column(
                                      children: [
                                        Text(
                                          "Colors",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              ?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Container(
                                          height: 20,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (c, i) => Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: HexColor(
                                                    "${_product!.colors[i].color}"),
                                              ),
                                            ),
                                            separatorBuilder: (c, i) =>
                                                SizedBox(
                                              width: 5,
                                            ),
                                            itemCount: _product!.colors.length,
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
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            key: _htmlKey,
                            width: double.infinity,
                            // height: 150,
                            decoration: BoxDecoration(),
                            constraints: BoxConstraints(
                              maxHeight: 150,
                              minHeight: 20,
                            ),
                            // alignment: Alignment.bottomCenter,
                            child: Text(_product?.briefDescription ?? "")),
                      ),
                    ),
                    BlocBuilder<DescriptionBloc, DescriptionState>(
                      builder: (context, state) {
                        return MaterialButton(
                          onPressed: () => AutoRouter.of(context).push(
                            SeeMoreDetailsRoute(data: _desc),
                          ),
                          child: Text("See More Details"),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
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
                                LengthLimitingTextInputFormatter(4),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              controller: _controller,
                              onChanged: (String? value) {
                                quantity = int.parse(value ?? "0");
                                _debouncer.run(() =>
                                    _priceBloc.add(GetPriceLevelEvent(
                                      prodId: _product!.id,
                                      qty: int.parse(_controller.text.trim()),
                                      price: _product!.price!,
                                    )));
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RoundedIconBtn(
                            icon: Icons.remove,
                            press: () {
                              if (quantity != 0) {
                                setState(() {
                                  quantity = quantity - 1;
                                });
                              } else {
                                setState(() {
                                  quantity = quantity;
                                });
                              }
                              _controller = TextEditingController(
                                  text: quantity.toString());
                              _debouncer
                                  .run(() => _priceBloc.add(GetPriceLevelEvent(
                                        prodId: _product!.id,
                                        qty: int.parse(_controller.text.trim()),
                                        price: _product!.price!,
                                      )));
                            },
                          ),
                          SizedBox(width: 10),
                          RoundedIconBtn(
                            icon: Icons.add,
                            showShadow: true,
                            press: () {
                              setState(() {
                                quantity = quantity + 1;
                              });
                              _controller = TextEditingController(
                                  text: quantity.toString());
                              _debouncer
                                  .run(() => _priceBloc.add(GetPriceLevelEvent(
                                        prodId: _product!.id,
                                        qty: int.parse(_controller.text.trim()),
                                        price: _product!.price!,
                                      )));
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<PriceLevelBloc, PriceLevelState>(
                            builder: (context, state) {
                              return RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Price Level: ",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    state is PriceLevelLoading
                                        ? TextSpan(
                                            text: "loading...",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          )
                                        : TextSpan(
                                            text: "$_priceLevel",
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            },
                          ),
                          BlocBuilder<SlabsBloc, SlabsState>(
                            builder: (context, state) {
                              if (state is SlabsLoading) {
                                return Text("Loading...");
                              }
                              return MaterialButton(
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (builder) => Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columnSpacing: 8,
                                        columns: [
                                          DataColumn(label: Text("From-To")),
                                          DataColumn(label: Text("Rate")),
                                          DataColumn(label: Text("Dsc(Amt)")),
                                          DataColumn(label: Text("Dsc(%)")),
                                        ],
                                        rows: _slabs
                                            .map(
                                              (e) => DataRow(
                                                cells: [
                                                  DataCell(
                                                    Text("${e.min}-${e.max}"),
                                                  ),
                                                  DataCell(
                                                    Text("${e.rate}"),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        "${e.discountAmmount}"),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                        "${e.discountPercent}"),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                                child: Text("View Price Levels"),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DefaultButton(
                        text: widget.detailsArguments.initialValue != 0
                            ? "Update Cart"
                            : "Add To Cart",
                        press: () {
                          if (quantity != 0) {
                            _addToCartBloc.add(
                              AddToCartStarted(
                                product: widget.detailsArguments.product!,
                                qty: quantity.toString(),
                                action:
                                    widget.detailsArguments.initialValue != 0
                                        ? "update"
                                        : "add",
                                prodId: widget.detailsArguments.product!.id,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.maybeOf(context)!
                              ..hideCurrentSnackBar();
                            showSimpleNotification(
                              Text("Invalid quantity"),
                              background: Colors.red,
                              position: NotificationPosition.bottom,
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "RELATED PRODUCTS",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<RelatedBloc, RelatedState>(
                      builder: (context, state) {
                        return BlocBuilder<AddToCartBloc, AddToCartState>(
                          builder: (context, state) => _related.isEmpty
                              ? Container()
                              : GridView.builder(
                                  // margin: EdgeInsets.all(5),
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),

                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150,
                                    childAspectRatio: 2 / 3,
                                  ),
                                  itemCount: _related.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        AutoRouter.of(context)
                                            .popAndPush(
                                                ProductDetailsScreenRoute(
                                              detailsArguments:
                                                  ProductDetailsArguments(
                                                      product: _related[index],
                                                      initialValue:
                                                          _related[index]
                                                                  .cartQty ??
                                                              0),
                                            ))
                                            .then((value) => {}
                                                // context.read<DashboardBloc>()
                                                //   ..add(UpdateDashBoardEvent()),
                                                );
                                      },
                                      child: Card(
                                        margin: EdgeInsets.all(2),
                                        elevation: 0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              flex: 3,
                                              fit: FlexFit.tight,
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                constraints: BoxConstraints(
                                                  minHeight: 50,
                                                ),
                                                child: _related[index]
                                                        .product_images
                                                        .isEmpty
                                                    ? Image.asset(
                                                        "assets/images/placeholder.png",
                                                        fit: BoxFit.fill,
                                                      )
                                                    : FadeInImage.assetNetwork(
                                                        fit: BoxFit.fill,
                                                        imageErrorBuilder:
                                                            (c, s, o) =>
                                                                Image.asset(
                                                          "assets/images/placeholder.png",
                                                          fit: BoxFit.fill,
                                                        ),
                                                        placeholder:
                                                            "assets/images/placeholder.png",
                                                        image: IMAGE_URL +
                                                            _related[index]
                                                                .product_images
                                                                .first
                                                                .image!,
                                                      ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              // flex: 1,
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        _related[index].name ??
                                                            "",
                                                        style: TextStyle(
                                                          fontSize: 9.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${_related[index].price_s}",
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  FavouriteWidget(
                                                    isFav: _related[index]
                                                            .isFavourite ??
                                                        false,
                                                    id: _related[index].id,
                                                  ),
                                                  CartSingleWidget(
                                                    product: _related[index],
                                                    cartQty: _related[index]
                                                            .cartQty ??
                                                        0,
                                                    id: _related[index].id,
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
                  ],
                ),
              );
            },
          ),
          // body: Body(
          //   product: detailsArguments.product,
          //   initialQuanty: detailsArguments.initialValue,
          //   id: detailsArguments.id,
          // ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProductDetailsArguments {
  final ProductModel? product;
  final int initialValue;
  final int? id;
  ProductDetailsArguments({
    required this.product,
    required this.initialValue,
    this.id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductDetailsArguments &&
        other.product == product &&
        other.initialValue == initialValue &&
        other.id == id;
  }

  @override
  int get hashCode => product.hashCode ^ initialValue.hashCode ^ id.hashCode;

  @override
  String toString() =>
      'ProductDetailsArguments(product: $product, initialValue: $initialValue, id: $id)';
}
