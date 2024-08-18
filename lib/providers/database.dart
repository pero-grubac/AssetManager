import 'package:asset_manager/models/asset_location.dart';
import 'package:asset_manager/models/census_item.dart';
import 'package:asset_manager/models/census_list.dart';
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
  static sql_api.Database? _censusListDatabase;
  static sql_api.Database? _censusItemDatabase;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();
  Future<sql_api.Database> getCensusListDatabase() async {
    if (_censusListDatabase != null) return _censusListDatabase!;

    final dbPath = await sql.getDatabasesPath();
    _censusListDatabase = await sql.openDatabase(
      path.join(dbPath, CensusList.dbFullName),
      onCreate: (db, version) {
        return db.execute('''
      CREATE TABLE ${CensusList.dbName}(
        id TEXT PRIMARY KEY,
        name TEXT,
        creationDate TEXT
       )
      ''');
      },
      version: 1,
    );
    return _censusListDatabase!;
  }

  Future<sql_api.Database> getCensusItemDatabase() async {
    if (_censusItemDatabase != null) return _censusItemDatabase!;

    final dbPath = await sql.getDatabasesPath();
    _censusItemDatabase = await sql.openDatabase(
      path.join(dbPath, CensusItem.dbFullName),
      onCreate: (db, version) {
        return db.execute('''
      CREATE TABLE ${CensusItem.dbName}(
        id TEXT PRIMARY KEY,
        censusListId TEXT,
        assetId TEXT,
        currentPersonId TEXT,
        newPersonId TEXT,
        currentLocationId TEXT,
        newLocationId TEXT
       )
      ''');
      },
      version: 1,
    );
    return _censusItemDatabase!;
  }

  Future<sql_api.Database> getLocationDatabase() async {
    if (_locationDatabase != null) return _locationDatabase!;

    final dbPath = await sql.getDatabasesPath();
    _locationDatabase = await sql.openDatabase(
      path.join(dbPath, AssetLocation.dbFullName),
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE ${AssetLocation.dbName}(
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
        CREATE TABLE ${Asset.dbName}(
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
        CREATE TABLE ${Worker.dbName}(
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
    await closeLocationDatabase();
    await closeAssetDatabase();
    await closeWorkerDatabase();
    await closeCensusListDatabase();
    await closeCensusItemDatabase();
  }

  Future<void> closeLocationDatabase() async {
    if (_locationDatabase != null) {
      await _locationDatabase!.close();
      _locationDatabase = null;
    }
  }

  Future<void> closeCensusListDatabase() async {
    if (_censusListDatabase != null) {
      await _censusListDatabase!.close();
      _censusListDatabase = null;
    }
  }

  Future<void> closeCensusItemDatabase() async {
    if (_censusItemDatabase != null) {
      await _censusItemDatabase!.close();
      _censusItemDatabase = null;
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
