// ignore_for_file: unused_import, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class LeaveDBPProvider {
  LeaveDBPProvider._();

  static final LeaveDBPProvider leaveDB = LeaveDBPProvider._();
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

  String _createStudentLeaveTable() {
    return "CREATE TABLE StudentLeaveRequest("
        "leaveId INTEGER,"
        "leaveStudentId INTEGER NOT NULL,"
        "leaveStudentUserId INTEGER NOT NULL,"
        "leaveStudentCollegeId INTEGER NOT NULL,"
        "leaveFromDate TEXT NOT NULL,"
        "leaveToDate TEXT NOT NULL,"
        "leaveDays TEXT NOT NULL,"
        "leaveReason TEXT NOT NULL,"
        "leaveAttachement TEXT,"
        "leaveStatus TEXT DEFAULT 'draft',"
        "UNIQUE(leaveStudentId, leaveFromDate, leaveToDate)"
        ");";
  }

  String _createFacultyLeaveTable() {
    return "CREATE TABLE FacultytLeaveRequest("
        "leaveId INTEGER,"
        "leaveFacultyId INTEGER NOT NULL,"
        "leaveFacultyUserId INTEGER NOT NULL,"
        "leaveFacultyCollegeId INTEGER NOT NULL,"
        "leaveFromDate TEXT NOT NULL,"
        "leaveToDate TEXT NOT NULL,"
        "leaveDays TEXT NOT NULL,"
        "leaveReason TEXT NOT NULL,"
        "leaveAttachement TEXT,"
        "leaveStatus TEXT DEFAULT 'toapprove',"
        "UNIQUE(leaveFacultyId, leaveFromDate, leaveToDate)"
        ");";
  }

  String _createNtStaffLeaveTable() {
    return "CREATE TABLE NtStaffLeaveRequest("
        "leaveId INTEGER,"
        "leaveNtStaffId INTEGER NOT NULL,"
        "leaveNtStaffUserId INTEGER NOT NULL,"
        "leaveNtStaffCollegeId INTEGER NOT NULL,"
        "leaveFromDate TEXT NOT NULL,"
        "leaveToDate TEXT NOT NULL,"
        "leaveDays TEXT NOT NULL,"
        "leaveReason TEXT NOT NULL,"
        "leaveAttachement TEXT,"
        "leaveStatus TEXT DEFAULT 'toapprove',"
        "UNIQUE(leaveNtStaffId, leaveFromDate, leaveToDate)"
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

        dbBatch.execute(_createStudentLeaveTable());
        dbBatch.execute(_createFacultyLeaveTable());
        dbBatch.execute(_createNtStaffLeaveTable());
        await dbBatch.commit(noResult: true);
      });
    } catch (e) {
      if (kDebugMode) {
        log('leave initDB error');
        log(e.toString());
      }
    }
  }

  Future<dynamic> leaveDynamicRead(String dbQuery, params) async {
    try {
      final db = await initDB();

      if (params.isEmpty) {
        var result = await db.rawQuery(dbQuery);
        var resultList = result.toList();
        return resultList;
      } else {
        var result = await db.rawQuery(dbQuery, params);
        var resultList = result.toList();
        return resultList;
      }
    } catch (e) {
      if (kDebugMode) {
        log('initDB error');
        log(e.toString());
      }
    }
  }

  Future<dynamic> leaveDynamicInsert(
      String tableName, Map<String, Object> dbEntry) async {
    try {
      if (dbEntry.isNotEmpty) {
        final db = await initDB();
        var insertionResult = await db.insert(tableName, dbEntry,
            conflictAlgorithm: ConflictAlgorithm.replace);

        if (kDebugMode) {
          log('inserted $insertionResult in $tableName');
        }
        return insertionResult;
      }
    } catch (e) {
      if (kDebugMode) {
        log('initDB error');
        log(e.toString());
      }
    }
  }
}
