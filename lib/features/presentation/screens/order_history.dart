import 'dart:async';

import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';
import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';
import 'package:biz_mobile_app/features/presentation/bloc/delete_order/delete_order_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/fetch_current_distributor/fetch_current_distributor_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/order_history/order_history_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/confirm_dialog.dart';
import 'package:biz_mobile_app/features/presentation/components/error_widget.dart';
import 'package:biz_mobile_app/features/presentation/screens/order_history_details.dart';
import 'package:biz_mobile_app/features/presentation/widgets/bottom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/models/RetailOrder/retail_order_model.dart';

///All order history
class OrderHistory extends StatefulWidget {
  final int? orderId;

  const OrderHistory({Key? key, this.orderId}) : super(key: key);
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  late final _scrollController = ScrollController();
  late final historyBloc = getIt<OrderHistoryBloc>();
  late final deleteBloc = getIt<DeleteOrderBloc>();
  List<RetailOrdersModel> retailOrder = [];
  String? _chosenValue;
  RetailerModel? _ret;
  DistributorsModel? _dist;
  // List<String> _menuItems = ["Sort Orders, Filter Orders"];
  String _dateFrom = "";
  String _dateTo = "";
  int? _timestampFrom;
  int? _timestampTo;
  Completer<void>? _refreshCompleter;
  int? _orderid;

