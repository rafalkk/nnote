import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/notes_database.dart';

enum NotesEditMode {
  create,
  update,
}

class NotesEdit extends StatefulWidget {
  final NotesEditMode _mode;
  Note? noteToEdit;

  NotesEdit() : _mode = NotesEditMode.create;

  NotesEdit.edit({required this.noteToEdit}) : _mode = NotesEditMode.update;

  _NotesEdit createState() => _NotesEdit();
}

class _NotesEdit extends State<NotesEdit> {
  String noteTitle = "";
  String noteContent = "";

  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _contentTextController = TextEditingController();

  void handleTitleTextChange() {
    setState(() {
      noteTitle = _titleTextController.text.trim();
    });
  }

  void handleNoteTextChange() {
    setState(() {
      noteContent = _contentTextController.text.trim();
    });
  }

  Future<void> handleSaveButton() async {
    switch (widget._mode) {
      case NotesEditMode.create:
        Note newNote = Note(
          title: noteTitle,
          content: noteContent,
          date: DateTime.now(),
        );

        try {
          NotesDatabase db = NotesDatabase();
          await db.initDatabase();
          await db.insertNote(newNote);
          await db.closeDatabase();
        } catch (e) {
          print('$e || Error inserting new note');
        } finally {
          Navigator.pop(context);
        }
        break;

      case NotesEditMode.update:
        Note editNote = widget.noteToEdit!;
        editNote.title = noteTitle;
        editNote.content = noteContent;

        try {
          NotesDatabase db = NotesDatabase();
          await db.initDatabase();
          await db.updateNote(editNote);
          await db.closeDatabase();
        } catch (e) {
          print('$e || Error inserting edited note');
        } finally {
          Navigator.pop(context);
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _titleTextController.addListener(handleTitleTextChange);
    _contentTextController.addListener(handleNoteTextChange);
    switch (widget._mode) {
      case NotesEditMode.create:
        break;
      case NotesEditMode.update:
        _titleTextController.text = widget.noteToEdit!.title;
        _contentTextController.text = widget.noteToEdit!.content;
        break;
    }
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add note")),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                    labelText: 'Title',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder()),
                controller: _titleTextController),
            SizedBox(height: 20.0),
            TextField(
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                    labelText: 'Note content',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 7,
                controller: _contentTextController),
            ElevatedButton(onPressed: handleSaveButton, child: Text("Save"))
          ],
        ),
      ),
    );
  }
}
