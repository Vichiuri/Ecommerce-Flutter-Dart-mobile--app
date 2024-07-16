import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:flutter/material.dart';

///all offersscreen
class AllOffersScreen extends StatelessWidget {
  final List<OfferModel> offers;
  const AllOffersScreen({Key? key, required this.offers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("All Offers"),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 3 / 2,
        ),
        itemCount: offers.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            AutoRouter.of(context).popAndPush(OfferDetailScreenRoute(
              offerId: offers[index].id,
              initialQuantity: offers[index].xAmt,
            ));
          },
          //!hapa msee
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              width: 120,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      // height: double.maxFinite,
                      margin: EdgeInsets.all(20),
                      width: 120,
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/images/placeholder.png",
                        image: IMAGE_URL + offers[index].pic,
                        imageErrorBuilder: (context, o, s) => Image.asset(
                          "assets/images/placeholder.png",
                        ),
                      ),
                    ),
                  ),
                  Text(
                    offers[index].name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
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
    );
  }
}
