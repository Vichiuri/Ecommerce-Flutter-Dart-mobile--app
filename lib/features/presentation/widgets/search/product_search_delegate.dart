import 'package:biz_mobile_app/core/utils/const.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/core/utils/debouncer.dart';
import 'package:biz_mobile_app/features/presentation/bloc/search_product/search_product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../smooth_star_rating.dart';

//Seaef Delegate for seacrh products
class ProductSearchDelegate extends SearchDelegate<ProductModel?> {
  final SearchProductBloc bloc;
  final bool isNewArrival;
  final int? catId;
  ProductSearchDelegate({
    String? searchFieldLabel,
    required this.bloc,
    this.isNewArrival = false,
    this.catId,
  }) : super(searchFieldLabel: searchFieldLabel);

  List<String> _suggestion = const [];
  List<ProductModel> product = const [];
  late final _debouncer = Debouncer(milliseconds: 500);
  int? min;
  int? max;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    bloc.add(SearchProductStarted(
        query: query, isNewArrival: isNewArrival, catId: catId));
    return BlocConsumer(
      bloc: bloc,
      listener: (context, SearchProductState state) {
        if (state is SearchProductSuccess) {
          _suggestion = state.products.map((e) => e.name ?? "").toList();
          product = state.products;
        }
      },
      builder: (context, SearchProductState state) {
        if (state is SearchProductLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: product.length,
          itemBuilder: (c, i) => ListTile(
            title: Text(
              product[i].name ?? "",
              style: TextStyle(
                //                    fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            leading: Container(
              height: 50,
              width: 50,
              child: product[i].product_images.isEmpty
                  ? Image.asset("assets/images/placeholder.png")
                  : FadeInImage.assetNetwork(
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset("assets/images/placeholder.png"),
                      placeholder: "assets/images/placeholder.png",
                      image: IMAGE_URL +
                          "${product[i].product_images.first.image}",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Price: ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: product[i].price_s,
                            style: TextStyle(
                              color: Colors.green,
                            ))
                      ]),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Cart Quantity: ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            text: product[i].cartQty.toString(),
                            style: TextStyle(
                              color: Colors.red,
                            ))
                      ]),
                    ),
                  ],
                )
              ],
            ),
            onTap: () => close(context, product[i]),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    bloc.add(SearchProductStarted(
      query: query,
      isNewArrival: isNewArrival,
      catId: catId,
    ));
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          // Container(
          //   height: 80,
          //   width: double.infinity,
          //   child: Column(
          //     children: [
          //       Text("Price Range"),
          //       SizedBox(
          //         height: 10,
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Expanded(
          //             child: TextField(
          //               inputFormatters: [
          //                 FilteringTextInputFormatter.digitsOnly
          //               ],
          //               onChanged: (value) {
          //                 min = int.parse(value);
          //                 _debouncer.run(() {
          //                   bloc.add(SearchProductStarted(
          //                     minPrice: min,
          //                     maxPrice: max,
          //                     query: query,
          //                     isNewArrival: isNewArrival,
          //                     catId: catId,
          //                   ));
          //                 });
          //               },
          //               keyboardType: TextInputType.number,
          //               decoration: InputDecoration(
          //                 hintText: "Min",
          //                 contentPadding:
          //                     EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          //                 border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(10),
          //                 ),
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Expanded(
          //             child: TextField(
          //               onChanged: (value) {
          //                 max = int.parse(value);
          //                 _debouncer.run(() {
          //                   bloc.add(SearchProductStarted(
          //                     minPrice: min,
          //                     maxPrice: max,
          //                     query: query,
          //                     isNewArrival: isNewArrival,
          //                     catId: catId,
          //                   ));
          //                 });
          //               },
          //               inputFormatters: [
          //                 FilteringTextInputFormatter.digitsOnly
          //               ],
          //               keyboardType: TextInputType.number,
          //               decoration: InputDecoration(
          //                 hintText: "Max",
          //                 border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(10),
          //                 ),
          //                 contentPadding:
          //                     EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          //               ),
          //             ),
          //           ),
          //           SizedBox(
          //             width: 10,
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: BlocConsumer(
              bloc: bloc,
              listener: (context, SearchProductState state) {
                if (state is SearchProductSuccess) {
                  _suggestion =
                      state.products.map((e) => e.name ?? "").toList();
                  product = state.products;
                }
                if (state is SearchProductError) {
                  product = const [];
                }
              },
              builder: (context, SearchProductState state) {
                if (state is SearchProductLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: product.length,
                  itemBuilder: (c, i) => ListTile(
                    title: Text(
                      product[i].name ?? "",
                      style: TextStyle(
                        //                    fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    leading: Container(
                      height: 50,
                      width: 50,
                      child: product[i].product_images.isEmpty
                          ? Image.asset("assets/images/placeholder.png")
                          : FadeInImage.assetNetwork(
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset("assets/images/placeholder.png"),
                              placeholder: "assets/images/placeholder.png",
                              image: IMAGE_URL +
                                  "${product[i].product_images.first.image}",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Price: ",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: product[i].price_s,
                                    style: TextStyle(
                                      color: Colors.green,
                                    ))
                              ]),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Cart Quantity: ",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: product[i].cartQty.toString(),
                                    style: TextStyle(
                                      color: Colors.red,
                                    ))
                              ]),
                            ),
                          ],
                        )
                      ],
                    ),
                    onTap: () => close(context, product[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
