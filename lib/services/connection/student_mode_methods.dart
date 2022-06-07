// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:higher/services/database/handler.dart';
import 'package:http/http.dart' as http;
import '../../models/uri_paths.dart';

Future<dynamic> isStudentServerReachable() async {
  try {
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
        "dbname": "college",
        "str": 1
      };
      var resp = await http.post(
          Uri.parse('$baseUriLocal$studentUriStart$studentUriLogin'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(requestBodyMap));

      if (resp.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  } catch (e) {
    if (e is SocketException) {
      return 1;
    }
  }
}

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
          log("resp.body");
        }
        var res = jsonDecode(resp.body);

        if (res['message'].toString().toLowerCase() == 'success') {
          var dbQueryStudent =
              "SELECT studentId, userId, studentName, classId, deptId, collegeId FROM Student "
              "WHERE "
              "userId = (SELECT userId FROM UserLoginSession WHERE loginStatus=1);";
          var studentProfile =
              await DBProvider.db.dynamicRead(dbQueryStudent, []);
          if (kDebugMode) {
            log("step1al");
            // log(studentProfile.toString());
            log(studentProfile.runtimeType.toString());
          }
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
          // if (kDebugMode) {
          //   log("step1");
          // }

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
            // if (kDebugMode) {
            //   log("step12");
            // }
            var studentProfileId = studentProfile[0]['studentId'];
            // if (kDebugMode) {
            //   log("step13");
            // }
            var studentUserId = studentProfile[0]['userId'];
            // if (kDebugMode) {
            //   log("step14");
            // }
            var studentName = studentProfile[0]['studentName'];
            // if (kDebugMode) {
            //   log("step15");
            // }
            var deptId = studentProfile[0]['deptId'];
            // if (kDebugMode) {
            //   log("step16");
            // }
            var classId = studentProfile[0]['classId'];
            // if (kDebugMode) {
            //   log("step17");
            // }
            var collegeId = studentProfile[0]['collegeId'];
            // if (kDebugMode) {
            //   log("step19");
            // }
            var deptName = dept[0]['deptName'];
            // if (kDebugMode) {
            //   log("step20");
            // }
            var className = classV[0]['className'];
            // if (kDebugMode) {
            //   log("step21");
            // }

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
            if (kDebugMode) {
              log("step13");
              // log(baseEntry.toString());
            }
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

              // if (kDebugMode) {
              //   log("step14");
              //   log(dbEntry.toString());
              // }

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
    if (e is SocketException) {
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
      var leaveStatus = 'draft';
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

Future<dynamic> uploadStudentLeaveRequest() async {
  try {
    var userQuery = "SELECT userName, userPassword FROM UserLoginSession "
        "WHERE "
        "loginStatus=1;";
    var userCredentials = await DBProvider.db.dynamicRead(userQuery, []);
    if (kDebugMode) {
      log("sdmhgsdjh");
    }

    if (userCredentials != null && userCredentials.isNotEmpty) {
      var requestBase = {
        "userName": userCredentials[0]['userName'],
        "userPassword": userCredentials[0]['userPassword'],
        "dbname": 'college',
        "str": 1
      };
      if (kDebugMode) {
        log("wgrsdfgvfsdmhgsdjh");
      }

      var leaveQuery = "SELECT "
          "leaveStudentProfileId, leaveStudentClassId, leaveStudentCollegeId, "
          "leaveFromDate, leaveToDate, leaveDays, leaveReason, leaveStatus "
          "FROM StudentLeaveRequest "
          "WHERE "
          "leaveId IS NULL AND "
          "leaveStatus= ? AND "
          "leaveStudentUserId = ("
          "SELECT userId FROM UserLoginSession WHERE loginStatus=1"
          ");";

      var params = ['draft'];

      var records = await DBProvider.db.dynamicRead(leaveQuery, params);
      if (kDebugMode) {
        log("sdmhgsdjh");
        log((records != null).toString());
        log((records.isNotEmpty).toString());
      }

      if (records != null && records.isNotEmpty) {
        if (kDebugMode) {
          log("sync leave req");
          log(records.toString());
        }

        for (var leaveRequest in records) {
          //       "collegeId" : 13,
          // "studentId": "1297",
          // "classId": "105",
          // "startDate":"2022-06-07",
          // "endDate":"2022-06-07",
          // "days": "1",
          // "reason": "test reason 1",
          // "state": "toapprove"

          var requestBody = requestBase;
          requestBody['studentId'] = leaveRequest['leaveStudentProfileId'];
          requestBody['classId'] = leaveRequest['leaveStudentClassId'];
          requestBody['collegeId'] = leaveRequest['leaveStudentCollegeId'];
          requestBody['startDate'] = leaveRequest['leaveFromDate'];
          requestBody['endDate'] = leaveRequest['leaveToDate'];
          requestBody['days'] = leaveRequest['leaveDays'];
          requestBody['reason'] = leaveRequest['leaveReason'];
          requestBody['state'] = leaveRequest['leaveStatus'];

          if (kDebugMode) {
            log(requestBody.toString());
          }

          var upload = await http.post(
            Uri.parse(
                '$baseUriLocal$studentUriStart$studentUriPushLeaveRequest'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(requestBody),
          );
          if (kDebugMode) {
            log(upload.statusCode.toString());
            // log(upload.body);
          }

          if (upload.statusCode == 200) {
            if (kDebugMode) {
              log(upload.statusCode.toString());
              log(upload.body);
            }

            var updateLeaveRecord = "UPDATE StudentLeaveRequest "
                "SET leaveStatus=? "
                "WHERE "
                "leaveFromDate=? "
                "AND "
                "leaveToDate=?"
                "AND "
                "leaveStudentProfileId=?"
                "AND "
                "leaveStudentClassId=?;";

            var parms = [
              'toapprove',
              leaveRequest['leaveFromDate'],
              leaveRequest['leaveToDate'],
              leaveRequest['leaveStudentProfileId'],
              leaveRequest['leaveStudentClassId'],
            ];

            await DBProvider.db.dynamicRead(updateLeaveRecord, parms);
          }
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log("error uploading student leave request");
      log(e.toString());
    }
  }
}
