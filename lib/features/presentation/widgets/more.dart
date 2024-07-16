import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/features/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/distributor/distributor_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/data/datasourse/local/local_data_source.dart';
import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';
import 'package:biz_mobile_app/features/presentation/bloc/fetch_current_distributor/fetch_current_distributor_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/splash/splash_bloc.dart';
import 'package:biz_mobile_app/features/presentation/screens/order_history.dart';

import '../screens/distributors.dart';
import '../screens/profile.dart';

// const _url = 'https://netbotgroup.com/';

// void _launchURL() async =>
//     await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

//more screen
class NavDrawer extends StatefulWidget {
  // final int distId;

  const NavDrawer({Key? key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  DistributorsModel? _distributorsModel;
  String _changed = "";
  final _distBloc = getIt<DistributorBloc>();
  @override
  void initState() {
    super.initState();
    _getDistName();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<FetchCurrentDistributorBloc>()..add(FetchCurrentStarted());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getDistName() async {
    final _distributor =
        await getIt<LocalDataSource>().getSalesmanDistributor();
    setState(() {
      _distributorsModel = _distributor;
      if (_distributor != null) {
        _changed = "Retailer";
      } else {
        _changed = "Distributor";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => _distBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<DistributorBloc, DistributorState>(
            listener: (context, state) {
              if (state is ChangeDistributorSuccess) {
                context.read<DashboardBloc>()..add(UpdateDashBoardEvent());
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();

                print("CHANGE SUCCESS");

                context
                    .read<FetchCurrentDistributorBloc>()
                    .add(FetchCurrentStarted());
              }
            },
          ),
          BlocListener<SplashBloc, SplashState>(
            listener: (context, state) {
              if (state is SplashToLogin) {
                AutoRouter.of(context).replace(LoginPageRoute());
                // _navKey.currentContext?.router.replace(LoginPageRoute());
              }
            },
          ),
          BlocListener<FetchCurrentDistributorBloc,
              FetchCurrentDistributorState>(
            listener: (context, state) {
              if (state is FetchCurrentDistributorSuccess) {
                if (state.distributor != null) {
                  _distributorsModel = state.distributor;
                }
                // if (state.distributor != null) {
                //   _changed = "Distributor";
                // }
                // if (state.retailerModel != null) {
                //   _changed = "Retailer";
                // }
              }
            },
          )
        ],
        child: BlocBuilder<FetchCurrentDistributorBloc,
            FetchCurrentDistributorState>(
          builder: (context, state) {
            if (state is FetchCurrentDistributorLoading) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width,
                  // height: 200,
                  // alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        child: Image.network(
                          IMAGE_URL + "${_distributorsModel?.logo ?? ""}",
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            print(
                              'An error occurred loading $IMAGE_URL + "${_distributorsModel?.name ?? ""}"' +
                                  error.toString() +
                                  ", " +
                                  stackTrace.toString(),
                            );
                            return Image.asset(
                              "assets/images/blue.jpg",
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Text("");
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _distributorsModel?.name.toUpperCase() ?? "",
                            style: Theme.of(context).textTheme.headline5,
                            overflow: TextOverflow.fade,
                          ),
                          Text(
                            _distributorsModel?.category ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "email: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: _distributorsModel?.email,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.blue,
                                ),
                              )
                            ]),
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "website: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: _distributorsModel?.website,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.blue,
                                ),
                              )
                            ]),
                          ),
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "address: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: _distributorsModel?.address,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.blue,
                                ),
                              )
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ListTile(
                //   onTap: () => {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (BuildContext context) {
                //           return Distributor();
                //           // the changed code
                //         },
                //       ),
                //     ).then(
                //       (value) => context.read<FetchCurrentDistributorBloc>()
                //         ..add(FetchCurrentStarted()),
                //     )
                //   },
                //   leading: Icon(Icons.input),
                //   title: Text("Change $_changed"),
                // ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Order History'),
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderHistory(),
                    ))
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return Profile();
                          // the changed code
                        },
                      ),
                    )
                  },
                ),
                ListTile(
                  leading: Icon(Icons.upgrade),
                  title: Text('Upgrade'),
                  onTap: () => canLaunch(UPDATE_URL)
                      .then(
                    (value) => {
                      if (value)
                        {
                          launch(UPDATE_URL).catchError(
                              (e, s) => throw "ERROR IN LAUNCHING URL: $e,$s")
                        }
                      else
                        {print("BOOL FALSE CANNOT LAUNCH URL")}
                    },
                  )
                      .catchError(
                    (e, s) {
                      print("CANNOT LAUNCH URL: $e,$s");
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.import_contacts_outlined),
                  title: Text('About Distributor'),
                  onTap: () => AutoRouter.of(context)
                      .push(ABoutUsPageRoute(about: _distributorsModel!.about)),
                ),
                ListTile(
                  leading: Icon(Icons.contact_support),
                  title: Text("Contact Us"),
                  trailing: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => canLaunch(
                                'https://wa.me/${_distributorsModel?.phone ?? ""}')
                            .then(
                          (value) => {
                            if (value)
                              {
                                launch("https://wa.me/${_distributorsModel?.phone ?? ""}")
                                    .catchError((e, s) => throw "$e,$s")
                              }
                            else
                              {print("CANNOT LAUNCH WHATSAPP")}
                          },
                        )
                            .catchError((e, s) {
                          print("$e,$s");
                        }),
                        color: Color(0xff25D366),
                        icon: Icon(FontAwesomeIcons.whatsapp),
                      ),
                      IconButton(
                        onPressed: () =>
                            canLaunch('tel:${_distributorsModel?.phone ?? ""}')
                                .then(
                          (value) => {
                            if (value)
                              {
                                launch("tel:${_distributorsModel?.phone ?? ""}")
                                    .catchError((e, s) => throw "$e,$s")
                              }
                            else
                              {print("CANNOT LAUNCH CONTACTS")}
                          },
                        )
                                .catchError((e, s) {
                          print("$e,$s");
                        }),
                        color: Colors.blue,
                        icon: Icon(FontAwesomeIcons.phone),
                      )
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.settings_power),
                  title: Text('Log Out'),
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(null),
                            child: Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("LOGOUT"),
                          ),
                        ],
                      );
                    },
                  ).then((value) => {
                        if (value != null && value)
                          {
                            context.read<SplashBloc>()..add(LogoutEvent()),
                          }
                      }),
                ),
                SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}
