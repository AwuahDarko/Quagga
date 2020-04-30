import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String colID = 'id';
  String colToken = 'token';
  String table = 'token_table';


  DatabaseHelper.createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper.createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'token.db';

    var database = await openDatabase(path, version: 1, onCreate: _createDB);
    return database;
  }

  void _createDB(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $table ('
        '$colID INTEGER PRIMARY KEY AUTOINCREMENT, $colToken TEXT UNIQUE NOT NULL )');
  }

  Future<List<Map<String, dynamic>>> getToken() async{
    Database  db = await this.database;
    var result = await db.rawQuery("SELECT * FROM $table WHERE $colID = 1");
    return result;
  }

  Future<void> insertToken(String token) async{
    Database  db = await this.database;
    await db.rawQuery("INSERT INTO $table ($colToken) VALUES('$token')");
  }

  Future<void> deleteToken() async{
    Database  db = await this.database;
    await db.rawQuery('DELETE FROM $table where $colID = 1');
  }

  Future<void> dropTable() async{
    Database  db = await this.database;
    await db.rawQuery('DROP TABLE $table');
  }

}