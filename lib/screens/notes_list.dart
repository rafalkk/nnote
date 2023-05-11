import 'dart:async';

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

Future<List<Map<String, dynamic>>> readDatabase(
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

class NotesList extends StatefulWidget {
  NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
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

  // Unarchive
  void handleUnarchive(Note note) async {
    try {
      NotesDatabase db = NotesDatabase();
      await db.initDatabase();
      note.archived = false;
      await db.updateNote(note);
      await db.closeDatabase();
    } catch (e) {
      print('$e || Error unarchiveing note');
    } finally {
      setState(() {});
    }
  }

  // Notify
  void handleNotification(Note note) async {
    try {
      await notificationHelper.requestPermissions();
      await notificationHelper.showBigTextNotification(
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
    notificationHelper.initNotification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarText), actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () => setState(() {}),
        ),
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
        future: readDatabase(mode: vievMode),
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
                  List<ActionButton> actionButtonsList = [];
                  if (vievMode == ReadDatabaseMode.normal) {
                    actionButtonsList = [
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
                          handleArchive(Note.fromMap(snapshot.data![index]));
                        },
                      ),
                      ActionButton(
                        icon: Icons.delete_outline,
                        label: "Delete",
                        handleOnTap: () {
                          handleDelete(snapshot.data![index]["id"]);
                        },
                      )
                    ];
                  } else if (vievMode == ReadDatabaseMode.archievied) {
                    actionButtonsList = [
                      ActionButton(
                        icon: Icons.notification_add_outlined,
                        label: "Notify",
                        handleOnTap: () {
                          handleNotification(
                              Note.fromMap(snapshot.data![index]));
                        },
                      ),
                      ActionButton(
                        icon: Icons.unarchive_outlined,
                        label: "Unarchive",
                        handleOnTap: () {
                          handleUnarchive(Note.fromMap(snapshot.data![index]));
                        },
                      ),
                      ActionButton(
                        icon: Icons.delete_outline,
                        label: "Delete",
                        handleOnTap: () {
                          handleDelete(snapshot.data![index]["id"]);
                        },
                      )
                    ];
                  }
                  showModalBottomSheet(
                      barrierColor: Colors.transparent,
                      isDismissible: true,
                      enableDrag: true,
                      context: context,
                      builder: (context) => BottomActionBar(
                            actionButtonsList: actionButtonsList,
                          ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
