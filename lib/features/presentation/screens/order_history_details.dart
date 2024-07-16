import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/di/injection.dart';
import 'package:biz_mobile_app/features/domain/models/RetailOrder/transport_model.dart';
import 'package:biz_mobile_app/features/presentation/bloc/transport/transport_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/models/RetailOrder/retail_order_model.dart';

///Details of order history
class OrderHistoryDetails extends StatefulWidget {
  const OrderHistoryDetails({Key? key, required this.retailOrder})
      : super(key: key);
  final RetailOrdersModel retailOrder;

  @override
  _OrderHistoryDetailsState createState() => _OrderHistoryDetailsState();
}

class _OrderHistoryDetailsState extends State<OrderHistoryDetails> {
  late final _transportBloc = getIt<TransportBloc>();

  List<TransportModel> _trans = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.retailOrder.status.toLowerCase() == "partial" ||
          widget.retailOrder.status.toLowerCase() == "dispatched") {
        _transportBloc.add(FetchTransportEvent(retId: widget.retailOrder.id));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _transportBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => _transportBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener(
            listener: (c, TransportState state) {
              if (state is TransportSuccess) {
                _trans = state.response.transport;
              }
              if (state is TransportError) {
                showSimpleNotification(
                  Text("Error"),
                  position: NotificationPosition.bottom,
                  subtitle: Text(state.error),
                  background: Colors.red,
                );
              }
            },
            bloc: _transportBloc,
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Reference No: #" + widget.retailOrder.referenceNumber.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Track Id: #",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // SizedBox(width: 10.0),
                    Text(
                      widget.retailOrder.id.toString(),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.retailOrder.status.toUpperCase(),
                      style: TextStyle(
                        color: widget.retailOrder.status.toLowerCase() ==
                                "pending"
                            ? Colors.blue
                            : widget.retailOrder.status.toLowerCase() ==
                                    "approved"
                                ? Colors.green
                                : widget.retailOrder.status.toLowerCase() ==
                                        "declined"
                                    ? Colors.red
                                    : widget.retailOrder.status.toLowerCase() ==
                                            "canceled"
                                        ? Colors.grey[400]
                                        : widget.retailOrder.status
                                                    .toLowerCase() ==
                                                "partial"
                                            ? Colors.orange[900]
                                            : Colors.orange[300],
                      ),
                    ),
                    // Text("Price: Ksh 30,000,000")
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Total: ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                          text: widget.retailOrder.totalCost,
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date:"),
                    Text(widget.retailOrder.whenPlaced!),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (c, i) => Divider(),
                        itemCount: widget.retailOrder.retOrders.length,
                        itemBuilder: (context, i) {
                          return Card(
                            elevation: 0,
                            margin: EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 5,
                            ),
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: widget.retailOrder.retOrders[i]
                                              .product.product_images.isEmpty
                                          ? Image.asset(
                                              "assets/images/placeholder.png")
                                          : CachedNetworkImage(
                                              imageUrl: IMAGE_URL +
                                                  widget
                                                      .retailOrder
                                                      .retOrders[i]
                                                      .product
                                                      .product_images
                                                      .first
                                                      .image!,
                                              placeholder: (c, s) => Image.asset(
                                                  "assets/images/placeholder.png"),
                                              errorWidget: (c, s, o) => Image.asset(
                                                  "assets/images/placeholder.png"),
                                            ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.retailOrder.retOrders[i].product.name}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Price Per Item: ${widget.retailOrder.retOrders[i].perPrice}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        widget.retailOrder.retOrders[i]
                                                    .freeQty !=
                                                0
                                            ? Text(
                                                "Free Quantity: " +
                                                    widget.retailOrder
                                                        .retOrders[i].freeQty
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              )
                                            : Container(),
                                        Text(
                                          "Total Quantity: " +
                                              widget.retailOrder.retOrders[i]
                                                  .totalQty
                                                  .toString(),
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Delivered Quantity: " +
                                              widget.retailOrder.retOrders[i]
                                                  .deliveredQty
                                                  .toString(),
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text.rich(
                                          TextSpan(children: [
                                            TextSpan(
                                              text: "Order Price: ",
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.retailOrder
                                                  .retOrders[i].orderPrice,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                    flex: 3,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<TransportBloc, TransportState>(
                        builder: (context, state) {
                          if (state is TransportSuccess) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "DELIVERIES",
                                  style: TextStyle(color: Colors.orange),
                                ),
                                SizedBox(height: 5),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _trans.length,
                                  itemBuilder: (c, i) => Card(
                                    elevation: 0,
                                    margin: EdgeInsets.all(5),
                                    child: ListTile(
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (builder) => AlertDialog(
                                          title: Text("ITEMS DELIVERED"),
                                          scrollable: true,
                                          content: Container(
                                            constraints:
                                                BoxConstraints(maxHeight: 400),
                                            child: ListView.separated(
                                              separatorBuilder: (c, i) =>
                                                  SizedBox(height: 5),
                                              shrinkWrap: true,

                                              // physics:
                                              //     NeverScrollableScrollPhysics(),
                                              itemCount: _trans[i].items.length,
                                              itemBuilder: (c, index) {
                                                late final _item =
                                                    _trans[i].items[index];
                                                return Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: _item.image !=
                                                                null
                                                            ? CachedNetworkImage(
                                                                imageUrl:
                                                                    IMAGE_URL +
                                                                        _item
                                                                            .image!,
                                                                placeholder: (c,
                                                                        s) =>
                                                                    Image.asset(
                                                                        "assets/images/placeholder.png"),
                                                                errorWidget: (c,
                                                                        s, o) =>
                                                                    Image.asset(
                                                                        "assets/images/placeholder.png"),
                                                              )
                                                            : Image.asset(
                                                                "assets/images/placeholder.png"),
                                                      ),
                                                      SizedBox(width: 2),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(_item.name ??
                                                                ""),
                                                            Text(
                                                              "Quantity: ${_item.quantity}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        "Driver: ${_trans[i].transpoterName}",
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Vehicle: ${_trans[i].vehicle}"),
                                          SizedBox(height: 3),
                                          // _trans[i].date != null
                                          //     ? Text(
                                          //         "Date: ${parseUniqueDate(_trans[i].date!)}")
                                          //     : Text("")
                                        ],
                                      ),
                                      trailing: IconButton(
                                        onPressed: () =>
                                            canLaunch('tel:${_trans[i].phone}')
                                                .then(
                                          (value) => {
                                            if (value)
                                              {
                                                launch("tel:${_trans[i].phone}")
                                                    .catchError(
                                                        (e, s) => throw "$e,$s")
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
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                          return Container();
                        },
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.retailOrder.status == "Declined"
                        ? Text("Reasons for declined")
                        : Text("Notes:"),
                    Text(widget.retailOrder.note ?? ""),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
