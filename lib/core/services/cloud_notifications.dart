import 'package:firebase_messaging/firebase_messaging.dart';

class CloudNotifications {
  const CloudNotifications._();

  static Future<void> requestPermissions() async {
    // print(await FirebaseMessaging.instance.getToken());
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static onBackgroundMessage() async {
    FirebaseMessaging.onBackgroundMessage((message) async {});
  }
}
