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
  static sql_api.Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<sql_api.Database> getDatabase() async {
    if (_database != null) return _database!;

    final dbPath = await sql.getDatabasesPath();
    _database = await sql.openDatabase(
      path.join(dbPath, 'asset_manager.db'), // Jedan database file
      onCreate: (db, version) {
        return db.transaction((txn) async {
          await txn.execute('''
          CREATE TABLE ${CensusList.dbName}(
            id TEXT PRIMARY KEY,
            name TEXT,
            creationDate TEXT
          )
          ''');

          await txn.execute('''
          CREATE TABLE ${CensusItem.dbName}(
            id TEXT PRIMARY KEY,
            censusListId TEXT,
            assetId TEXT,
            oldPersonId TEXT,
            newPersonId TEXT,
            oldLocationId TEXT,
            newLocationId TEXT,
            createdAt TEXT,
            UNIQUE(censusListId, assetId)
          )
          ''');

          await txn.execute('''
          CREATE TABLE ${AssetLocation.dbName}(
            id TEXT PRIMARY KEY,
            latitude REAL,
            longitude REAL,
            address TEXT,
            createdAt TEXT
          )
          ''');

          await txn.execute('''
          CREATE TABLE ${Asset.dbName}(
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            barcode INTEGER UNIQUE,
            price REAL,
            creationDate TEXT,
            imagePath TEXT
          )
          ''');

          await txn.execute('''
          CREATE TABLE ${Worker.dbName}(
            id TEXT PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            phoneNumber TEXT,
            email TEXT,
            createdAt TEXT
          )
          ''');
        });
      },
      version: 1,
    );
    return _database!;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
