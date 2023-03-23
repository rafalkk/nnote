import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createBasicNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: -1,
      channelKey: "basic_channel_1",
      title: "test notify titkle",
      body: "test notify body",
    ),
  );
}
