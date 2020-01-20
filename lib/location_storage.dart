import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'user_location_model.dart';

class LocationStorage {
  static final _databaseName = "LOCATION.db";
  static final _tableName = "User_Location";

  static Database _database;

  LocationStorage._privateConstructor();
  static final LocationStorage _storage = LocationStorage._privateConstructor();

  Future<Database> get _db async {
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
        version: UserLocation.userLocationVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
        onDowngrade: _onDowngrade);
  }

  Future _onConfigure(Database db) async {
    debugPrint('onConfigure $db');
  }

  Future _onDowngrade(Database db, int oldVersion, int newVersion) async {
    debugPrint("onDowngrade $db");
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint("UPGRADE: $db, oldVersion: $oldVersion, newVersion: $newVersion");
  }

  Future _onCreate(Database db, int version) async {
    var count = 0;
    var createQuery = "CREATE TABLE $_tableName (\n_id INTEGER PRIMARY KEY AUTOINCREMENT,\n";
    UserLocation.keysAndTypes().forEach((k,v) {
      createQuery += "$k $v";
      count++;
      if(count < UserLocation.keysAndTypes().length) {
        createQuery += ",";
      } 
      createQuery += "\n";
    });
    createQuery += ")\n";

    debugPrint('Create query: $createQuery');
    
    await db.execute(createQuery);
  }

  static Future<int> storeLocation(UserLocation ul) async {
    Database db = await _storage._db;
    return await db.insert(_tableName, ul.toMap());
  }

  static Future<List<Map> > getResults(int minutes) async {
    var cutoff = DateTime.now().millisecondsSinceEpoch - (minutes * 60 * 1000);
    Database db = await _storage._db;
    List<Map> queryResult = await db.rawQuery('SELECT * FROM $_tableName WHERE timestamp > $cutoff');
    return queryResult;
    //db.rawQuery('DELETE FROM $_tableName');
    
  }
}

