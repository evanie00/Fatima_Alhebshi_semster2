import 'package:localstorageassignment/Note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'consttants.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDb();
    return _database;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), "MyNotes.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            '''CREATE TABLE $tableUser(
                $noteId INTEGER PRIMARY KEY AUTOINCREMENT,
                $noteTitle TEXT NOT NULL,
                $noteContent TEXT NOT NULL
             )'''
        );
      },
    );
  }

  Future<void> insertNote(Notes note) async {
    var dbn = await database;
    await dbn?.insert(
      tableUser,
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Notes>> getNotes() async {
    var dbn = await database;
    final List<Map<String, dynamic>> maps = await dbn!.query(tableUser);

    return List.generate(maps.length, (i) {
      return Notes.fromJson(maps[i]);
    });
  }

  Future<void> deleteNote(Notes note) async {
    var dbn = await database;
    int? id = note.id;
    await dbn?.delete(
      tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateNote(Notes note) async {
    var dbn = await database;
    int? id = note.id;
    await dbn?.update(
      tableUser,
      note.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}