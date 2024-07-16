// import 'package:flutter/material.dart';
// import 'package:flutter_svg/parser.dart';
// import 'package:flutter_svg/svg.dart';

// import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
// import 'package:biz_mobile_app/features/presentation/widgets/expandable_text.dart';

// import '../../../../../size_config.dart';

// class ProductDescription extends StatelessWidget {
//   const ProductDescription({
//     Key? key,
//     required this.product,
//     required this.pressOnSeeMore,
//     required this.isFavourite,
//     required this.addRemoveToFav,
//     required GlobalKey htmlKey,
//     required this.size,
//   })   : _htmlKey = htmlKey,
//         super(key: key);

//   final ProductModel product;
//   final GestureTapCallback pressOnSeeMore;
//   final bool isFavourite;
//   final VoidCallback addRemoveToFav;
//   final GlobalKey _htmlKey;
//   final double size;

//   // get kPrimaryColor => null;

//   @override
//   Widget build(BuildContext context) {
//     final svg = "assets/icons/Heart_Icon_2.svg";
//     // final SvgParser parser = SvgParser();

//     // try {
//     //   parser.parse(svg, warningsAsErrors: true);
//     //   print('SVG is supported');
//     // } catch (e) {
//     //   print('SVG contains unsupported features');
//     // }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
//           child: product.units != null
//               ? Text(
//                   product.name +
//                       " ( ${product.price_s}) Per " +
//                       product.units!.symbol,
//                   style: Theme.of(context).textTheme.headline6,
//                 )
//               : Text(
//                   product.name + " (${product.price_s}) Per Item",
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//         ),
//         SizedBox(height: 50),
//         Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
//           child: Text(
//             "Product Details",
//             style: Theme.of(context).textTheme.subtitle1,
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: Container(
//             padding: EdgeInsets.symmetric(
//                 horizontal: getProportionateScreenWidth(15)),
//             width: getProportionateScreenWidth(64),
//             decoration: BoxDecoration(
//               color:
//                   // product.isFavourite ? Color(0xFFFFE6E6) : Color(0xFFF5F6F9),
//                   Color(0xFFF5F6F9),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 bottomLeft: Radius.circular(20),
//               ),
//             ),
//             child: IconButton(
//                 icon: SvgPicture.asset(
//                   svg,
//                   color: isFavourite ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
//                   // Color(0xFFDBDEE4),
//                   height: getProportionateScreenWidth(16),
//                 ),
//                 onPressed: addRemoveToFav),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.only(
//             left: getProportionateScreenWidth(20),
//             right: getProportionateScreenWidth(64),
//           ),
//           child: ExpandableText(
//             data: product.description,
//             htmlKey: _htmlKey,
//             size: size,
//           ),
//         ),
//         // Padding(
//         //   padding: EdgeInsets.symmetric(
//         //     horizontal: getProportionateScreenWidth(20),
//         //     vertical: 10,
//         //   ),
//         //   child: GestureDetector(
//         //     onTap: () {},
//         //     child: Row(
//         //       children: [
//         //         Text(
//         //           "See More Detail",
//         //           style: TextStyle(
//         //               fontWeight: FontWeight.w600, color: kPrimaryColor),
//         //         ),
//         //         SizedBox(width: 5),
//         //         Icon(
//         //           Icons.arrow_forward_ios,
//         //           size: 12,
//         //           color: kPrimaryColor,
//         //         ),
//         //       ],
//         //     ),
//         //   ),
//         // )
//       ],
//     );
//   }
// }
