import 'package:biz_mobile_app/core/utils/debouncer.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';
import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';
import 'package:biz_mobile_app/features/presentation/bloc/distributor/distributor_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/fetch_current_distributor/fetch_current_distributor_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_banners/get_banners_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_category/get_category_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/get_offer/get_offer_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/new_arrivals/new_arrivals_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/product_paginated/product_paginated_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/recent_buy/recent_bought_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/top_product/top_product_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/error_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/distributor_list.dart';

class Distributor extends StatefulWidget {
  @override
  _DistributorScreenState createState() => _DistributorScreenState();
}

class _DistributorScreenState extends State<Distributor> {
  DistributorBloc bloc = getIt<DistributorBloc>();
  List<DistributorsModel>? distributors;
  List<RetailerModel>? retailers;
  int distId = 0;
  bool loadingDist = false;
  int currentSelected = 0;
  final _debouncer = Debouncer(
    milliseconds: 1000,
  );
  @override
  void initState() {
    bloc.add(FetchDistributorEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    context.read<FetchCurrentDistributorBloc>()..add(FetchCurrentStarted());
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => bloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FetchCurrentDistributorBloc,
              FetchCurrentDistributorState>(
            listener: (context, state) {
              if (state is FetchCurrentDistributorSuccess) {
                // currentDist = state.distributor.name;
                distId = state.distributor?.id ?? state.retailerModel?.id ?? 0;
                if (state.distributor != null) {
                  currentSelected = state.distributor!.id;
                } else if (state.retailerModel != null) {
                  currentSelected = state.retailerModel!.id;
                }
              }
              if (state is FetchCurrentDistributorError) {
                // currentDist = "Netbot";
              }
            },
          ),
          BlocListener<DistributorBloc, DistributorState>(
            listener: (context, state) {
              if (state is ChangeDistributorSuccess) {
                context.read<TopProductBloc>().add(TopProductUpdate());
                context
                    .read<RecentBoughtBloc>()
                    .add(RecentBoughtEventUpdated());
                context.read<GetBannersBloc>().add(GetBannerUpdate());
                context.read<GetOfferBloc>().add(GetOfferUpdate());
                context.read<GetCategoryBloc>().add(GetCategoryUpdate(page: 1));
                context.read<ProductPaginatedBloc>().add(
                    GetProductPaginatedUpdate(
                        product: [], position: 0, page: 1));
                context
                    .read<NewArrivalsBloc>()
                    .add(UpdateNewArrivals(product: [], position: 0, page: 1));
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                loadingDist = false;
                // bloc.add(UpdateDistributorEvent());
                WidgetsBinding.instance!.addPostFrameCallback((_) => {
                      // AutoRouter.of(context).pop(),
                      // AutoRouter.of(context).replace(MainScreenRoute()),
                    });
                print("CHANGE SUCCESS");

                context
                    .read<FetchCurrentDistributorBloc>()
                    .add(FetchCurrentStarted());
              }
              if (state is DistributorError) {
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                loadingDist = false;
              }
              if (state is DistributorInitial) {
                loadingDist = true;
              }
              if (state is ChangeDistributorLoading) {
                loadingDist = true;
                ScaffoldMessenger.maybeOf(context)!
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      duration: Duration(minutes: 10),
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularProgressIndicator.adaptive(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          Text(
                            "Changing Please Wait...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
              }
            },
          )
        ],
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
          ),
          body: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  onChanged: (value) {
                    _debouncer.run(() {
                      bloc.add(FetchDistributorEvent(query: value));
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "Search",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<DistributorBloc, DistributorState>(
                  builder: (context, state) {
                    if (state is DistributorLoading) {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    if (state is DistributorSuccess) {
                      distributors = state.response.distributors;
                      retailers = state.response.retailers;
                    }
                    if (state is DistributorError) {
                      return DashboardErrorWidget(
                          refresh: () => bloc.add(FetchDistributorEvent()));
                    }

                    return BlocBuilder<FetchCurrentDistributorBloc,
                        FetchCurrentDistributorState>(
                      builder: (context, state) {
                        return ListView.separated(
                          separatorBuilder: (c, i) => Divider(),
                          itemCount:
                              distributors?.length ?? retailers?.length ?? 0,
                          padding: EdgeInsets.fromLTRB(10.0, 0, 50.0, 0),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: loadingDist
                                  ? () {
                                      print("Forever I Will Sing");
                                    }
                                  : () => bloc.add(
                                        ChangeDistributorEvent(
                                            distributorId:
                                                (distributors?[index].id ??
                                                        retailers?[index].id) ??
                                                    0),
                                      ),
                              child: DistributorList(
                                img: distributors?[index].logo ??
                                    retailers?[index].pic,
                                name: distributors?[index].name ??
                                    retailers?[index].name ??
                                    "",
                                distId: distId,
                                loading: loadingDist,
                                dist: distributors?[index],
                                ret: retailers?[index],
                                changeDefault: loadingDist
                                    ? () {
                                        print("Forever I Will Sing");
                                      }
                                    : () => bloc.add(
                                          ChangeDistributorEvent(
                                              distributorId:
                                                  (distributors?[index].id ??
                                                          retailers?[index]
                                                              .id) ??
                                                      0),
                                        ),
                              ),
                            );
                          },
                        );
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
