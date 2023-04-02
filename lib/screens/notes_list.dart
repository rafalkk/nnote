import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/notes_database.dart';
import '../models/notification.dart';
import '../widgets/action_button.dart';
import '../widgets/bottom_action_bar.dart';
import '../widgets/note_title.dart';
import 'notes_edit.dart';

var notificationHelper = NotificationHelper();

enum ReadDatabaseMode {
  normal,
  archievied,
}

ReadDatabaseMode vievMode = ReadDatabaseMode.normal;
String appBarText = "Notes List";
bool fabVisibilityFlag = true;

Future<List<Map<String, dynamic>>> readDatabase1(
    {required ReadDatabaseMode mode}) async {
  try {
    NotesDatabase db = NotesDatabase();
    await db.initDatabase();
    List<Map> notesList;

    switch (mode) {
      case ReadDatabaseMode.normal:
        notesList = await db.getAllNotesNormal();
        break;
      case ReadDatabaseMode.archievied:
        notesList = await db.getAllNotesArchived();
        break;
    }

    await db.closeDatabase();
    List<Map<String, dynamic>> notesListSorted =
        List<Map<String, dynamic>>.from(notesList);
    notesListSorted.sort((a, b) => (a['date']).compareTo(b['date']));

    return notesListSorted;
  } catch (e) {
    print('$e || Error reading database');
    return [{}];
  }
}

// Future<List<Map<String, dynamic>>> readDatabase() async {
//   try {
//     NotesDatabase db = NotesDatabase();
//     await db.initDatabase();
//     List<Map> notesList = await db.getAllNotesArchived();
//     print("ODCZYTYWANIE BAZY");
//     print(notesList);
//     await db.closeDatabase();
//     List<Map<String, dynamic>> notesListSorted =
//         List<Map<String, dynamic>>.from(notesList);
//     notesListSorted.sort((a, b) => (a['date']).compareTo(b['date']));

//     return notesListSorted;
//   } catch (e) {
//     print('$e || Error reading database');
//     return [{}];
//   }
// }

class NotesList extends StatefulWidget {
  NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  // Render the screen and update changes
  // TODO: void afterNavigatorPop() {
  //   setState(() {});
  // }

  // Delete Note
  void handleDelete(int id) async {
    try {
      NotesDatabase db = NotesDatabase();
      await db.initDatabase();
      await db.deleteNote(id);
      await db.closeDatabase();
    } catch (e) {
      print('$e || Error deleting note');
    } finally {
      setState(() {});
    }
  }

  // Archive
  void handleArchive(Note note) async {
    try {
      NotesDatabase db = NotesDatabase();
      await db.initDatabase();
      note.archived = true;
      await db.updateNote(note);
      await db.closeDatabase();
    } catch (e) {
      print('$e || Error archiveing note');
    } finally {
      setState(() {});
    }
  }

  // Notify
  void handleNotification(Note note) async {
    try {
      await notificationHelper.showOngoingNotificationWithActions(
          note.id!, note.title, note.content);
    } catch (e) {
      print('$e || Error notifying note');
    } finally {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    notificationHelper.initNotification;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarText), actions: [
        PopupMenuButton(
            itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text("normal"),
                    onTap: () {
                      setState(() {
                        vievMode = ReadDatabaseMode.normal;
                        appBarText = "Notes List";
                        fabVisibilityFlag = true;
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("archieved"),
                    onTap: () {
                      setState(() {
                        vievMode = ReadDatabaseMode.archievied;
                        appBarText = "Archieved";
                        fabVisibilityFlag = false;
                      });
                    },
                  )
                ])
      ]),
      floatingActionButton: Visibility(
        visible: fabVisibilityFlag,
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotesEdit()),
            );
            setState(() {});
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: FutureBuilder(
        future: readDatabase1(mode: vievMode),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return NoteTile(
                noteObject: Note.fromMap(snapshot.data![index]),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotesEdit.edit(
                              noteToEdit: Note.fromMap(snapshot.data![index]),
                            )),
                  );
                  setState(() {});
                },
                handleOnLongPress: () {
                  showModalBottomSheet(
                      barrierColor: Colors.transparent,
                      isDismissible: true,
                      enableDrag: true,
                      context: context,
                      builder: (context) => BottomActionBar(
                            actionButtonsList: [
                              ActionButton(
                                icon: Icons.notification_add_outlined,
                                label: "Notify",
                                handleOnTap: () {
                                  handleNotification(
                                      Note.fromMap(snapshot.data![index]));
                                },
                              ),
                              ActionButton(
                                icon: Icons.archive_outlined,
                                label: "Archive",
                                handleOnTap: () {
                                  handleArchive(
                                      Note.fromMap(snapshot.data![index]));
                                },
                              ),
                              ActionButton(
                                icon: Icons.delete_outline,
                                label: "Delete",
                                handleOnTap: () {
                                  handleDelete(snapshot.data![index]["id"]);
                                },
                              )
                            ],
                          ));
                },
              );
              // NoteTile(
              //   id: snapshot.data![index]["id"],
              //   noteTitle: snapshot.data![index]["title"],
              //   noteContent: snapshot.data![index]["content"],
              //   archieved: true,
              //   handleDelete: () {
              //     handleDelete(snapshot.data![index]["id"]);
              //   },
              //);
            },
          );
        },
      ),
    );
  }
}
