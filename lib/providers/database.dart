import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/models/worker.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart' as sql_api;
import 'package:path/path.dart' as path;

import '../models/asset.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static sql_api.Database? _locationDatabase;
  static sql_api.Database? _assetDatabase;
  static sql_api.Database? _workerDatabase;
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<sql_api.Database> getLocationDatabase() async {
    if (_locationDatabase != null) return _locationDatabase!;

    final dbPath = await sql.getDatabasesPath();
    _locationDatabase = await sql.openDatabase(
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
    return _locationDatabase!;
  }

  Future<sql_api.Database> getAssetDatabase() async {
    if (_assetDatabase != null) return _assetDatabase!;

    final dbPath = await sql.getDatabasesPath();
    _assetDatabase = await sql.openDatabase(
      path.join(dbPath, Asset.dbFullName),
      onCreate: (db, version) async {
        return db.execute('''
        CREATE TABLE assets(
           id TEXT PRIMARY KEY, 
           name TEXT,
           description TEXT,
           barcode INTEGER UNIQUE, 
           price REAL,
           creationDate TEXT, 
           imagePath TEXT)
         ''');
      },
      version: 1,
    );
    return _assetDatabase!;
  }

  Future<sql_api.Database> getWorkerDatabase() async {
    if (_workerDatabase != null) return _workerDatabase!;

    final dbPath = await sql.getDatabasesPath();
    _workerDatabase = await sql.openDatabase(
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
    return _workerDatabase!;
  }

  Future<void> closeDatabases() async {
    closeLocationDatabase();
    closeAssetDatabase();
    closeWorkerDatabase();
  }

  Future<void> closeLocationDatabase() async {
    if (_locationDatabase != null) {
      await _locationDatabase!.close();
      _locationDatabase = null;
    }
  }

  Future<void> closeAssetDatabase() async {
    if (_assetDatabase != null) {
      await _assetDatabase!.close();
      _assetDatabase = null;
    }
  }

  Future<void> closeWorkerDatabase() async {
    if (_workerDatabase != null) {
      await _workerDatabase!.close();
      _workerDatabase = null;
    }
  }
}
