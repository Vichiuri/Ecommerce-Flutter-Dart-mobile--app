// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:overlay_support/overlay_support.dart';

// import 'package:biz_mobile_app/core/utils/constants.dart';
// import 'package:biz_mobile_app/di/injection.dart';
// import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
// import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
// import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
// import 'package:biz_mobile_app/features/presentation/bloc/dashboard/dashboard_bloc.dart';
// import 'package:biz_mobile_app/features/presentation/bloc/get_cart_quantity/get_cart_quantity_bloc.dart';
// import 'package:biz_mobile_app/features/presentation/bloc/single_product/single_product_bloc.dart';
// import 'package:biz_mobile_app/features/presentation/components/default_button.dart';
// import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
// import 'package:biz_mobile_app/features/presentation/widgets/badge.dart';

// import '../../../../../size_config.dart';
// import 'color_dots.dart';
// import 'product_description.dart';
// import 'product_images.dart';
// import 'top_rounded_container.dart';

// class Body extends StatefulWidget {
//   final ProductModel? _product;
//   final int? initialQuanty;
//   final int? id;

//   const Body(
//       {Key? key, required ProductModel? product, this.initialQuanty, this.id})
//       : _product = product,
//         super(key: key);

//   @override
//   _BodyState createState() => _BodyState();
// }

// // String _typedValue = '';
// final _htmlKey = GlobalKey();

