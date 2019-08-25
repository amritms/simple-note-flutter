import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_note/mynote.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:io' as io;
import 'dart:async';


class DBHelper{
  static final DBHelper _instance = new DBHelper.internal();
  DBHelper.internal();
  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null) return _db;
    _db = await setDB();
    return _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "SimpleNoteDB");

    var mainDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return mainDB;
  }


  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE mynote(id INTEGER PRIMARY KEY, title TEXT, note TEXT, createdAt TEXT, updatedAt TEXT, sortDate Text)");
    print("DB Created");
  }

  /*Save data in sqlite*/
  Future<int> saveNote(Mynote mynote) async {
    var dbClient = await db;
    int res = await dbClient.insert("mynote", mynote.toMap());
    print("Data Inserted");
    return res;
  }

  /*Get all data from sqlite*/
  Future<List<Mynote>> getNote() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM mynote ORDER BY sortDate DESC");
    List<Mynote> notedata = new List();
    for(int i=0; i<list.length; i++){
      var note = new Mynote(list[i]['title'], list[i]['note'], list[i]['createdAt'], list[i]['updatedAt'], list[i]['sortDate']);
      note.setNodeId(list[i]['id']);
      notedata.add(note);
    }

    return notedata;
  }

  Future<bool> updateNote(Mynote mynote) async{
    var dbClient = await db;
    int res = await dbClient.update("mynote", mynote.toMap(), where: "id=?", whereArgs: <int>[mynote.id]);

    return res > 0 ? true : false;
  }

  Future<int> deleteNote(Mynote mynote) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete("DELETE FROM mynote where id = ?", [mynote.id]);
    return res;
  }
}