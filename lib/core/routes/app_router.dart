import 'package:auto_route/auto_route.dart';

import 'package:biz_mobile_app/features/presentation/screens/about_us_page.dart';
import 'package:biz_mobile_app/features/presentation/screens/all_categories.dart';
import 'package:biz_mobile_app/features/presentation/screens/all_offers.dart';
import 'package:biz_mobile_app/features/presentation/screens/categories_screen.dart';
import 'package:biz_mobile_app/features/presentation/screens/distributors.dart';
import 'package:biz_mobile_app/features/presentation/screens/home/home_page.dart';
import 'package:biz_mobile_app/features/presentation/screens/initialize/initialize_screen.dart';
import 'package:biz_mobile_app/features/presentation/screens/login.dart';
import 'package:biz_mobile_app/features/presentation/screens/more_products.dart';
import 'package:biz_mobile_app/features/presentation/screens/new_arrivals.dart';
import 'package:biz_mobile_app/features/presentation/screens/notifications.dart';
import 'package:biz_mobile_app/features/presentation/screens/offer_detail_screen.dart';
import 'package:biz_mobile_app/features/presentation/screens/order_history.dart';
import 'package:biz_mobile_app/features/presentation/screens/order_history_details.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/components/picture_screen.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/see_more_details.dart';
import 'package:biz_mobile_app/features/presentation/screens/profile.dart';
import 'package:biz_mobile_app/features/presentation/screens/search.dart';
import 'package:biz_mobile_app/features/presentation/screens/splash.dart';
import 'package:biz_mobile_app/features/presentation/screens/uknown_page.dart';
import 'package:biz_mobile_app/features/presentation/screens/walkthrough.dart';

//!page routers, 🙅‍♂️️,,For Navigation...read nire on https://autoroute.vercel.app/
@MaterialAutoRouter(
  routes: [
    MaterialRoute(page: SplashScreen, initial: true),
    MaterialRoute(page: IntroPage),
    MaterialRoute(page: LoginPage),
    MaterialRoute(page: InitializePage),
    MaterialRoute(page: HomePage),
    MaterialRoute(page: ProductDetailsScreen),
    MaterialRoute(page: SearchScreen),
    MaterialRoute(page: Notifications),
    MaterialRoute(page: AllCategories),
    MaterialRoute(page: AllOffersScreen),
    MaterialRoute(page: OfferDetailScreen),
    MaterialRoute(page: OrderHistory),
    MaterialRoute(page: OrderHistoryDetails),
    MaterialRoute(page: Profile),
    MaterialRoute(page: ViewMoreScreen),
    MaterialRoute(page: CategoriesScreen),
    MaterialRoute(page: Distributor),
    MaterialRoute(page: ABoutUsPage),
    MaterialRoute(page: NewArrivalScreen),
    MaterialRoute(
      page: PictureScreen,
      fullscreenDialog: true,
    ),
    MaterialRoute(
      page: SeeMoreDetails,
      fullscreenDialog: true,
    ),

    //*This rout should ALWAYS, ALWAYS stay at the bootom
    AutoRoute(path: '*', page: UnknownPage)
  ],
)
class $AppRouter {}
