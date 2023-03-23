import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'screens/notes_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Create a Dog and add it to the dogs table
  // var firstnote = Note(
  //   id: 2,
  //   title: "notatka3",
  //   content: "zawartośc 3 notatki",
  //   date: DateTime.now(),
  // );

  // var db = NotesDatabase();
  // await db.initDatabase();

  // await db.insertNote(firstnote);

  // //print(await db.getAllNotes());
  // print(await getDatabasesPath());
  // print(await db.getNotes(1));
  AwesomeNotifications().initialize("resource://drawable/res_notify_icon", [
    NotificationChannel(
      channelKey: "basic_channel_1",
      channelName: "basic Notification_1",
      channelDescription: "channelDescription",
      importance: NotificationImportance.Low,
      locked: true,
    )
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotesList(),
    );
  }
}
