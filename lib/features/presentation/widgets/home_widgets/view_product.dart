import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:biz_mobile_app/features/presentation/widgets/cart_icon_badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants.dart';
import '../../../domain/models/Products/ProductsModel.dart';

//product details
class ViewProductWidget extends StatelessWidget {
  const ViewProductWidget({
    Key? key,
    required this.products,
    // required this.mainBloc,
    required this.addToFav,
    required this.cartLoading,
    // required this.addToCartBloc,
  }) : super(key: key);

  final List<ProductModel> products;
  // final AddToCartBloc addToCartBloc;
  // final MainBloc mainBloc;

  final bool cartLoading;
  final AddRemoveToFavBloc addToFav;
  // BlocProvider

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddToCartBloc, AddToCartState>(
      builder: (context, state) => GridView.builder(
        // margin: EdgeInsets.all(5),
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          String imageEnd = '';
          final bool isFav = products[index].isFavourite ?? false;
          if (products[index].product_images.length > 0) {
            imageEnd = IMAGE_URL + products[index].product_images[0].image!;
          } else {
            imageEnd =
                'https://image.freepik.com/free-vector/empty-concept-illustration_114360-1253.jpg';
          }
          return GestureDetector(
            onTap: () {
              AutoRouter.of(context)
                  .push(ProductDetailsScreenRoute(
                    detailsArguments: ProductDetailsArguments(
                        product: products[index],
                        initialValue: products[index].cartQty ?? 0),
                  ))
                  .then(
                    (value) => context.read<DashboardBloc>()
                      ..add(UpdateDashBoardEvent()),
                  );
            },
            child: Card(
              margin: EdgeInsets.all(1),
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[100]!, width: 1.0),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: GridTile(
                header: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Opacity(opacity: 0),
                      Container(
                        padding: const EdgeInsets.all(0.0),
                        width: 20.0,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.favorite,
                            color: isFav ? Colors.red : Colors.black45,
                            size: 15,
                          ),
                          onPressed: () => addToFav.add(AddRemoveToFavPressed(
                              prodId: products[index].id)),
                        ),
                      )
                    ],
                  ),
                ),
                footer: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Opacity(
                          opacity: 0,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.zero,
                        width: 20.0,
                        child: RawMaterialButton(
                            padding: EdgeInsets.zero,
                            // onPressed: () {},
                            onPressed: () => {
                                  if (cartLoading == false)
                                    {
                                      context.read<AddToCartBloc>().add(
                                          AddToCartSingle(
                                              product: products[index],
                                              prodId: products[index].id))
                                    }
                                  else
                                    {print("Tulia msee inaload")}
                                },
                            fillColor: Colors.blue[300],
                            shape: CircleBorder(),
                            elevation: 4.0,
                            child: CartIconBadge(
                              icon: Icons.shopping_cart,
                              qty: products[index].cartQty ?? 0,
                              size: 13,
                            )),
                      ),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.all(15),
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.fill,
                          imageErrorBuilder: (c, s, o) => Image.asset(
                            "assets/images/placeholder.png",
                            fit: BoxFit.fill,
                          ),
                          placeholder: "assets/images/placeholder.png",
                          image: imageEnd,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index].name ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                "${products[index].price_s}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.0,
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
          );
        },
      ),
    );
  }
}
