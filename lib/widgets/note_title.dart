import 'package:flutter/material.dart';

import '../models/note.dart';

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
      subtitle: Text(
          "created: ${noteObject.date.year.toString()}-${noteObject.date.month.toString()}-${noteObject.date.day.toString()}"),
      onLongPress: handleOnLongPress,
      onTap: onTap,
    );
  }
}
