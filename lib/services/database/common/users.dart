// ignore_for_file: unused_import, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

final DateFormat format = DateFormat('yyyy-MM-dd');

class UserDBProvider {
  UserDBProvider._();

  static final UserDBProvider db = UserDBProvider._();

  static const int version = 1;
  static late Database _database;
  static const dbname = 'higher.db';

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  /// user type will take integer value
  /// 1. Principal (HoI) (referenced as master throughout the app)
  /// 2. HoD (referenced as head throughout the app)
  /// 3. Teaching Staff member other than HoIs and HoDs (referenced as faculty throughout the app)
  /// 4. Non-Teaching Staff member (referenced as ntStaff throughout the app)
  /// 5. Parent (referenced as parent throughout the app)
  /// 6. Student (referenced as student throughout the app)

  String _createUserLoginSessionTable() {
    return "CREATE TABLE UserLoginSession("
        "userName TEXT NOT NULL,"
        "userPassword TEXT NOT NULL,"
        "userId TEXT NOT NULL,"
        "userType INTEGER NOT NULL,"
        "isOnline INTEGER DEFAULT 0"
        "loginStatus INTEGER DEFAULT 0,"
        "UNIQUE (userId)"
        ");";
  }

  Future initDB() async {
    try {
      String path = join(await getDatabasesPath(), dbname);

      return openDatabase(path, version: version, onOpen: (db) {},
          onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      }, onCreate: (Database db, int version) async {
        var dbBatch = db.batch();
        await db.execute('PRAGMA foreign_keys = ON');

        dbBatch.execute(_createUserLoginSessionTable());
      });
    } catch (e) {
      if (kDebugMode) {
        log('initDB error');
        log(e.toString());
      }
    }
  }

  Future<dynamic> isSomeUserLoggedIn() async {
    try {
      final db = await initDB();

      String query = "SELECT * FROM UserLoginSession WHERE loginStatus=1;";

      var resultQuerySet = await db.rawQuery(query);

      var resultList = resultQuerySet.toList();
      return resultList;
    } catch (e) {
      if (kDebugMode) {
        log("error checking user login session");
        log(e.toString());
      }
    }
  }

  Future<dynamic> dynamicRead(String query, parameters) async {
    try {
      final db = await initDB();

      if (parameters.isNotEmpty && parameters.length > 0) {
        var resultQuerySet = await db.rawQuery(query, parameters);

        var resultList = resultQuerySet.toList();
        return resultList;
      } else {
        var resultQuerySet = await db.rawQuery(query);

        var resultList = resultQuerySet.toList();
        return resultList;
      }
    } catch (e) {
      if (kDebugMode) {
        log("error checking user login session");
        log(e.toString());
      }
    }
  }

  Future<void> forceLogOutAllUsers() async {
    try {
      final db = await initDB();
      String query =
          "UPDATE UserLoginSession SET loginStatus = 1, isOnline = 1;";

      var result = await db.rawQuery(query);

      if (kDebugMode) {
        log("All user forced logout status");
        log(result.toString());
      }

      if (kDebugMode) {}
    } catch (e) {
      if (kDebugMode) {
        log("error checking user login session");
        log(e.toString());
      }
    }
  }
}
