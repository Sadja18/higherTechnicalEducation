import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static const int version = 1;
  static late Database _database;
  static const dbname = 'higherAttendance.db';

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

  String _createCollegeTable() {
    return "CREATE TABLE College("
        "collegeId INTEGER PRIMARY KEY,"
        "collegeName TEXT"
        ");";
  }

  String _createCourseTable() {
    return "CREATE TABLE Course("
        "courseId INTEGER PRIMARY KEY,"
        "courseName TEXT NOT NULL,"
        "noDept TEXT NOT NULL"
        ");";
  }

  String _createYearTable() {
    return "CREATE TABLE Year("
        "yearId INTEGER PRIMARY KEY,"
        "yearName TEXT NOT NULL"
        ");";
  }

  String _createSemesterTable() {
    return "CREATE TABLE Semester("
        "semId INTEGER NOT NULL,"
        "semName TEXT NOT NULL,"
        "yearId INTEGER NOT NULL"
        ");";
  }

  String _createDeptTable() {
    return "CREATE TABLE Dept("
        "deptId INTEGER PRIMARY KEY,"
        "deptName TEXT NOT NULL,"
        "collegeId INTEGER NOT NULL"
        ");";
  }

  String _createClassesTable() {
    return "CREATE TABLE Classes("
        "classId INTEGER NOT NULL,"
        "className TEXT NOT NULL,"
        "courseId INTEGER NOT NULL,"
        "UNIQUE(classId, courseId)"
        ");";
  }

  String _createStudentProfile() {
    return "CREATE TABLE Student("
        "studentId INTEGER NOT NULL,"
        "studentCode TEXT NOT NULL,"
        "studentName TEXT,"
        "userId INTEGER NOT NULL,"
        "collegeId INTEGER NOT NULL,"
        "courseId INTEGER NOT NULL,"
        "yearId INTEGER NOT NULL,"
        "semId INTEGER NOT NULL,"
        "classId INTEGER,"
        "deptId TEXT,"
        "UNIQUE(studentId, collegeId)"
        ");";
  }

  String _createParentProfile() {
    return "CREATE TABLE Parent("
        "userId INTEGER NOT NULL,"
        "parentName INTEGER,"
        "childrenStudentIdList TEXT NOT NULL,"
        "UNIQUE(userId)"
        ");";
  }

  String _createFacultyProfile() {
    return "CREATE TABLE Faculty("
        "teacherId INTEGER NOT NULL,"
        "userId INTEGER NOT NULL,"
        "teacherName TEXT,"
        "employeeId TEXT,"
        "teacherCode TEXT,"
        "isHoD TEXT DEFAULT 'no',"
        "deptId INTEGER NOT NULL,"
        "deptName INTEGER NOT NULL,"
        "deptHeadId INTEGER NOT NULL,"
        "deptHeadName INTEGER NOT NULL,"
        "collegeId INTEGER NOT NULL,"
        "UNIQUE(teacherId, collegeId)"
        ");";
  }

  String _createNtStaffProfile() {
    return "CREATE TABLE NtStaff("
        "staffId INTEGER NOT NULL,"
        "userId INTEGER NOT NULL,"
        "staffName TEXT,"
        "employeeId TEXT,"
        "staffCode TEXT,"
        "deptId INTEGER NOT NULL,"
        "deptName INTEGER NOT NULL,"
        "deptHeadId INTEGER NOT NULL,"
        "deptHeadName INTEGER NOT NULL,"
        "collegeId INTEGER NOT NULL,"
        "UNIQUE(staffId, collegeId)"
        ");";
  }

  String _createHeadProfile() {
    return "CREATE TABLE Head("
        "teacherId INTEGER NOT NULL,"
        "userId INTEGER NOT NULL,"
        "teacherName TEXT,"
        "employeeId TEXT,"
        "teacherCode TEXT,"
        "deptId INTEGER NOT NULL,"
        "deptName INTEGER NOT NULL,"
        "collegeId INTEGER NOT NULL,"
        "UNIQUE(teacherId, collegeId)"
        ");";
  }

  String _createMasterProfile() {
    return "CREATE TABLE Master("
        "userId INTEGER NOT NULL,"
        "headName TEXT,"
        "collegeId INTEGER NOT NULL,"
        "collegeCode INTEGER NOT NULL,"
        'collegeName TEXT NOT NULL,'
        "UNIQUE(userId)"
        ");";
  }

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

  String _createUserLoginSessionTable() {
    return "CREATE TABLE UserLoginSession("
        "userName TEXT NOT NULL,"
        "userPassword TEXT NOT NULL,"
        "userId INTEGER NOT NULL,"
        "userType INTEGER NOT NULL,"
        "isOnline INTEGER DEFAULT 0,"
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
        dbBatch.execute(_createYearTable());
        dbBatch.execute(_createSemesterTable());
        dbBatch.execute(_createClassesTable());

        dbBatch.execute(_createDeptTable());
        dbBatch.execute(_createCourseTable());
        dbBatch.execute(_createCollegeTable());

        dbBatch.execute(_createStudentProfile());
        dbBatch.execute(_createParentProfile());
        dbBatch.execute(_createFacultyProfile());
        dbBatch.execute(_createNtStaffProfile());
        dbBatch.execute(_createHeadProfile());
        dbBatch.execute(_createMasterProfile());
        dbBatch.execute(_createStudentAttendanceTable());
        dbBatch.execute(_createFacultyAttendanceTable());
        dbBatch.execute(_createNtStaffAttendanceTable());
        dbBatch.execute(_createStudentLeaveTable());
        dbBatch.execute(_createFacultyLeaveTable());
        dbBatch.execute(_createNtStaffLeaveTable());
        await dbBatch.commit(noResult: true);
      });
    } catch (e) {
      if (kDebugMode) {
        log('profile initDB error');
        log(e.toString());
      }
    }
  }

  Future<dynamic> dynamicRead(String dbQuery, params) async {
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

  Future<dynamic> dynamicInsert(
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

  Future<void> forceLogOutAllUsers() async {
    try {
      final db = await initDB();
      String query =
          "UPDATE UserLoginSession SET loginStatus = 0, isOnline = 0;";

      var result = await db.rawQuery(query);

      if (kDebugMode) {
        log("All user forced logout status");
        log(result.toString());
      }

      // if (kDebugMode) {}
    } catch (e) {
      if (kDebugMode) {
        log("error checking user login session");
        log(e.toString());
      }
    }
  }
}
