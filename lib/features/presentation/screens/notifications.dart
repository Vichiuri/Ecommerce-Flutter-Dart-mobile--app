import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/features/domain/models/notification/list_notification_model.dart';
import 'package:biz_mobile_app/features/presentation/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:biz_mobile_app/features/presentation/components/refresh_widget.dart';
import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'offer_detail_screen.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<NotificationsBloc>().add(GetNotificationStarted());
    });
  }

  List<ListNotificationModel> notifications = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsSuccess) {
              notifications = state.response.notifications;
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            "Notifications",
          ),
          elevation: 0.0,
        ),
        body: RefreshWidget(
          onRefresh: () {
            context.read<NotificationsBloc>().add(GetNotificationUpdated());
            return context
                .read<NotificationsBloc>()
                .stream
                .firstWhere((e) => e is! GetNotificationUpdated);
          },
          child: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                itemCount: notifications.length,
                itemBuilder: (context, i) {
                  String notification_image = notifications[i].pic != null
                      ? IMAGE_URL + notifications[i].pic!
                      : '';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(notification_image),
                      // backgroundColor: Colors.red,
                    ),
                    title: Text(notifications[i].name),
                    subtitle: Text(notifications[i].detail),
                    trailing: Text(notifications[i].status),
                    onTap: () {
                      if (notifications[i].status == "Product") {
                        AutoRouter.of(context).push(ProductDetailsScreenRoute(
                          detailsArguments: ProductDetailsArguments(
                            product: null,
                            initialValue: 0,
                            id: notifications[i].product,
                          ),
                        ));
                      }

                      if (notifications[i].status == "Offer") {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return OfferDetailScreen(
                                offerId: notifications[i].offer,
                              );
                            },
                          ),
                        );
                      }
                      if (notifications[i].status == "Order") {
                        AutoRouter.of(context).push(
                            OrderHistoryRoute(orderId: notifications[i].order));
                      }
                      print("Notification");
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
              );
            },
          ),
        ),
      ),
    );
  }
}
