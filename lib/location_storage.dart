import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static final _databaseName = "LOCATION.db";
  static final _databaseVersion = 1;

  final String table    = 'Location';
  final String columnId         = '_id';
  final String columnTimestamp  = 'timestamp';
  final String columnLatitude   = 'latitude';
  final String columnLongitude  = 'longitude';

  static Database _database;

  DBHelper._privateConstructor();
  static final DBHelper storage = DBHelper._privateConstructor();

  Future<Database> get database async {
    if(_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY,
          $columnTimestamp INTEGER NOT NULL,
          $columnLatitude TEXT NOT NULL,
          $columnLongitude TEXT NOT NULL
        )
        ''');
  }

  Future<int> storeLocation(String lat, String long) async {
    Map<String, dynamic> row = {
      columnTimestamp: DateTime.now().millisecondsSinceEpoch,
      columnLatitude: lat,
      columnLongitude: long
    };

    Database db = await storage.database;
    return await db.insert(table, row);
  }
}

