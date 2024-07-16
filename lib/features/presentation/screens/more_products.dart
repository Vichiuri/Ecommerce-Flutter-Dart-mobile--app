import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/const.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/core/utils/debouncer.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/Category/CategoryModel.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/all_category/all_category_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/product_paginated/product_paginated_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/search_product/search_product_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/big_tip.dart';
import 'package:biz_mobile_app/features/presentation/components/error_paginated.dart';
import 'package:biz_mobile_app/features/presentation/components/icon_animation.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:biz_mobile_app/features/presentation/widgets/bottom_loader.dart';
import 'package:biz_mobile_app/features/presentation/widgets/smooth_star_rating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ViewMoreScreen extends StatefulWidget {
  const ViewMoreScreen({Key? key}) : super(key: key);

  @override
  _ViewMoreScreenState createState() => _ViewMoreScreenState();
}

class _ViewMoreScreenState extends State<ViewMoreScreen> {
  late final _paginatedBloc = getIt<ProductPaginatedBloc>();
  late final _searchBloc = getIt<SearchProductBloc>();
  late final _scrollController = ScrollController();
  late final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late final _categoryBloc = getIt<AllCategoryBloc>();
  late final _minController = TextEditingController();
  late final _maxController = TextEditingController();
  late final _debouncer = Debouncer(milliseconds: 500);
  late TextEditingController _searchController = TextEditingController();
  int _lastPage = 0;
  int _currentPage = 0;
  bool _isNewArrivals = false;
  List<ProductModel> _products = [];
  Completer<void> _refreshCompleter = Completer<void>();
  bool _isLoading = false;
  bool _isBottomLoading = false;
  bool _gridView = false;
  int? max;
  int? min;
  // int? catId;TextEditingCcontroller
  CategoryModel? cat;
  List<CategoryModel> category = [];
  String? _testAnim;

  // late final Widget _listView;

  @override
  void initState() {
    super.initState();

    _isLoading = true;
    _scrollController.addListener(_onsCroll);
    _paginatedBloc
        .add(GetProductPaginatedEvent(product: [], position: 0, page: 1));
    _categoryBloc.add(GetAllCategoryEvent(page: 1));
  }

