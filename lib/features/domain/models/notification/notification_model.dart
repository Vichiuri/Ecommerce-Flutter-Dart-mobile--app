import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationModel {
  final String title;
  final String body;
  final RemoteMessage message;
  final AndroidNotification? android;
  final RemoteNotification? notification;

  NotificationModel({
    required this.title,
    required this.body,
    this.android,
    this.notification,
    required this.message,
  });
}