// class _BodyState extends State<Body> {
//   int quantity = 0;
//   late AddToCartBloc bloc;
//   SingleProductBloc singleProductBloc = getIt<SingleProductBloc>();
//   AddRemoveToFavBloc addToFav = getIt<AddRemoveToFavBloc>();
//   ProductModel? product;
//   List<ProductModel> _related = [];
//   late TextEditingController _controller;
//   Size? _sizeRed;
//   double? size;
//   @override
//   void initState() {
//     product = widget._product;
//     singleProductBloc.add(
//       GetSingleProductStarted(productId: product?.id ?? widget.id!),
//     );
//     bloc = getIt<AddToCartBloc>();
//     quantity = widget.initialQuanty ?? 0;
//     _controller = TextEditingController(text: quantity.toString());
//     super.initState();
//     // _htmlKey = GlobalKey();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     bloc.close();
//     addToFav.close();
//     singleProductBloc.close();
//     _controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => singleProductBloc),
//         BlocProvider(create: (context) => bloc),
//         BlocProvider(create: (context) => addToFav),
//       ],
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener<AddRemoveToFavBloc, AddRemoveToFavState>(
//             listener: (context, state) {
//               if (state is AddRemoveToFavSuccess) {
//                 singleProductBloc.add(
//                   UpdateSingleProductStarted(productId: product!.id),
//                 );
//               }
//             },
//           ),
//           BlocListener<SingleProductBloc, SingleProductState>(
//             listener: (context, state) {
//               if (state is SingleProductSuccess) {
//                 product = state.response.product ?? widget._product;
//                 quantity = product!.cartQty ?? widget.initialQuanty ?? 0;
//                 _related = state.response.related;

//                 WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
//                   _sizeRed = _htmlKey.currentContext?.size;
//                   print("SIZE of Red: $_sizeRed");
//                   print("Height of Red: ${_sizeRed?.height}");
//                   setState(() {
//                     size = _sizeRed?.height;
//                   });
//                 });
//                 print("Height Size: $size");
//               }
//               if (state is SingleProductError) {
//                 print("ERROR: ${state.message}");
//                 //TODO implement SingleProductError
//               }
//             },
//           ),
//           BlocListener<AddToCartBloc, AddToCartState>(
//             listener: (context, state) {
//               if (state is AddToCartLoading) {
//                 ScaffoldMessenger.maybeOf(context)!
//                   ..hideCurrentSnackBar()
//                   ..showSnackBar(
//                     SnackBar(
//                       duration: Duration(minutes: 10),
//                       backgroundColor: Colors.blue,
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       content: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CupertinoActivityIndicator(),
//                           Text(
//                             "Adding to cart...",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//               }
//               if (state is AddToCartSuccess) {
//                 context
//                     .read<GetCartQuantityBloc>()
//                     .add(GetCartQuantityStarted());
//                 ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
//                 showSimpleNotification(
//                   Text(state.message),
//                   background: Colors.greenAccent,
//                   position: NotificationPosition.bottom,
//                   duration: Duration(seconds: 1),
//                 );
//                 // Navigator.of(context).pop();
//                 singleProductBloc.add(
//                   UpdateSingleProductStarted(productId: product!.id),
//                 );
//                 print("Succeeess yeeeii");
//               }
//               if (state is AddToCartError) {
//                 ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
//                 showSimpleNotification(
//                   Text(state.message),
//                   background: Colors.red,
//                   position: NotificationPosition.bottom,
//                 );
//               }
//             },
//           ),
//         ],
//         child: BlocBuilder<SingleProductBloc, SingleProductState>(
//           builder: (context, state) {
//             if (state is SingleProductLoading) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (state is SingleProductSuccess) {
//               return ListView(
//                 children: [
//                   ProductImages(product: product!),
//                   TopRoundedContainer(
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         ProductDescription(
//                           size: size ?? 0.0,
//                           // state: false,
//                           isFavourite: product!.isFavourite ?? false,
//                           product: product!,
//                           pressOnSeeMore: () {},
//                           addRemoveToFav: () => addToFav
//                               .add(AddRemoveToFavPressed(prodId: product!.id)),
//                           htmlKey: _htmlKey,
//                         ),
//                         TopRoundedContainer(
//                           color: Color(0xFFF6F7F9),
//                           child: Column(
//                             children: [
//                               ColorDots(
//                                 onChanged: (String? value) {
//                                   quantity = int.parse(value ?? "0");
//                                 },
//                                 controller: _controller,
//                                 product: product!,
//                                 add: () {
//                                   setState(() {
//                                     quantity = quantity + 1;
//                                   });
//                                   _controller = TextEditingController(
//                                       text: quantity.toString());
//                                 },
//                                 substract: () {
//                                   if (quantity != 0) {
//                                     setState(() {
//                                       quantity = quantity - 1;
//                                     });
//                                   } else {
//                                     setState(() {
//                                       quantity = quantity;
//                                     });
//                                   }
//                                   _controller = TextEditingController(
//                                       text: quantity.toString());
//                                 },
//                                 number: quantity,
//                               ),
//                               TopRoundedContainer(
//                                 color: Colors.white,
//                                 child: Padding(
//                                   padding: EdgeInsets.only(
//                                     left: SizeConfig.screenWidth! * 0.15,
//                                     right: SizeConfig.screenWidth! * 0.15,
//                                     bottom: getProportionateScreenWidth(40),
//                                     top: getProportionateScreenWidth(15),
//                                   ),
//                                   child: DefaultButton(
//                                     text: widget.initialQuanty != 0
//                                         ? "Update Cart"
//                                         : "Add To Cart",
//                                     press: () {
//                                       if (quantity != 0) {
//                                         bloc.add(
//                                           AddToCartStarted(
//                                             qty: quantity.toString(),
//                                             action: widget.initialQuanty != 0
//                                                 ? "update"
//                                                 : "add",
//                                             prodId: product!.id,
//                                           ),
//                                         );
//                                       } else {
//                                         ScaffoldMessenger.maybeOf(context)!
//                                           ..hideCurrentSnackBar();
//                                         showSimpleNotification(
//                                           Text("Invalid quantity"),
//                                           background: Colors.red,
//                                           position: NotificationPosition.bottom,
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Text(
//                           "Related products",
//                           style: TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                         BlocBuilder<AddToCartBloc, AddToCartState>(
//                           builder: (context, state) => _related.isEmpty
//                               ? Container()
//                               : GridView.builder(
//                                   // margin: EdgeInsets.all(5),
//                                   shrinkWrap: true,
//                                   primary: false,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                           crossAxisCount: 2,
//                                           childAspectRatio: 2 / 3),
//                                   itemCount: _related.length,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     String imageEnd = '';
//                                     final bool isFav =
//                                         _related[index].isFavourite ?? false;
//                                     if (_related[index].product_images !=
//                                             null &&
//                                         _related[index]
//                                             .product_images
//                                             .isNotEmpty) {
//                                       imageEnd = IMAGE_URL +
//                                           _related[index]
//                                               .product_images[0]
//                                               .image;
//                                     } else {
//                                       imageEnd =
//                                           'https://image.freepik.com/free-vector/empty-concept-illustration_114360-1253.jpg';
//                                     }
//                                     return GestureDetector(
//                                       onTap: () {
//                                         Navigator.of(context)
//                                             .popAndPushNamed(
//                                               '/details',
//                                               arguments:
//                                                   ProductDetailsArguments(
//                                                       product: _related[index],
//                                                       initialValue:
//                                                           _related[index]
//                                                                   .cartQty ??
//                                                               0),
//                                             )
//                                             .then(
//                                               (value) => context.read<
//                                                   DashboardBloc>()
//                                                 ..add(UpdateDashBoardEvent()),
//                                             );
//                                       },
//                                       child: Card(
//                                         child: GridTile(
//                                           header: Padding(
//                                             padding: const EdgeInsets.all(2.0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Opacity(opacity: 0),
//                                                 Container(
//                                                   padding:
//                                                       const EdgeInsets.all(0.0),
//                                                   width: 30.0,
//                                                   child: IconButton(
//                                                     padding: EdgeInsets.zero,
//                                                     icon: Icon(
//                                                       Icons.favorite,
//                                                       color: isFav
//                                                           ? Colors.red
//                                                           : Colors.black45,
//                                                     ),
//                                                     onPressed: () => addToFav.add(
//                                                         AddRemoveToFavPressed(
//                                                             prodId:
//                                                                 _related[index]
//                                                                     .id)),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                           footer: Padding(
//                                             padding: const EdgeInsets.all(2.0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.end,
//                                               children: [
//                                                 Expanded(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         _related[index].name,
//                                                         style: TextStyle(
//                                                           fontSize: 16.0,
//                                                           fontWeight:
//                                                               FontWeight.w800,
//                                                         ),
//                                                         maxLines: 2,
//                                                       ),
//                                                       Text(
//                                                         "${_related[index].price_s}",
//                                                         style: TextStyle(
//                                                           fontSize: 13.0,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   padding: EdgeInsets.zero,
//                                                   width: 30.0,
//                                                   child: RawMaterialButton(
//                                                     padding: EdgeInsets.zero,
//                                                     // onPressed: () {},
//                                                     onPressed: () => context
//                                                         .read<AddToCartBloc>()
//                                                         .add(AddToCartSingle(
//                                                             prodId:
//                                                                 _related[index]
//                                                                     .id)),
//                                                     fillColor:
//                                                         Colors.orangeAccent,
//                                                     shape: CircleBorder(),
//                                                     elevation: 4.0,
//                                                     child: CartIconBadge(
//                                                       icon: Icons.shopping_cart,
//                                                       qty: _related[index]
//                                                               .cartQty ??
//                                                           0,
//                                                       size: 20,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           child: Stack(
//                                             children: [
//                                               Container(
//                                                 margin: EdgeInsets.all(10),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           8.0),
//                                                   image: DecorationImage(
//                                                     image:
//                                                         NetworkImage(imageEnd),
//                                                     fit: BoxFit.contain,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Container(
//                                                 height: double.infinity,
//                                                 width: double.infinity,
//                                                 decoration: BoxDecoration(
//                                                   gradient: LinearGradient(
//                                                     begin: Alignment.topCenter,
//                                                     end: Alignment.bottomCenter,
//                                                     colors: [
//                                                       Colors.transparent,
//                                                       Colors.white
//                                                           .withOpacity(0.5)
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }
//             return Container();
//           },
//         ),
//       ),
//     );
//   }
// }