  @override
  void dispose() {
    _paginatedBloc.close();
    _scrollController.dispose();
    _searchBloc.close();
    _minController.dispose();
    _maxController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onsCroll() {
    late final _maxScroll = _scrollController.position.maxScrollExtent;
    late final _currentScroll = _scrollController.position.pixels;
    if (_currentScroll == _maxScroll) {
      if (_currentPage < _lastPage) {
        _isBottomLoading = true;
        _paginatedBloc.add(GetProductPaginatedEvent(
            product: _products, position: 0, page: _currentPage + 1));
      }
    }
  }

  // BlocProvider
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AddToCartBloc>(),
        ),
        BlocProvider(create: (create) => _paginatedBloc),
        BlocProvider(create: (create) => _searchBloc),
        BlocProvider(
          create: (create) => _categoryBloc,
        )
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener(
            listener: (context, SearchProductState state) {
              if (state is SearchProductSuccess) {
                setState(() {
                  _products = state.products;
                  _isLoading = false;
                });
              }
              if (state is SearchProductError) {
                setState(() {
                  _products = const [];
                  _isLoading = false;
                });
              }
              if (state is SearchProductLoading) {
                setState(() {
                  _products = const [];
                  _isLoading = true;
                });
              }
            },
            bloc: _searchBloc,
          ),
          BlocListener(
            listener: (context, AllCategoryState state) {
              if (state is AllCategorySuccess) {
                category = state.categories;
              }
            },
            bloc: _categoryBloc,
          ),
          BlocListener<ProductPaginatedBloc, ProductPaginatedState>(
            listener: (context, state) {
              if (state is ProductPaginatedSuccess) {
                _isBottomLoading = false;
                _refreshCompleter.complete();
                _refreshCompleter = Completer();
                _isLoading = false;
                _products = [
                  ...state.products,
                  ...state.response.products,
                ];
                _lastPage = state.response.lastPage ?? 0;
                _currentPage = state.response.currentPage ?? 0;
                print("LAST PAGE: $_lastPage");
                print("CURRENT PAGE: $_currentPage");
              }
              if (state is ProductPaginatedError) {
                _isBottomLoading = false;
                _refreshCompleter.complete();
                _refreshCompleter = Completer();
                _isLoading = false;
              }
            },
          ),
        ],
        child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back),
                  ),
                  // Spacer(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          _debouncer.run(() => _searchBloc
                              .add(SearchProductStarted(query: value)));
                        },
                        decoration: InputDecoration(
                          hintText: "Search Products",
                          suffixIcon: IconButton(
                            onPressed: () => showDialog<String?>(
                                context: context,
                                builder: (builder) =>
                                    _SpeechWidget()).then((value) => {
                                  if (value != null)
                                    {
                                      setState(() => _searchController =
                                          TextEditingController(text: value)),
                                      _debouncer.run(() => _searchBloc.add(
                                          SearchProductStarted(
                                              query: _searchController.text
                                                  .trim())))
                                    }
                                }),
                            icon: Icon(Icons.mic),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: const EdgeInsets.all(8.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _gridView = !_gridView;
                        });
                      },
                      icon: Icon(
                        _gridView ? Icons.grid_view : Icons.list,
                      )),
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                    icon: Icon(Icons.sort),
                  ),
                ],
              ),
            ),
          ),
          // appBar: AppBar(
          //   leading: IconButton(
          //       onPressed: () => Navigator.pop(context),
          //       icon: Icon(Icons.arrow_back)),
          //   automaticallyImplyLeading: true,
          //   elevation: 0,
          //   centerTitle: true,
          //   title: Text("All Products"),
          //   bottom: PreferredSize(
          //       child: TextField(), preferredSize: Size.fromHeight(50.0)),
          //   actions: [
          // IconButton(
          //   onPressed: () => showSearch<ProductModel?>(
          //       context: context,
          //       delegate: ProductSearchDelegate(
          //         searchFieldLabel: "Search Products",
          //         bloc: _searchBloc,
          //       )).then((value) {
          //     if (value != null) {
          //       Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => ProductDetailsScreen(
          //           detailsArguments: ProductDetailsArguments(
          //             product: value,
          //             initialValue: value.cartQty ?? 0,
          //           ),
          //         ),
          //       ));
          //     }
          //   }).catchError((e, s) {
          //     print("SEARCH DELEGATE ERROR: $e,$s");
          //   }),
          //   icon: Icon(Icons.search),
          // ),
          // IconButton(
          //     onPressed: () {
          //       setState(() {
          //         _gridView = !_gridView;
          //       });
          //     },
          //     icon: Icon(
          //       _gridView ? Icons.grid_view : Icons.list,
          //     )),
          // IconButton(
          //   onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          //   icon: Icon(Icons.sort),
          // ),
          //   ],
          // ),
          endDrawer: Drawer(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    BlocBuilder<AllCategoryBloc, AllCategoryState>(
                      builder: (context, state) {
                        if (state is AllCategoryLoading) {
                          return CircularProgressIndicator();
                        }
                        return DropdownButton<CategoryModel>(
                            onChanged: (value) {
                              setState(() {
                                cat = value;
                              });
                            },
                            // value: category[0],
                            value: cat,
                            hint: Text("Select Category"),
                            items: category
                                .map(
                                  (e) => DropdownMenuItem<CategoryModel>(
                                    value: e,
                                    child: Text(e.name ?? ""),
                                  ),
                                )
                                .toList());
                      },
                    ),
                    SizedBox(height: 10),
                    Text("Price Range"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              min = int.parse(value);
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Min",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _maxController,
                            onChanged: (value) {
                              max = int.parse(value);
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Max",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "New Arrivals Only",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Switch(
                          value: _isNewArrivals,
                          onChanged: (value) {
                            setState(() {
                              _isNewArrivals = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: () {
                            _maxController.clear();
                            _minController.clear();

                            Navigator.pop(context);

                            _paginatedBloc.add(GetProductPaginatedEvent(
                              product: [],
                              position: 0,
                              page: 1,
                              minPrice: min,
                              maxPrice: max,
                              catId: cat?.id,
                              isNewArrival: _isNewArrivals,
                            ));

                            setState(() {
                              min = null;
                              max = null;

                              _isNewArrivals = false;
                              _isLoading = true;
                              _products = const [];
                              cat = null;
                            });
                          },
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        MaterialButton(
                          color: Colors.red,
                          onPressed: () {
                            _maxController.clear();
                            _minController.clear();
                            setState(() {
                              min = null;
                              max = null;
                              _isNewArrivals = false;
                              _isLoading = true;
                              // _products = const [];
                              cat = null;
                            });
                          },
                          child: Text(
                            "RESET",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: BlocBuilder<ProductPaginatedBloc, ProductPaginatedState>(
            builder: (context, state) => _products.isEmpty
                ? _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : BigTip(
                        icon: Icon(Icons.sentiment_dissatisfied),
                        title: Text("Result Empty"),
                        subtitle: Text("Try search again"),
                      )
                : RefreshIndicator(
                    onRefresh: () {
                      _paginatedBloc.add(GetProductPaginatedEvent(
                          product: [], position: 0, page: 1));
                      return _refreshCompleter.future;
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          _gridView
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _products.length + 1,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150,
                                    childAspectRatio: 2 / 3,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == _products.length) {
                                      return _isBottomLoading
                                          ? BottomLoader()
                                          : state is ProductPaginatedError
                                              ? ErrorPaginated(
                                                  onRefresh: () {
                                                    _paginatedBloc.add(
                                                        GetProductPaginatedEvent(
                                                            product: _products,
                                                            position: 0,
                                                            page:
                                                                _currentPage));
                                                  },
                                                )
                                              : Opacity(opacity: 0);
                                    }
                                    String imageEnd = '';
                                    final bool isFav =
                                        _products[index].isFavourite ?? false;
                                    if (_products[index].product_images.length >
                                        0) {
                                      imageEnd = IMAGE_URL +
                                          _products[index]
                                              .product_images[0]
                                              .image!;
                                    } else {
                                      imageEnd =
                                          'https://image.freepik.com/free-vector/empty-concept-illustration_114360-1253.jpg';
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        AutoRouter.of(context)
                                            .push(ProductDetailsScreenRoute(
                                          detailsArguments:
                                              ProductDetailsArguments(
                                                  product: _products[index],
                                                  initialValue: _products[index]
                                                          .cartQty ??
                                                      0),
                                        ))
                                            .then((value) {
                                          // context
                                          //     .read<ProductPaginatedBloc>()
                                          //     .add(GetProductPaginatedUpdate(
                                          //         product: [],
                                          //         position: 0,
                                          //         page: 0));
                                          // context.read<NewArrivalsBloc>().add(
                                          //     UpdateNewArrivals(
                                          //         product: [],
                                          //         position: 0,
                                          //         page: 0));
                                          // context
                                          //     .read<GetCartQuantityBloc>()
                                          //     .add(GetCartQuantityStarted());
                                        });
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
                                              flex: 2,
                                              fit: FlexFit.tight,
                                              child: Container(
                                                margin: EdgeInsets.all(20),
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
                                                  errorWidget: (c, s, o) =>
                                                      Image.asset(
                                                    "assets/images/placeholder.png",
                                                  ),
                                                  fit: BoxFit.fill,
                                                  imageUrl: imageEnd,
                                                  placeholderFadeInDuration:
                                                      const Duration(
                                                          milliseconds: 400),
                                                  fadeInDuration:
                                                      const Duration(
                                                          milliseconds: 400),
                                                  placeholder: (c, s) =>
                                                      Image.asset(
                                                    "assets/images/placeholder.png",
                                                  ),
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
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _products[index].name ??
                                                          "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 9.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${_products[index].price_s}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 10.0,
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                            text:
                                                                "Cart Quantity: ",
                                                            style: TextStyle(
                                                                fontSize: 10.0,
                                                                color: Colors
                                                                    .black)),
                                                        TextSpan(
                                                            text:
                                                                _products[index]
                                                                    .cartQty
                                                                    .toString(),
                                                            style: TextStyle(
                                                              fontSize: 10.0,
                                                              color: Colors.red,
                                                            ))
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _products.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == _products.length) {
                                      return _isBottomLoading
                                          ? BottomLoader()
                                          : state is ProductPaginatedError
                                              ? ErrorPaginated(
                                                  onRefresh: () {
                                                    _paginatedBloc.add(
                                                        GetProductPaginatedEvent(
                                                            product: _products,
                                                            position: 0,
                                                            page:
                                                                _currentPage));
                                                  },
                                                )
                                              : Opacity(opacity: 0);
                                    }
                                    final product = _products[index];
                                    return ListTile(
                                      title: Text(
                                        product.name ?? "",
                                        style: TextStyle(
                                          //                    fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        child: product.product_images.isEmpty
                                            ? Image.asset(
                                                "assets/images/placeholder.png")
                                            : FadeInImage.assetNetwork(
                                                imageErrorBuilder: (context,
                                                        error, stackTrace) =>
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
                                            color: Constants.ratingBG,
                                            allowHalfRating: true,
                                            rating: 5.0,
                                            size: 12.0,
                                          ),
                                          SizedBox(width: 6.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: "Price: ",
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  TextSpan(
                                                      text: product.price_s,
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                      ))
                                                ]),
                                              ),
                                              RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text: "Cart Quantity: ",
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                  TextSpan(
                                                      text: product.cartQty
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ))
                                                ]),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsScreen(
                                          detailsArguments:
                                              ProductDetailsArguments(
                                            product: product,
                                            initialValue: product.cartQty ?? 0,
                                          ),
                                        ),
                                      )),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider();
                                  },
                                ),
                          SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _SpeechWidget extends StatefulWidget {
  const _SpeechWidget({
    Key? key,
  }) : super(key: key);

  @override
  __SpeechWidgetState createState() => __SpeechWidgetState();
}

const NOT_LISTENING = "notListening";

class __SpeechWidgetState extends State<_SpeechWidget> {
  // late final _speechBloc = getIt<SpeechBloc>();s
  late final _speech = getIt<stt.SpeechToText>();
  late bool _isAvail = false;
  late bool _buttonPressed = false;
  late bool _isListening = _speech.isListening;
  // ValueNotifier<bool> _isComplete = ValueNotifier(false);
  String? _result;

  @override
  void initState() {
    super.initState();
    _result = null;
    _initialize();
  }

  @override
  void dispose() {
    // _speechBloc.close();
    _speech.cancel();
    _speech.stop();
    super.dispose();
  }

  void _initialize() async {
    _isAvail = await _speech.initialize(
      finalTimeout: Duration(seconds: 5),
      onStatus: (val) {
        print('onStatus: $val');
        setState(() {
          _isListening = _speech.isListening;
        });

        if (val == NOT_LISTENING && _result != null) {
          // AutoRouter.of(context).navigatorKey.currentState?.pop(_result);
          // Navigator.of(context, rootNavigator: true).pop(_result);
        }
      },
      onError: (val) {
        print('onError: $val');
      },
      debugLogging: true,
    );
  }

  void _startListening() {
    if (_isAvail) {
      _speech
          .listen(
            onResult: (value) async {
              await Future.delayed(Duration.zero, () {
                setState(() {
                  _result = value.recognizedWords;
                });
              });
              // Future.delayed(Duration(milliseconds: 500), () {
              //   Navigator.of(context).pop(value.recognizedWords);
              // });
            },
            listenMode: stt.ListenMode.search,
            listenFor: Duration(seconds: 10),
          )
          .then((value) => {print("VALUE: $value")})
          .onError((error, stackTrace) => {print("ERROR: $error")});
      return;
    }
    print("My Love Is Unbreakabale");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Say Something"),
      actions: [
        _result != null
            ? TextButton(
                onPressed: () => Navigator.of(context).pop(_result),
                child: Text(
                  "SUBMIT",
                  style: TextStyle(color: Colors.green),
                ))
            : Opacity(opacity: 0)
      ],
      content: Container(
        height: 150,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: !_buttonPressed
                    ? Text(
                        "Press the Icon to Start Listening",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : _result == null && !_isListening
                        ? Text(
                            "I did not understand",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : _result == null
                            ? AnimatedTextKit(
                                pause: Duration(milliseconds: 500),
                                repeatForever: true,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    "Listening...",
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                _result ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IconAnimation(
                animate: _isListening,
                endRadius: 65,
                child: IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () {
                    setState(() {
                      _buttonPressed = true;
                      _result = null;
                    });
                    _startListening();
                  },
                ),
              ),
              // duration: Duration(milliseconds: 500),
            )
          ],
        ),
      ),
    );
  }
}

// Widget _redContainer(BuildContext context)=>Container();
