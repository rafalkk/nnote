import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// int id = 0;

class NotificationHelper {
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

    await flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onDidReceiveNotificationResponse: notificationTap,
    );
  }

  @pragma('vm:entry-point')
  static notificationTap(NotificationResponse notificationResponse) async {
    if (notificationResponse.notificationResponseType ==
        NotificationResponseType.selectedNotificationAction) {
      print(notificationResponse.actionId);
      switch (notificationResponse.actionId) {
        case "id_1":
          // Handle action 1
          break;
        case "id_2":
          // Handle action 2
          break;
        case "id_3":
          // Handle action 3
          break;
        default:
          // Handle unknown action
          break;
      }
    }
  }

  // Future<void> showNotification() async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     '1',
  //     'test chanel',
  //     channelDescription: 'test chanel desc',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);
  //   await flutterLocalNotificationsPlugin.show(
  //       id++, 'plain title', 'plain body', notificationDetails,
  //       payload: 'body_payload');
  // }

  Future<void> showOngoingNotificationWithActions(
      int id, String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          "id_1",
          'Action 1',
          cancelNotification: false,
        ),
        AndroidNotificationAction(
          "id_2",
          'Action 2',
        ),
        AndroidNotificationAction(
          "id_3",
          'Action 3',
        )
      ],
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
    await flutterLocalNotificationsPlugin
        .show(id, title, body, notificationDetails, payload: 'item x');
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
