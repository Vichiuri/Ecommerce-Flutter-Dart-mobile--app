import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'banner_slider.dart';
import 'offer_widget.dart';
import 'view_categories.dart';
import 'view_product.dart';
import 'package:flutter/material.dart';

import '../../../data/responses/DashBoardResponse.dart';
import '../../../domain/models/Category/CategoryModel.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';

//body of home
class HomeBody extends StatefulWidget {
  const HomeBody({
    required this.onRefresh,
    Key? key,
    this.response,
    required this.categoryModel,
    required this.cartLoading,
    // required this.dashboardBloc,
    this.title,
    this.message,
    // required this.mainBloc,
    required this.addToFavBloc,
  }) : super(key: key);
  final DashBoardResponse? response;
  final bool cartLoading;
  // final DashboardBloc dashboardBloc;
  final String? message, title;
  // final MainBloc mainBloc;
  final AddRemoveToFavBloc addToFavBloc;
  final List<CategoryModel> categoryModel;
  final Future<void> Function() onRefresh;

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String? errorMessage, errorTitle;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              BannerSlider(
                banners: widget.response!.banners,
                offers: widget.response!.offers,
              ),
              OfferWidget(offers: widget.response!.offers),
              ViewCategories(categories: widget.categoryModel),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Products",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      "View All",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    onPressed: () =>
                        AutoRouter.of(context).push(ViewMoreScreenRoute()),
                  ),
                ],
              ),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  return ViewProductWidget(
                    products: widget.response!.products,
                    // mainBloc: widget.mainBloc,
                    addToFav: widget.addToFavBloc,
                    cartLoading: widget.cartLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
