import 'package:flutter/material.dart';

import '../models/note.dart';

// class NoteTile extends StatelessWidget {
//   final int id;
//   final String noteTitle;
//   final String noteContent;
//   final bool archieved;
//   //final Note note;
//   final VoidCallback onTap;

//   // final Function longPressCallback;

//   NoteTile(
//       {required this.id,
//       required this.noteTitle,
//       required this.noteContent,
//       required this.archieved,
//       //{required this.note,
//       required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Icon(
//         Icons.circle,
//         color: Colors.blue,
//         size: 18.0,
//       ),
//       title: Text(
//         noteTitle,
//       ),
//       subtitle: Text(archieved.toString()),
//       onLongPress: onTap,
//       onTap: () async {
//         await createBasicNotification();
//       },
//     );
//   }
// }

class NoteTile extends StatelessWidget {
  final Note noteObject;
  final VoidCallback onTap;
  final VoidCallback handleOnLongPress;

  NoteTile(
      {required this.noteObject,
      required this.onTap,
      required this.handleOnLongPress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.circle,
        color: Colors.blue,
        size: 18.0,
      ),
      title: Text(
        noteObject.title,
      ),
      subtitle: Text(noteObject.archived.toString()),
      onLongPress: handleOnLongPress,
      onTap: onTap,
    );
  }
}
