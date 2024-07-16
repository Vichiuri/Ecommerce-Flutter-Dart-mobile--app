import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/presentation/bloc/distributor/distributor_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_banners/get_banners_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_category/get_category_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_offer/get_offer_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/initialize_prod/initialize_product_bloc.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//initializing all producs for offline saving, this feature is only available on salesman
class InitializePage extends StatefulWidget {
  const InitializePage({Key? key}) : super(key: key);

  @override
  _InitializePageState createState() => _InitializePageState();
}

class _InitializePageState extends State<InitializePage> {
  late final _initProdBloc = getIt<InitializeProductBloc>();
  late final _bannerBloc = getIt<GetBannersBloc>();
  late final _offerBloc = getIt<GetOfferBloc>();
  late final _getCategoryBloc = getIt<GetCategoryBloc>();
  late final _distBloc = getIt<DistributorBloc>()..add(FetchDistributorEvent());

  int currentPage = 1;
  int? lastPage;
  double progress = 0.0;
  int catPage = 1;
  int catLastPage = 1;
  double cartProgress = 0.0;

  @override
  void initState() {
    super.initState();
    // _initProdBloc.add(InitializeProductStarted(1));
    _bannerBloc.add(GetBannerStated());
    _distBloc.add(FetchDistributorEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _initProdBloc.close();
    _bannerBloc.close();
    _offerBloc.close();
    _getCategoryBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => _initProdBloc),
        BlocProvider(create: (create) => _bannerBloc),
        BlocProvider(create: (create) => _getCategoryBloc),
        BlocProvider(create: (create) => _distBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener(
            bloc: _bannerBloc,
            listener: (context, GetBannersState state) {
              if (state is GetBannersSuccess) {
                _offerBloc.add(GetOfferStarted());
              }
              if (state is GetBannersError) {
                _offerBloc.add(GetOfferStarted());
              }
            },
          ),
          BlocListener(
            bloc: _offerBloc,
            listener: (context, GetOfferState state) {
              if (state is GetOfferSuccess) {
                _getCategoryBloc.add(GetCategoryStarted(page: 1));
                // _initProdBloc.add(InitializeProductStarted(1));
              }
              if (state is GetOfferError) {
                _getCategoryBloc.add(GetCategoryStarted(page: 1));
                // _initProdBloc.add(InitializeProductStarted(1));
              }
            },
          ),
          BlocListener<GetCategoryBloc, GetCategoryState>(
            listener: (context, state) {
              if (state is GetCategorySuccess) {
                catPage = state.response.currentPage ?? 1;
                catLastPage = state.response.lastPage ?? 1;

                cartProgress = catPage / catLastPage;

                if (catPage < catLastPage) {
                  _getCategoryBloc.add(GetCategoryStarted(page: catPage + 1));
                } else {
                  _initProdBloc.add(InitializeProductStarted(1));
                }
              }
            },
          ),
          BlocListener(
            bloc: _initProdBloc,
            listener: (
              context,
              InitializeProductState state,
            ) {
              if (state is InitializeProductSuccess) {
                currentPage = state.currentPage ?? 1;
                lastPage = state.lastPage;

                progress = (state.currentPage! / state.lastPage!);
                if (state.currentPage! < state.lastPage!) {
                  _initProdBloc.add(InitializeProductStarted(currentPage + 1));
                } else {
                  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                    AutoRouter.of(context).replaceAll([HomePageRoute()]);
                  });
                }
              }
            },
          )
        ],
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<GetCategoryBloc, GetCategoryState>(
                  builder: (context, state) {
                    if (state is GetCategoryError) {
                      return MaterialButton(
                        color: Colors.blue,
                        onPressed: () => _getCategoryBloc
                            .add(GetCategoryStarted(page: catPage)),
                        child: Text(
                          "RETRY",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        cartProgress == 1
                            ? Text("CATEGORIES INITIALIZED")
                            : Text("INITIALIZING CATEGORIES"),
                        SizedBox(
                          height: 10,
                        ),
                        cartProgress == 1
                            ? Text("😁️")
                            : CircularProgressIndicator(
                                value: cartProgress,
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("${(cartProgress * 100).toStringAsFixed(2)}%")
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<InitializeProductBloc, InitializeProductState>(
                  builder: (context, state) {
                    if (state is InitializeProductError) {
                      return MaterialButton(
                        color: Colors.blue,
                        onPressed: () => _initProdBloc
                            .add(InitializeProductStarted(currentPage)),
                        child: Text(
                          "RETRY",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Text("INITIALIZING PRODUCTS"),
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator(
                          value: progress,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("${(progress * 100).toStringAsFixed(2)}%")
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
