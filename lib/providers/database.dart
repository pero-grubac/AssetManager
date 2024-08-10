import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/models/worker.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart' as sql_api;
import 'package:path/path.dart' as path;

import '../models/asset.dart';

Future<sql_api.Database> getLocationDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, AssetLocation.dbFullName),
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE locations(
           id TEXT PRIMARY KEY, 
           latitude REAL,
           longitude REAL,
           address TEXT)
         ''');
    },
    version: 1,
  );
  return db;
}

Future<sql_api.Database> getWorkerDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, Asset.dbFullName),
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE assets(
           id TEXT PRIMARY KEY, 
           name TEXT,
           description TEXT,
           barcode INTEGER, 
           price REAL,
           creationDate TEXT, 
           assignedPersonId TEXT,
           assignedLocationId TEXT, 
           imagePath TEXT)
         ''');
    },
    version: 1,
  );
  return db;
}

Future<sql_api.Database> getWorkersDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, Worker.dbFullName),
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE workers(
           id TEXT PRIMARY KEY, 
           firstName TEXT,
           lastName TEXT,
           phoneNumber TEXT, 
           email TEXT)
         ''');
    },
    version: 1,
  );
  return db;
}
