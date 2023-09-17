import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as ti;

class NotificationsInitialization {
  final sound = 'notification_sound.wav';
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final _initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings());
  final _channel = const AndroidNotificationChannel("notifications", "Single Main Channel for Notifications",
      importance: Importance.max);

  Future<void> initialize() async {
    ti.initializeTimeZones();

    final local = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(local));

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()!
          .requestPermissions(sound: true, alert: true, badge: true);
    } else {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(_channel);
    }
    await flutterLocalNotificationsPlugin.initialize(_initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationResponse);
  }

  void _onNotificationResponse(NotificationResponse nr) async {
    await cancelNotification(nr.id!);
  }

  // Future<void> addBadgeToAppIcon(Duration duration) async {
  //   _notifCount.badgeCount += 1;
  //   await Future.delayed(
  //     duration,
  //     () async {
  //       if (await FlutterAppBadger.isAppBadgeSupported()) {
  //         FlutterAppBadger.updateBadgeCount(_notifCount.badgeCount);
  //       }
  //     },
  //   );
  // }

  Future<void> cancelAllNotifications() async => await flutterLocalNotificationsPlugin.cancelAll();

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    // if (await FlutterAppBadger.isAppBadgeSupported()) {
    //   final c = _notifCount.badgeCount -= 1;
    //   if (c == 0) {
    //     FlutterAppBadger.removeBadge();
    //   } else {
    //     FlutterAppBadger.updateBadgeCount(c);
    //   }
    // }
  }
}

class ReminderNotification {
  final NotificationsInitialization _initialization;

  const ReminderNotification({required NotificationsInitialization init}) : _initialization = init;

  Future<void> schedule() async {
    var androidDetails = AndroidNotificationDetails(
      // NotificationIDs.missing.toString(),
      '1',
      'Missing',
      channelDescription: 'App is missing you',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound(_initialization.sound.split('.').first),
      // icon: NotificationResources.icon,
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      // sound: _initialization.sound,
    );

    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);
    final now = DateTime.now();

    await _initialization.flutterLocalNotificationsPlugin.zonedSchedule(
      // NotificationIDs.missing,
      1,
      'Reminder',
      'You haven\'t visited the app in a while',
      tz.TZDateTime.local(now.year, now.month, now.day + 5, 17, 0, 0),
      generalNotificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      // androidAllowWhileIdle: true,
    );

    await _initialization.flutterLocalNotificationsPlugin.zonedSchedule(
      // NotificationIDs.missing2,
      2,
      'Reminder',
      'You haven\'t visited the app in a while',
      tz.TZDateTime.local(now.year, now.month, now.day + 7, 17, 0, 0),
      generalNotificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      // androidAllowWhileIdle: true,
    );

    await _initialization.flutterLocalNotificationsPlugin.zonedSchedule(
      // NotificationIDs.missing3,
      3,
      'Reminder',
      'You haven\'t visited the app in a while',
      tz.TZDateTime.local(now.year, now.month, now.day + 9, 17, 0, 0),
      generalNotificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      // androidAllowWhileIdle: true,
    );

    await _initialization.flutterLocalNotificationsPlugin.zonedSchedule(
      // NotificationIDs.missing4,
      4,
      'Reminder',
      'You haven\'t visited the app in a while',
      tz.TZDateTime.local(now.year, now.month, now.day + 11, 17, 0, 0),
      generalNotificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      // androidAllowWhileIdle: true,
    );

    // await _initialization.addBadgeToAppIcon(d);
  }

  Future<void> cancel() async => _initialization
    ..cancelNotification(1)
    ..cancelNotification(2)
    ..cancelNotification(3)
    ..cancelNotification(4);
}
