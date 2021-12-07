// ignore_for_file: unused_import, unused_element, unused_field, unused_local_variable, unnecessary_null_comparison, unnecessary_this, deprecated_member_use, prefer_collection_literals
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    // ignore: prefer_conditional_assignment
    //_databaseHelper = DatabaseHelper._createInstance();
    // ignore: prefer_conditional_assignment
    if (_databaseHelper == null) {
			_databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
		}
    return DatabaseHelper._createInstance();
  }

  Future<Database?> get database async {
    // ignore: prefer_conditional_assignment
    if (_database == null) {
    _database ??= await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newversion) async {
		await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
				'$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  //fetch operation : get all note objects from database

  Future<List<Map<String, dynamic>>?> getNoteMapList() async {
    Database? db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db?.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  //insert operation: Insert a note object to database

  Future<int?> insertNote(Note note) async {
    Database? db = await this.database;
    var result = await db?.insert(noteTable, note.toMap());
    return result;
  }

  //update operation: update a note object and save it to database
  Future<int?> updateNote(Note note) async {
    Database? db = await this.database;
    var result = await db?.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //Delete operation: Delete a note object from database

  Future<int?> deleteNote(int id) async {
    var db = await this.database;
    int? result = await db?.rawDelete(
        'DELETE FROM $noteTable WHERE $colId = $id'); //<---the id is fake
    return result;
  }

  //get number of notes objects in database
  Future<int?> getCount() async {
    Database? db = await this.database;
    List<Map<String, Object?>>? x =
        await db?.rawQuery('SELECT COUNT (*) from $noteTable');
    int? result = Sqflite.firstIntValue(x ?? );
    return result;
  }

  //get maplist and convet it to note list
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList!.length;

    List<Note> noteList = <Note>[];

    for (int i = 0; i < count; ++i) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
