// import 'package:biz_mobile_app/features/presentation/screens/details.dart';
import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/features/domain/models/banners/BannerModel.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:flutter/material.dart';

//carosel slider items
class SliderItem extends StatelessWidget {
  final BannerModel banner;
  final List<BannerModel> listBanners;
  final String img;
  final bool isFav;
  final double rating;
  final int raters;
  final List<OfferModel>? offers;

  SliderItem(
      {Key? key,
      required this.banner,
      required this.listBanners,
      required this.img,
      required this.isFav,
      required this.rating,
      this.offers,
      required this.raters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 150,
            // margin: pa,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage.assetNetwork(
                fit: BoxFit.fill,
                image: IMAGE_URL + "${banner.pic}",
                placeholder: 'assets/images/placeholder_rectangle.png',
                placeholderScale: 1,
                imageErrorBuilder: (c, s, k) =>
                    Image.asset('assets/images/placeholder_rectangle.png'),
              ),
            ),
          ),
          Text(
            "${banner.name}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "${banner.text}",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      onTap: () {
        if (banner.status == "Product") {
          AutoRouter.of(context).push(ProductDetailsScreenRoute(
              detailsArguments: ProductDetailsArguments(
            product: banner.product!,
            initialValue: banner.product!.cartQty ?? 0,
          )));
        } else if (banner.status == "Offer") {
          AutoRouter.of(context).push(OfferDetailScreenRoute(
            offerId: banner.offer!.id,
          ));
        } else {
          print("I've got Goodness, and I've got Mercy");
        }
      },
    );
  }
}