  bool _initialLoad = false;
  bool _isBottomLoading = false;
  int _currentPage = 1;
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    historyBloc.add(GetOrderHistoryStarted(page: 1, retOrder: []));
    _orderid = widget.orderId;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<FetchCurrentDistributorBloc>()..add(FetchCurrentStarted());
      _initialLoad = true;
    });
    _scrollController.addListener(_onsCroll);
  }

  @override
  void dispose() {
    super.dispose();
    deleteBloc.close();
    historyBloc.close();
    _scrollController.dispose();
  }

  void _onsCroll() {
    late final _maxScroll = _scrollController.position.maxScrollExtent;
    late final _currentScroll = _scrollController.position.pixels;
    if (_currentScroll == _maxScroll) {
      if (_currentPage < _lastPage) {
        _isBottomLoading = true;
        historyBloc.add(GetOrderHistoryStarted(
            page: (_currentPage + 1), retOrder: retailOrder));
      } else {
        _isBottomLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => historyBloc),
        BlocProvider(create: (context) => deleteBloc)
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FetchCurrentDistributorBloc,
              FetchCurrentDistributorState>(
            listener: (context, state) {
              if (state is FetchCurrentDistributorSuccess) {
                _ret = state.retailerModel;
                _dist = state.distributor;
              }
            },
          ),
          BlocListener<OrderHistoryBloc, OrderHistoryState>(
            listener: (context, state) {
              if (state is OrderHistorySuccess) {
                retailOrder = state.retailOrder;
                _isBottomLoading = false;
                _refreshCompleter?.complete();
                _refreshCompleter = Completer();
                WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                  if (_orderid != null) {
                    final _index = state.retailOrder
                        .indexWhere((element) => element.id == _orderid);
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        130 * _index.toDouble(),
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    }
                  }
                });
              }
            },
          ),
          BlocListener<DeleteOrderBloc, DeleteOrderState>(
            listener: (context, state) {
              if (state is DeleteOrderSuccess) {
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                showSimpleNotification(
                  Text(state.message),
                  background: Colors.green,
                  position: NotificationPosition.bottom,
                );
                historyBloc.add(GetOrderHistoryUpdated(retOrder: []));
              }
              if (state is DeleteOrderError) {
                ScaffoldMessenger.maybeOf(context)!..hideCurrentSnackBar();
                showSimpleNotification(
                  Text(state.message),
                  background: Colors.red,
                  position: NotificationPosition.bottom,
                );
              }
              if (state is DeleteOrderLoading) {
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
                            "Loading...",
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
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text("Order History"),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      focusColor: Colors.white,
                      hint: Text("Filter by Status"),
                      value: _chosenValue,
                      onChanged: (value) {
                        setState(() {
                          _chosenValue = value;
                          _orderid = null;
                          _initialLoad = true;
                        });
                        // if (value?.toLowerCase() == "all") {}
                        historyBloc.add(FilterOrderHistoryEvent(
                          status: value,
                          timeStampFrom: _timestampFrom,
                          timeStampTo: _timestampTo,
                        ));
                      },
                      items: <String>[
                        "APPROVED",
                        "PENDING",
                        "DISPATCHED",
                        "ON HOLD",
                        "DECLINED",
                        "CANCELED",
                        "PARTIAL",
                        "ALL"
                      ]
                          .map<DropdownMenuItem<String>>((value) =>
                              DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: value.toLowerCase() == "pending"
                                        ? Colors.blue
                                        : value.toLowerCase() == "approved"
                                            ? Colors.green
                                            : value.toLowerCase() == "declined"
                                                ? Colors.red
                                                : value.toLowerCase() ==
                                                        "canceled"
                                                    ? Colors.grey[400]
                                                    : value.toLowerCase() ==
                                                            "all"
                                                        ? Colors.black
                                                        : value.toLowerCase() ==
                                                                'partial'
                                                            ? Colors.orange[900]
                                                            : Colors
                                                                .orange[300],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    Column(
                      children: [
                        Text("Fiter by Date"),
                        Row(
                          children: [
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime(2101),
                                  ).then((value) => {
                                        if (value != null)
                                          {
                                            setState(() {
                                              _dateFrom =
                                                  "${value.day}/${value.month}/${value.year}";
                                              _timestampFrom =
                                                  value.millisecondsSinceEpoch;
                                            }),
                                            historyBloc
                                                .add(FilterOrderHistoryEvent(
                                              status: _chosenValue,
                                              timeStampFrom: _timestampFrom,
                                              timeStampTo: _timestampTo,
                                            )),
                                          }
                                      }),
                                  child: Text('From'),
                                ),
                                SizedBox(height: 3),
                                Text(_dateFrom),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2015, 8),
                                    lastDate: DateTime(2101),
                                  ).then((value) => {
                                        if (value != null)
                                          {
                                            setState(() {
                                              _dateTo =
                                                  "${value.day}/${value.month}/${value.year}";
                                              _timestampTo =
                                                  value.millisecondsSinceEpoch;
                                            }),
                                            historyBloc
                                                .add(FilterOrderHistoryEvent(
                                              status: _chosenValue,
                                              timeStampFrom: _timestampFrom,
                                              timeStampTo: _timestampTo,
                                            )),
                                          }
                                      }),
                                  child: Text('To'),
                                ),
                                SizedBox(height: 3),
                                Text(_dateTo),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
                    builder: (context, state) {
                      if (state is OrderHistorySuccess) {
                        print("LAST PAGE: ${state.lastPage}");
                        print("CURRENT PAGE: ${state.currentPage}");
                        _isBottomLoading = false;
                        _initialLoad = false;
                        // setState(() {
                        _currentPage = state.currentPage;
                        _lastPage = state.lastPage;
                        // });
                      }
                      // if (state is OrderHistoryLoading) {
                      // return Center(
                      //   child: CircularProgressIndicator.adaptive(
                      //     valueColor: AlwaysStoppedAnimation(Colors.blue),
                      //   ),
                      // );
                      // }
                      if (state is OrderHistoryError) {
                        _isBottomLoading = false;
                        _initialLoad = false;
                        return DashboardErrorWidget(
                            refresh: () => historyBloc
                              ..add(GetOrderHistoryStarted(
                                  retOrder: retailOrder)));
                      }

                      return _initialLoad
                          ? Center(
                              child: CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation(Colors.blue),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () {
                                setState(() {
                                  _chosenValue = null;
                                  _orderid = null;
                                });
                                // _keyRefresh.currentState?.show();
                                historyBloc
                                    .add(GetOrderHistoryUpdated(retOrder: []));
                                return _refreshCompleter!.future;
                              },
                              child: retailOrder.isEmpty
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: SingleChildScrollView(
                                        physics: AlwaysScrollableScrollPhysics(
                                            parent:
                                                AlwaysScrollableScrollPhysics()),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Lottie.asset(
                                                  "assets/lottie/order_history.json"),
                                            ),
                                            Text(
                                              "NO ORDER HISTORY",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 100,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: EdgeInsets.only(bottom: 30),
                                      controller: _scrollController,
                                      physics: const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      itemCount: retailOrder.length + 1,
                                      itemBuilder: (context, i) {
                                        if (i == retailOrder.length) {
                                          return _isBottomLoading
                                              ? BottomLoader()
                                              : Opacity(opacity: 0);
                                        }
                                        // final dateTime =
                                        //     DateTime.parse(retailOrder[i].whenPlaced!);
                                        return GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (builder) =>
                                                  OrderHistoryDetails(
                                                      retailOrder:
                                                          retailOrder[i]),
                                            ),
                                          ),
                                          child: Card(
                                            child: Container(
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: widget.orderId != null &&
                                                        widget.orderId ==
                                                            retailOrder[i].id
                                                    ? Colors.blue
                                                        .withOpacity(0.2)
                                                    : Colors.transparent,
                                              ),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Reference No: #" +
                                                              retailOrder[i]
                                                                  .referenceNumber
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        // Text("Total items: 30"),
                                                        RichText(
                                                          text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        "Payment Terms: ",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black)),
                                                                TextSpan(
                                                                    text: retailOrder[
                                                                            i]
                                                                        .paymentTerms,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                    ))
                                                              ]),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(retailOrder[i]
                                                            .distributor
                                                            .name),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        // Text("Price: Ksh 30,000,000")
                                                        RichText(
                                                          text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        "Price: ",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black)),
                                                                TextSpan(
                                                                  text: retailOrder[
                                                                          i]
                                                                      .totalCost,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                )
                                                              ]),
                                                        ),

                                                        Text(
                                                          "Date: " +
                                                              retailOrder[i]
                                                                  .whenPlaced!,
                                                        ),
                                                        if (_ret != null)
                                                          Expanded(
                                                            child: TextButton(
                                                              onPressed: () =>
                                                                  canLaunch(
                                                                          'tel:${retailOrder[i].retailer?.phone ?? ""}')
                                                                      .then(
                                                                (value) => {
                                                                  if (value)
                                                                    {
                                                                      launch("tel:${retailOrder[i].retailer?.phone ?? ""}").catchError((e,
                                                                              s) =>
                                                                          throw "$e,$s")
                                                                    }
                                                                  else
                                                                    {
                                                                      print(
                                                                          "CANNOT LAUNCH CONTACTS")
                                                                    }
                                                                },
                                                              )
                                                                      .catchError(
                                                                          (e, s) {
                                                                print("$e,$s");
                                                              }),
                                                              style:
                                                                  ButtonStyle(
                                                                textStyle: MaterialStateProperty
                                                                    .resolveWith<
                                                                            TextStyle>(
                                                                        (states) {
                                                                  if (states.contains(
                                                                      MaterialState
                                                                          .hovered))
                                                                    return TextStyle(
                                                                        color: Colors
                                                                            .blue
                                                                            .withOpacity(0.04));
                                                                  if (states.contains(
                                                                          MaterialState
                                                                              .focused) ||
                                                                      states.contains(
                                                                          MaterialState
                                                                              .pressed))
                                                                    return TextStyle(
                                                                        color: Colors
                                                                            .blue
                                                                            .withOpacity(0.12));
                                                                  return TextStyle();
                                                                }),
                                                                minimumSize:
                                                                    MaterialStateProperty
                                                                        .all(Size(
                                                                            10,
                                                                            10)),
                                                                padding:
                                                                    MaterialStateProperty
                                                                        .all(
                                                                  EdgeInsets
                                                                      .zero,
                                                                ),
                                                              ),
                                                              child: Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text:
                                                                          "Retailer: ",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          "${retailOrder[i].retailer?.name ?? ""} (${retailOrder[i].retailer?.phone ?? ""})",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              // child: Text(
                                                              // "${retailOrder[i].retailer?.name ?? ""} (${retailOrder[i].retailer?.phone ?? ""})",
                                                              // style: TextStyle(
                                                              //     fontSize:
                                                              //         13),
                                                              // ),
                                                            ),
                                                          ),
                                                        if (_dist != null &&
                                                            retailOrder[i]
                                                                    .salesman !=
                                                                null)
                                                          Expanded(
                                                            child: TextButton(
                                                                onPressed: () =>
                                                                    canLaunch(
                                                                            'tel:${retailOrder[i].salesman?.phone ?? ""}')
                                                                        .then(
                                                                      (value) =>
                                                                          {
                                                                        if (value)
                                                                          {
                                                                            launch("tel:${retailOrder[i].salesman?.phone ?? ""}").catchError((e, s) =>
                                                                                throw "$e,$s")
                                                                          }
                                                                        else
                                                                          {
                                                                            print("CANNOT LAUNCH CONTACTS")
                                                                          }
                                                                      },
                                                                    )
                                                                        .catchError((e,
                                                                            s) {
                                                                      print(
                                                                          "$e,$s");
                                                                    }),
                                                                style:
                                                                    ButtonStyle(
                                                                  textStyle: MaterialStateProperty
                                                                      .resolveWith<
                                                                              TextStyle>(
                                                                          (states) {
                                                                    if (states.contains(
                                                                        MaterialState
                                                                            .hovered))
                                                                      return TextStyle(
                                                                          color: Colors
                                                                              .blue
                                                                              .withOpacity(0.04));
                                                                    if (states.contains(MaterialState
                                                                            .focused) ||
                                                                        states.contains(
                                                                            MaterialState.pressed))
                                                                      return TextStyle(
                                                                          color: Colors
                                                                              .blue
                                                                              .withOpacity(0.12));
                                                                    return TextStyle();
                                                                  }),
                                                                  minimumSize:
                                                                      MaterialStateProperty
                                                                          .all(Size(
                                                                              10,
                                                                              10)),
                                                                  padding:
                                                                      MaterialStateProperty
                                                                          .all(
                                                                    EdgeInsets
                                                                        .zero,
                                                                  ),
                                                                ),
                                                                child:
                                                                    Text.rich(
                                                                  TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                            text:
                                                                                "Salesman: ",
                                                                            style:
                                                                                TextStyle(color: Colors.black)),
                                                                        TextSpan(
                                                                          text:
                                                                              "${retailOrder[i].salesman?.name ?? ""} (${retailOrder[i].salesman?.phone ?? ""})",
                                                                          style:
                                                                              TextStyle(fontSize: 13),
                                                                        ),
                                                                      ]),
                                                                )),
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          retailOrder[i]
                                                              .status
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: retailOrder[
                                                                            i]
                                                                        .status
                                                                        .toLowerCase() ==
                                                                    "pending"
                                                                ? Colors.blue
                                                                : retailOrder[i]
                                                                            .status
                                                                            .toLowerCase() ==
                                                                        "approved"
                                                                    ? Colors
                                                                        .green
                                                                    : retailOrder[i].status.toLowerCase() ==
                                                                            "declined"
                                                                        ? Colors
                                                                            .red
                                                                        : retailOrder[i].status.toLowerCase() ==
                                                                                "canceled"
                                                                            ? Colors.grey[400]
                                                                            : retailOrder[i].status.toLowerCase() == 'partial'
                                                                                ? Colors.orange[900]
                                                                                : Colors.orange[300],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        retailOrder[i]
                                                                    .status
                                                                    .toLowerCase() ==
                                                                "pending"
                                                            ? TextButton(
                                                                // onPressed: () => deleteBloc
                                                                //     .add(DeleteOrderStarted(
                                                                //   orderId: retailOrder[i].id,
                                                                // )),
                                                                onPressed: () =>
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (builder) =>
                                                                            ConfirmDialogue(
                                                                              function: () {
                                                                                deleteBloc.add(DeleteOrderStarted(
                                                                                  orderId: retailOrder[i].id,
                                                                                ));
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              text: 'Cancel Order',
                                                                            )),
                                                                child: Text(
                                                                  "CANCEL",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              )
                                                            : retailOrder[i].status ==
                                                                        "Dispatched" &&
                                                                    !retailOrder[
                                                                            i]
                                                                        .confirmDelivery!
                                                                ? MaterialButton(
                                                                    // onPressed: () => deleteBloc
                                                                    //     .add(DeleteOrderStarted(
                                                                    //   orderId: retailOrder[i].id,
                                                                    // )),
                                                                    elevation:
                                                                        3,
                                                                    color: Colors
                                                                        .green,
                                                                    onPressed: () => showDialog(
                                                                        context: context,
                                                                        builder: (builder) => ConfirmDialogue(
                                                                              function: () {
                                                                                deleteBloc.add(
                                                                                  ConfirmDeliveryEvent(
                                                                                    orderId: retailOrder[i].id,
                                                                                  ),
                                                                                );
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              text: 'Confirm Delivery',
                                                                            )),
                                                                    child: Text(
                                                                      "Confirm Delivery",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )
                                                                : retailOrder[i]
                                                                            .status ==
                                                                        "Dispatched"
                                                                    ? MaterialButton(
                                                                        color: Colors
                                                                            .blue,
                                                                        onPressed: () => showDialog(
                                                                            context: context,
                                                                            builder: (builder) => ConfirmDialogue(
                                                                                  function: () => Navigator.of(context).pop(true),
                                                                                  text: 'Re-Order Items',
                                                                                )).then((value) => {
                                                                              if (value != null && value)
                                                                                {
                                                                                  deleteBloc.add(ReOrderEvent(orderId: retailOrder[i].id))
                                                                                }
                                                                            }),
                                                                        child:
                                                                            Text(
                                                                          "Re-Order",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      )
                                                                    : Container()
                                                      ],
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
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
