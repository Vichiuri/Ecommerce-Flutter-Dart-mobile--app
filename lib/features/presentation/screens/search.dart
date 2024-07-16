import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/core/utils/debouncer.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/presentation/bloc/search_product/search_product_bloc.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/const.dart';
import '../widgets/smooth_star_rating.dart';

///where to search products
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchControl = new TextEditingController();
  List<ProductModel> _products = [];
  final _debouncer = Debouncer(
    milliseconds: 500,
  );
  @override
  void dispose() {
    _searchControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => context.read<SearchProductBloc>()
        ..add(
          SearchProductStarted(query: ""),
        ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchProductBloc, SearchProductState>(
      listener: (context, state) {
        if (state is SearchProductSuccess) {
          _products = state.products;
        }
        if (state is SearchProductError) {
          _products = [];
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
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text("Search"),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Column(
            children: [
              Card(
                elevation: 6.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    onSubmitted: (value) {
                      context
                          .read<SearchProductBloc>()
                          .add(SearchProductStarted(query: value));
                    },
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      _debouncer.run(
                        () => context
                            .read<SearchProductBloc>()
                            .add(SearchProductStarted(query: value)),
                      );
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "Search by Name, Brands or Categories..",
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 1,
                    controller: _searchControl,
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<SearchProductBloc, SearchProductState>(
                  builder: (context, state) {
                    if (state is SearchProductLoading) {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    //!YEss
                    return ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _products.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                ? Image.asset("assets/images/placeholder.png")
                                : FadeInImage.assetNetwork(
                                    imageErrorBuilder: (context, error,
                                            stackTrace) =>
                                        Image.asset(
                                            "assets/images/placeholder.png"),
                                    placeholder:
                                        "assets/images/placeholder.png",
                                    image: IMAGE_URL +
                                        "${product.product_images.first.image}",
                                  ),
                          ),
                          // leading: CircleAvatar(
                          //   radius: 25.0,
                          //   backgroundImage: product.product_images.isEmpty
                          //       ? NetworkImage(
                          //           'https://image.freepik.com/free-vector/empty-concept-illustration_114360-1253.jpg')
                          //       : NetworkImage(
                          //           IMAGE_URL +
                          //               "${product.product_images.first.image}",
                          //         ),
                          // ),
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
                                          style:
                                              TextStyle(color: Colors.black)),
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
                                          style:
                                              TextStyle(color: Colors.black)),
                                      TextSpan(
                                          text: product.cartQty.toString(),
                                          style: TextStyle(
                                            color: Colors.red,
                                          ))
                                    ]),
                                  ),
                                ],
                              )
                            ],
                          ),
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              detailsArguments: ProductDetailsArguments(
                                product: product,
                                initialValue: product.cartQty ?? 0,
                              ),
                            ),
                          )),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
