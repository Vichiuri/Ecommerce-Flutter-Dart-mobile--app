import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/utils/constants.dart';
import '../../../domain/models/banners/BannerModel.dart';
import '../slider_item.dart';

//banners pic
class BannerSlider extends StatefulWidget {
  const BannerSlider({Key? key, required this.banners, this.offers})
      : super(key: key);

  final List<BannerModel> banners;
  final List<OfferModel>? offers;

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _current = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        viewportFraction: 1.0,
        aspectRatio: 2.67,
        enableInfiniteScroll: true,
        autoPlayInterval: Duration(seconds: 5),
        // autoPlayCurve: Curves.easeInCubic,
        // enlargeCenterPage: true,
        // reverse: true,
        onPageChanged: (index, reason) {
          // setState(() {
          //   _current = index;
          // });
        },
      ),
      items: widget.banners.map((banner) {
        String imageEnd;
        String? bannerPic = banner.pic;
        if (bannerPic != null) {
          imageEnd = IMAGE_URL + bannerPic;
        } else {
          imageEnd =
              'https://image.freepik.com/free-vector/empty-concept-illustration_114360-1253.jpg';
        }

        return SliderItem(
          listBanners: widget.banners,
          offers: widget.offers,
          img: imageEnd,
          isFav: false,
          banner: banner,
          rating: 5.0,
          raters: 23,
        );
      }).toList(),
    );
  }
}
