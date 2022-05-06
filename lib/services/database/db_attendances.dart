// ignore_for_file: unused_import, unnecessary_null_comparison

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class AttendancesDBProvider {
  AttendancesDBProvider._();

  static final attendanceDB = AttendancesDBProvider._();
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

  String _createStudentAttendanceTable() {
    return "CREATE TABLE StudentAttendance("
        "attendanceId INTEGER,"
        "attendanceDate TEXT NOT NULL,"
        "courseId TEXT NOT NULL,"
        'collegeId INTEGER NOT NULL,'
        'teacherId INTEGER NOT NULL,'
        'numLectureHours TEXT,'
        'submissionDate TEXT NOT NULL,'
        "subjectId INTEGER NOT NULL,"
        'yearId INTEGER NOT NULL,'
        'semId INTEGER NOT NULL,'
        'classId INTEGER,'
        'deptId INTEGER,'
        "absentStudentList TEXT,"
        "UNIQUE(attendanceDate, courseId, collegeId, teacherId, yearId, semId)"
        ");";
  }

  String _createFacultyAttendanceTable() {
    return "CREATE TABLE FacultyAttendance("
        "attendanceId INTEGER,"
        "attendanceDate TEXT NOT NULL,"
        "deptId INTEGER NOT NULL,"
        "collegeId INTEGER NOT NULL,"
        "absentFacultyList TEXT,"
        "UNIQUE(attendanceDate, deptId, collegeId)"
        ");";
  }

  String _createNtStaffAttendanceTable() {
    return "CREATE TABLE NtStaffAttendance("
        "attendanceId INTEGER,"
        "attendanceDate TEXT NOT NULL,"
        "deptId TEXT NOT NULL,"
        "collegeId INTEGER NOT NULL,"
        "absentStaffList TEXT,"
        "UNIQUE(attendanceDate, deptId, collegeId)"
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

        dbBatch.execute(_createStudentAttendanceTable());
        dbBatch.execute(_createFacultyAttendanceTable());
        dbBatch.execute(_createNtStaffAttendanceTable());
        await dbBatch.commit(noResult: true);
      });
    } catch (e) {
      if (kDebugMode) {
        log('attendance initDB error');
        log(e.toString());
      }
    }
  }

  Future<dynamic> attendanceDynamicRead(String dbQuery, params) async {
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

  Future<dynamic> attendanceDynamicInsert(
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
