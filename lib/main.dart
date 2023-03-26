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
