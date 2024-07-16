import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:flutter/material.dart';

//offers
class OfferWidget extends StatelessWidget {
  const OfferWidget({
    Key? key,
    required this.offers,
  }) : super(key: key);

  final List<OfferModel> offers;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Offers",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              offers.isEmpty
                  ? Container()
                  : MaterialButton(
                      onPressed: () => AutoRouter.of(context)
                          .push(AllOffersScreenRoute(offers: offers)),
                      child: Text(
                        "View All",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
            ],
          ),
          //!hapa
          Container(
            height: 120,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  offers.isEmpty
                      ? Card(
                          margin: EdgeInsets.all(1),
                          child: Container(
                            width: 120,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    // height: double.maxFinite,
                                    margin: EdgeInsets.all(20),
                                    width: 120,
                                    child: Image.asset(
                                      "assets/images/placeholder.png",
                                    ),
                                  ),
                                ),
                                Text(
                                  "No Offers",
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
                        )
                      : Container(),
                  ListView.builder(
                    itemCount: offers.length,
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => AutoRouter.of(context).push(
                          OfferDetailScreenRoute(offerId: offers[index].id)),
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          width: 120,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  // height: double.maxFinite,
                                  margin: EdgeInsets.all(20),
                                  width: 120,
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        "assets/images/placeholder.png",
                                    image: IMAGE_URL + offers[index].pic,
                                    imageErrorBuilder: (context, o, s) =>
                                        Image.asset(
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
