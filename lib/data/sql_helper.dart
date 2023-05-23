import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class SqlHelper {
  final String colId = 'id';
  final String colName = 'name';
  final String colDate = 'date';
  final String colNotes = 'notes';
  final String colPositon = 'position';
  final String tableNotes = 'notes';

  static Database? _db;
  static final SqlHelper _singleton = SqlHelper._internal();
  final int version = 1;
  factory SqlHelper() {
    return _singleton;
  }
  SqlHelper._internal();

  Future<Database> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'notes.db');
    Database dbNotes =
        await openDatabase(dbPath, version: version, onCreate: _createDb);
    return dbNotes;
  }

  Future _createDb(Database db, int verion) async {
    String query =
        'CREATE TABLE $tableNotes ($colId INTEGER PRIMARY KEY, $colName TEXT, $colDate TEXT, $colNotes TEXT, $colPositon INTEGER)';
    await db.execute(query);
  }

  Future<List<Note>> getNote() async {
    _db ??= await init();
    List<Map<String, dynamic>>? notesList =
        await _db?.query(tableNotes, orderBy: colPositon);
    List<Note> notes = [];
    notesList?.forEach((element) {
      notes.add(Note.fromMap(element));
    });
    return notes;
  }

  Future<int> insertNote(Note note) async {
    int result = await _db!.insert(tableNotes, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    int result = await _db!.update(tableNotes, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Note note) async {
    int result = await _db!
        .delete(tableNotes, where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }
}


/**
 * version: a version number for your database. required when using onCreate, onUpgrare, onDowngrade
 * onConfigure: is the first callback invoked when opeining the database. Can use it to perform initialztion tasks, 
 * like setting values that depend on the opening of the database or to write logs.
 * onCreate, onUpgrade, onDowngrade: They are mutually exclusive, mean that 
 * only one of them can be called depending on the version number
 * onCreate is called if the database dose not exist.
 * onUpgrade is called when the version number is higher than existing database version
 * or when the database does not exist and you have not set the onCreate callback.
 * onDowngrade is called when you have not set the onCreate callback.
 * onDowngrade is called when the version is lower than the existing on, and this actually
 * rather unlikely scenario
 * onOpen is invoked just before returning database. You can also specify the the readOnly parameter to open the database
 * to open the database in read-only mode and singleInstance the allows returning a single instance of the database
 * at the path that is set, and this is true by default.
 * 
 */
/**
 * Data in SQLite
 * NULL
 * INTEGER
 * REAL
 * TEXT
 * BLOB
 * SQLite uses Dynamic Typing
 */