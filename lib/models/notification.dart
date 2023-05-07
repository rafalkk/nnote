import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'notes_database.dart';

// int id = 0;

/// A notification action which triggers a App navigation event
//const String navigationActionId = 'id_3';

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
  // final StreamController<ReceivedNotification>
  //     didReceiveLocalNotificationStream =
  //     StreamController<ReceivedNotification>.broadcast();
  static final onNotifications = BehaviorSubject<String?>();

  // final StreamController<String?> selectNotificationStream =
  //     StreamController<String?>.broadcast();

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
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotificationAction:
            onNotifications.add(notificationResponse.actionId);
            print("1_1");
            break;
          case NotificationResponseType.selectedNotification:
            //onNotifications.add(notificationResponse.actionId);
            print("2_2");
            break;
        }
      },
      //onDidReceiveBackgroundNotificationResponse: notificationTap,
    );
  }

  @pragma('vm:entry-point')
  static void notificationTap(
    NotificationResponse notificationResponse,
  ) async {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        {
          //onNotifications.add(notificationResponse.payload);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => NotesEdit()),
          // );
        }
        break;

      case NotificationResponseType.selectedNotificationAction:
        {
          switch (notificationResponse.actionId) {
            case "id_1":
              {
                onNotifications.add(notificationResponse.actionId);
                //print(notificationResponse.actionId);
              }
              break;
            case "id_2":
              {
                try {
                  NotesDatabase db = NotesDatabase();
                  await db.initDatabase();
                  await db.archiveNoteRAW(notificationResponse.id!);
                  await db.closeDatabase();
                } catch (e) {
                  print('$e || Error archieving note from notification');
                }
              }
              break;
            case "id_3":
              {
                try {
                  NotesDatabase db = NotesDatabase();
                  await db.initDatabase();
                  await db.deleteNote(notificationResponse.id!);
                  await db.closeDatabase();
                } catch (e) {
                  print('$e || Error deleting note from notification');
                }
              }
              break;
          }
        }
        break;
    }
  }

  // @pragma('vm:entry-point')
  // void notificationTap(NotificationResponse notificationResponse) {
  //   // ignore: avoid_print
  //   print('notification(${notificationResponse.id}) action tapped: '
  //       '${notificationResponse.actionId} with'
  //       ' payload: ${notificationResponse.payload}');
  //   if (notificationResponse.input?.isNotEmpty ?? false) {
  //     // ignore: avoid_print
  //     print(
  //         'notification action tapped with input: ${notificationResponse.input}');
  //   }
  // }

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
          'Delete',
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
