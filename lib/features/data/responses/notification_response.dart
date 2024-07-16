import 'package:biz_mobile_app/core/errors/NetworkErrorHandler.dart';
import 'package:biz_mobile_app/features/domain/models/notification/list_notification_model.dart';
import 'package:biz_mobile_app/features/domain/models/notification/notification_model.dart';
import 'package:biz_mobile_app/features/domain/models/offers/offer_model.dart';

class NotificationResponse {
  final List<ListNotificationModel> notifications;
  final ListNotificationModel? singleNotification;
  final NotificationModel? notificationModel;
  final List<OfferModel>? offers;
  final String? error;
  NotificationResponse({
    required this.notifications,
    this.offers,
    this.error,
    this.singleNotification,
    this.notificationModel,
  });

  NotificationResponse.withError(String error)
      : notifications = [],
        offers = [],
        singleNotification = null,
        notificationModel = null,
        error = networkErrorHandler(error);
}
