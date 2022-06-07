// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:higher/services/database/handler.dart';
import 'package:http/http.dart' as http;
import '../../models/uri_paths.dart';

Future<dynamic> fetchSemesterAttendanceForCurrentStudent() async {
  try {
    var res = await DBProvider.db.dynamicRead(
        "SELECT * FROM UserLoginSession "
        "WHERE "
        "loginStatus=1;",
        []);
    var fetchedData = {
      "overall": ["51%"],
      "subjects": [
        {
          "subject": "Phy Practicals 102",
          "percentage": "20%",
        },
        {
          "subject": "Calculus & Matrix Algebra",
          "percentage": "11%",
        },
        {
          "subject": "Physics 101",
          "percentage": "55%",
        },
        {
          "subject": "Math Practicals 102",
          "percentage": "75%",
        }
      ],
      "errors": {},
      "meta": {}
    };
    var attendanceMap = {};
    attendanceMap['overall'] = fetchedData['overall'];

    var subjectWise = fetchedData['subjects'] as List;
    attendanceMap['subjects'] = fetchedData['subjects'];

    return attendanceMap;
  } catch (e) {
    if (kDebugMode) {
      log(e.toString());
    }
  }
}

Future<dynamic> readStudentLeaveRequestRecords() async {
  try {
    // fetch student leave request;

    var userQuery = "SELECT userName, userPassword FROM UserLoginSession "
        "WHERE "
        "loginStatus=1;";
    var userCredentials = await DBProvider.db.dynamicRead(userQuery, []);
    if (userCredentials != null && userCredentials.isNotEmpty) {
      var userName = userCredentials[0]['userName'];
      var userPassword = userCredentials[0]['userPassword'];
      var requestBodyMap = {
        "userName": userName,
        "userPassword": userPassword,
        "str": "1",
      };
      var resp = await http.post(
          Uri.parse('$baseUriLocal$studentUriStart$studentUriFetchLeave'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(requestBodyMap));

      if (resp.statusCode == 200) {
        if (kDebugMode) {
          log(resp.body);
        }
        var res = jsonDecode(resp.body);

        if (res['message'].toString().toLowerCase() == 'success') {
          var dbQueryStudent =
              "SELECT studentId, userId, studentName, classId, deptId, collegeId FROM Student "
              "WHERE "
              "userId = (SELECT userId FROM UserLoginSession WHERE loginStatus=1);";
          var studentProfile =
              await DBProvider.db.dynamicRead(dbQueryStudent, []);
          var classQuery = "SELECT className FROM Classes "
              "WHERE "
              "classId = ("
              "SELECT classId FROM Student WHERE userId="
              "(SELECT userId FROM UserLoginSession WHERE loginStatus=1)"
              ");";
          var deptQuery = "SELECT deptName FROM Dept "
              "WHERE "
              "deptId = ("
              "SELECT deptId FROM Student WHERE userId="
              "(SELECT userId FROM UserLoginSession WHERE loginStatus=1)"
              ");";
          // var collegeQuery = "SELECT collegeId FROM College "
          //     "WHERE "
          //     "collegeId = ("
          //     "SELECT collegeId FROM Student WHERE userId="
          //     "(SELECT userId FROM UserLoginSession WHERE loginStatus=1)"
          //     ");";

          var dept = await DBProvider.db.dynamicRead(deptQuery, []);
          var classV = await DBProvider.db.dynamicRead(classQuery, []);
          // var college = await DBProvider.db.dynamicRead(collegeQuery, []);

          if (dept != null &&
                  classV != null &&
                  // college != null &&
                  dept.isNotEmpty &&
                  classV.isNotEmpty
              // college.isNotEmpty
              ) {
            var studentProfileId = studentProfile[0]['studentId'];
            var studentUserId = studentProfile[0]['userId'];
            var studentName = studentProfile['studentName'];
            var deptId = studentProfile[0]['deptId'];
            var classId = studentProfile[0]['classId'];
            var collegeId = studentProfile[0]['collegeId'];

            var deptName = dept[0]['deptName'];
            var className = classV[0]['className'];

            Map<String, Object> baseEntry = {
              "leaveStudentProfileId": studentProfileId,
              "leaveStudentUserId": studentUserId,
              "leaveStudentName": studentName,
              "leaveStudentClassId": classId,
              "leaveStudentClassName": className,
              "leaveStudentDeptId": deptId,
              "leaveStudentDeptName": deptName,
              "leaveStudentCollegeId": collegeId,
            };
            var data = res['data'];

            for (var leaveRequest in data) {
              var leaveId = leaveRequest['id'];
              var leaveFromDate = leaveRequest['start_date'];
              var leaveToDate = leaveRequest['end_date'];
              var leaveDays = leaveRequest['days'];
              var leaveReason = leaveRequest['reason'];
              var state = leaveRequest['state'];

              var dbEntry = baseEntry;
              dbEntry['leaveId'] = leaveId;
              dbEntry['leaveFromDate'] = leaveFromDate;
              dbEntry['leaveToDate'] = leaveToDate;
              dbEntry['leaveReason'] = leaveReason;
              dbEntry['leaveDays'] = leaveDays;
              dbEntry['leaveStatus'] = state;

              await DBProvider.db.dynamicInsert("StudentLeaveRequest", dbEntry);
            }
          }
        }
      }
    }

    // "leaveStudentUserId INTEGER NOT NULL,"
    //     "leaveStudentClassId INTEGER NOT NULL,"
    //     "leaveStudentDeptId INTEGER NOT NULL,"
    //     "leaveStudentDeptName TEXT,"
    //     "leaveStudentCollegeId INTEGER NOT NULL,"
    //     "leaveFromDate TEXT NOT NULL,"
    //     "leaveToDate TEXT NOT NULL,"
    //     "leaveDays TEXT NOT NULL,"
    //     "leaveReason TEXT NOT NULL,"
    //     "leaveAttachement TEXT,"
    //     "leaveStatus TEXT DEFAULT 'draft',";
    var dbQuery = "SELECT * FROM StudentLeaveRequest "
        "WHERE "
        "leaveStudentUserId=("
        "SELECT userId FROM UserLoginSession WHERE loginStatus=1"
        ");";
    var params = [];
    var leaveRequests = await DBProvider.db.dynamicRead(dbQuery, params);
    if (leaveRequests == null || leaveRequests.isEmpty) {
      return [];
    } else {
      return leaveRequests;
    }
  } catch (e) {
    if (kDebugMode) {
      log(e.toString());
    }
  }
}

Future<dynamic> saveStudentLeaveRequestToLocalDB(String leaveStartDate,
    String leaveEndDate, double leaveDateDifference, String leaveReason) async {
  try {
    // if(kde)
    var dbQueryForStudentId = "SELECT "
        "Student.studentId, Student.userId, Student.studentName, "
        "Student.classId, "
        "Classes.className, "
        "Student.deptId, "
        "Dept.deptName, "
        "Student.collegeId "
        "FROM Student "
        "INNER JOIN Classes ON Student.classId = Classes.classId "
        "INNER JOIN Dept ON Student.deptId = Dept.deptId "
        "WHERE "
        "userId = (SELECT userId FROM UserLoginSession WHERE loginStatus=1)"
        ";";
    var params = [];

    var studentRecord =
        await DBProvider.db.dynamicRead(dbQueryForStudentId, params);
    if (kDebugMode) {
      log(leaveEndDate);
      log("start");
      log(leaveStartDate);
      log("reason");
      log(leaveReason);
      log('profile');
      log(studentRecord.toString());
    }
    if (studentRecord == null || studentRecord.isEmpty) {
      return "issue";
    } else {
      // return "continue to save";
      var student = studentRecord[0];
      var leaveStudentProfileId = student['studentId'];
      var leaveStudentUserId = student['userId'];
      var leaveStudentName = student['studentName'];
      var leaveStudentClassId = student['classId'];
      var leaveStudentClassName = student['className'];
      var leaveStudentDeptId = student['deptId'];
      var leaveStudentDeptName = student['deptName'];
      var leaveStudentCollegeId = student['collegeId'];
      var leaveFromDate = leaveStartDate;
      var leaveToDate = leaveEndDate;
      // var leaveReason = leaveReason;
      var leaveDays = leaveDateDifference.toString();
      var leaveStatus = 'toapprove';
      var leaveRequestData = <String, Object>{
        'leaveStudentProfileId': leaveStudentProfileId,
        "leaveStudentUserId": leaveStudentUserId,
        "leaveStudentName": leaveStudentName,
        "leaveStudentClassId": leaveStudentClassId,
        "leaveStudentClassName": leaveStudentClassName,
        "leaveStudentDeptId": leaveStudentDeptId,
        "leaveStudentDeptName": leaveStudentDeptName,
        "leaveStudentCollegeId": leaveStudentCollegeId,
        "leaveFromDate": leaveFromDate,
        "leaveToDate": leaveToDate,
        "leaveDays": leaveDays,
        "leaveReason": leaveReason,
        "leaveStatus": leaveStatus,
      };

      if (kDebugMode) {
        log(leaveRequestData.toString());
      }
      await DBProvider.db
          .dynamicInsert("StudentLeaveRequest", leaveRequestData);
      return "done";
    }
  } catch (e) {
    if (kDebugMode) {
      log("save student leave request to local db error");
      log(e.toString());
    }
  }
}
