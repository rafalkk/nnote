import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class NotificationHelper {
  Future<void> requestPermissions() async {
    PermissionStatus permissionStatus = await Permission.notification.status;
    if (permissionStatus != PermissionStatus.granted) {
      permissionStatus = await Permission.notification.request();
    }
    if (permissionStatus == PermissionStatus.granted) {
      print('permission granted');
    } else {
      print('permission not granted');
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    var initializeSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestCriticalPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializeSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializeSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializeSettings);
  }

  Future<void> showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_01',
      'notes',
      channelDescription: 'channel for notes notifications',
      importance: Importance.high,
      autoCancel: false,
      playSound: false,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: 'plainCategory',
    );

    const DarwinNotificationDetails macOSNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: 'plainCategory',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: macOSNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails);
  }

  Future<void> showBigTextNotification(
      int id, String title, String body) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: false,
      contentTitle: title,
      htmlFormatContentTitle: false,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_02',
      'bigtext notes',
      channelDescription: 'channel for bigtext notes notifications',
      importance: Importance.high,
      autoCancel: false,
      playSound: false,
      styleInformation: bigTextStyleInformation,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails);
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
