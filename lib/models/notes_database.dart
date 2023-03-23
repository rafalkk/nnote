import 'package:sqflite/sqflite.dart';

import 'note.dart';

class NotesDatabase {
  static const _name = "NotesDatabase.db";
  static const _version = 1;

  late Database database;
  static const tableName = 'notes';

  initDatabase() async {
    database = await openDatabase(_name, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $tableName (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    title TEXT,
                    content TEXT,
                    date TEXT,
                    archived INTEGER,
                    notifyarea INTEGER
                    )''');
    });
  }

  Future<void> insertNote(Note note) async {
    await database.insert(tableName, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateNote(Note note) async {
    await database.update(tableName, note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getNotes(int id) async {
    var result =
        await database.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    return await database.query(tableName);
  }

  Future<List<Map<String, dynamic>>> getAllNotesNormal() async {
    return await database.query(tableName, where: 'archived = 0');
  }

  Future<List<Map<String, dynamic>>> getAllNotesArchived() async {
    return await database.query(tableName, where: 'archived = 1');
  }

  Future<int> deleteNote(int id) async {
    return await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  closeDatabase() async {
    await database.close();
  }
}
