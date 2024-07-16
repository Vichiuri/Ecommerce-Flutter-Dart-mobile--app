import 'package:biz_mobile_app/core/errors/exeptions.dart';
import 'package:biz_mobile_app/features/data/responses/notification_response.dart';
import 'package:biz_mobile_app/features/domain/models/notification/list_notification_model.dart';
import 'package:biz_mobile_app/features/domain/models/notification/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

abstract class FirebaseHelper {
  Future<String?> getFcmToken();
  Future<NotificationResponse?> getInitialMessage();
  // Stream<
}

//firebase, check doc
@LazySingleton(as: FirebaseHelper)
class FirebaseHelperImpl implements FirebaseHelper {
  final FirebaseMessaging firebaseMessaging;

  FirebaseHelperImpl(this.firebaseMessaging);
  @override
  Future<String?> getFcmToken() {
    try {
      return firebaseMessaging.getToken();
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<NotificationResponse?> getInitialMessage() {
    return firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        return NotificationResponse(
          notifications: [],
          singleNotification: ListNotificationModel(
            id: message.data['id'],
            distributor: message.data['distributor'],
            display_text: message.data['display_text'],
            detail: message.data['detail'],
            status: message.data['status'],
            offer: message.data['offer'],
            product: message.data['product'],
            name: message.data['name'],
            pic: message.data['pic'],
          ),
          notificationModel: NotificationModel(
            body: message.notification?.body ?? "",
            message: message,
            title: message.notification?.title ?? "",
          ),
        );
        // return right<String, NotificationResponse>(response);
      }
    }).catchError((e) {
      print(e.toString());
      throw ServerException();
    });
  }
}
