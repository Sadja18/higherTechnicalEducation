// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:higher/services/database/handler.dart';
import 'package:http/http.dart' as http;
import '../../models/uri_paths.dart';

Future<dynamic> getFacultyLeaveRequestsFromServerMasterMode(
    int selectedDeptId) async {
  try {
    var dbQuery = "SELECT * FROM UserLoginSession WHERE loginStatus=1;";
    var params = [];
    var userCredentials = await DBProvider.db.dynamicRead(dbQuery, params);

    if (userCredentials != null && userCredentials.isNotEmpty) {
      var user = userCredentials[0];
      String dbQuery1 = "SELECT collegeId "
          "FROM Master "
          "WHERE "
          "userId = ("
          "SELECT userId FROM UserLoginSession WHERE loginStatus=1"
          ");";

      var college = await DBProvider.db.dynamicRead(dbQuery1, params);

      if (college != null && college.isNotEmpty) {
        String userName = user['userName'];
        String userPassword = user['userPassword'];
        String dbname = 'college';
        String str = "1";

        var collegeId = college[0]['collegeId'].toString();
        if (userName != null &&
            userName.isNotEmpty &&
            userPassword != null &&
            userPassword.isNotEmpty) {
          var response = await http.post(
            Uri.parse('$baseUriLocal$masterUriStart$masterUriFetchLeave'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'userName': userName,
              'userPassword': userPassword,
              'dbname': 'college',
              'deptId': selectedDeptId.toString(),
              'collegeId': collegeId,
              'str': str
            }),
          );

          if (response.statusCode == 200) {
            if (kDebugMode) {
              log(response.body);
            }
            var respBody = jsonDecode(response.body);
            if (respBody['message'].toString().toLowerCase() == 'success') {
              if (kDebugMode) {
                log('master mode faculty leaves');
                // log(response.body);
              }

              var data = respBody['data'];

              List<dynamic> leaveRequestsList = [];

              for (var leaveRequest in data) {
                int dbentryflag = 1;
                var leaveId = leaveRequest['id'];

                var leaveType = leaveRequest['name'];
                var leaveTypeId = 0;
                var leaveTypeName = "";
                if (leaveType != false &&
                    leaveType != null &&
                    leaveType.isNotEmpty) {
                  leaveTypeId = leaveType[0];
                  leaveTypeName = leaveType[1];
                } else {
                  dbentryflag = 0;
                }

                var leaveSession = leaveRequest['leave_session'];

                var leaveFacultyUser = leaveRequest['staff_id'];
                var leaveFacultyUserId = 0;
                var leaveFacultyUserName = "";
                if (leaveFacultyUser != null &&
                    leaveFacultyUser != false &&
                    leaveFacultyUser.isNotEmpty) {
                  leaveFacultyUserId = leaveFacultyUser[0];
                  leaveFacultyUserName = leaveFacultyUser[1];
                } else {
                  dbentryflag = 0;
                }

                var leaveReason = leaveRequest['reason'];
                var leaveFromDate = leaveRequest['start_date'];
                var leaveToDate = leaveRequest['end_date'];
                var leaveDays = leaveRequest['days'].toString();
                var leaveAppliedDate = leaveRequest['app_date'];

                var leaveRequestStatus = leaveRequest['state'];
                var isSynced = "no";
                if (leaveRequestStatus == "reject" ||
                    leaveRequestStatus == 'approve') {
                  isSynced = "yes";
                }

                var leaveRequestDept = leaveRequest['dept_id'];
                var leaveFacultyDeptId = 0;
                var leaveFacultyDeptName = "";
                if (leaveRequestDept != null &&
                    leaveRequestDept != false &&
                    leaveRequestDept.isNotEmpty) {
                  leaveFacultyDeptId = leaveRequestDept[0];
                  leaveFacultyDeptName = leaveRequestDept[1];
                } else {
                  dbentryflag = 0;
                }

                var leaveRequestCollege = leaveRequest['college_id'];
                var leaveRequestCollegeId = 0;
                var leaveRequestCollegeName = "";
                if (leaveRequestCollege != null &&
                    leaveRequestCollege != false &&
                    leaveRequestCollege.isNotEmpty) {
                  leaveRequestCollegeId = leaveRequestCollege[0];
                  leaveRequestCollegeName = leaveRequestCollege[1];
                } else {
                  dbentryflag = 0;
                }

                if (dbentryflag == 1) {
                  Map<String, Object> facultyLeaveRequestEntry = {
                    "leaveId": leaveId,
                    "leaveFacultyUserId": leaveFacultyUserId,
                    "leaveFacultyUserName": leaveFacultyUserName,
                    "leaveFacultyDeptId": leaveFacultyDeptId,
                    "leaveFacultyDeptName": leaveFacultyDeptName,
                    "leaveFacultyCollegeId": leaveRequestCollegeId,
                    "leaveFacultyCollegeName": leaveRequestCollegeName,
                    "leaveTypeId": leaveTypeId,
                    "leaveTypeName": leaveTypeName,
                    "leaveFromDate": leaveFromDate,
                    "leaveToDate": leaveToDate,
                    'leaveSession': leaveSession,
                    "leaveDays": leaveDays,
                    "leaveAppliedDate": leaveAppliedDate,
                    "leaveReason": leaveReason,
                    "leaveStatus": leaveRequestStatus,
                    "isSynced": isSynced,
                  };

                  await DBProvider.db.dynamicInsert(
                      "FacultyLeaveRequest", facultyLeaveRequestEntry);
                  leaveRequestsList.add(facultyLeaveRequestEntry);
                }
              }
            }
          }

          var query = "SELECT * FROM FacultyLeaveRequest "
              "WHERE "
              "leaveStatus=? "
              "AND "
              "isSynced=? "
              "AND "
              "leaveFacultyCollegeId = ("
              "SELECT collegeId FROM Master "
              "WHERE "
              "userId = ("
              "SELECT userId FROM UserLoginSession WHERE loginStatus=1"
              ")"
              ");";
          var params1 = ['toapprovep', 'no'];
          var records = await DBProvider.db.dynamicRead(query, params1);
          if (records != null && records.isNotEmpty) {
            return records;
          }
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('error fetching faculty leave requests master mode');
      log(e.toString());
    }
    if (e is SocketException) {
      var query = "SELECT * FROM FacultyLeaveRequest "
          "WHERE "
          "leaveStatus=? "
          "AND "
          "isSynced=? "
          "AND "
          "leaveFacultyCollegeId = ("
          "SELECT collegeId FROM Master "
          "WHERE "
          "userId = ("
          "SELECT userId FROM UserLoginSession WHERE loginStatus=1"
          ")"
          ");";
      var params1 = ['toapprovep', 'no'];
      var records = await DBProvider.db.dynamicRead(query, params1);
      if (records != null && records.isNotEmpty) {
        return records;
      }
    }
  }
}

Future<dynamic> getFacultyLeaveRequestsFromServerHeadMode() async {
  try {
    // Future.delayed(Duration(seconds: 6));
    var dbQuery = "SELECT * FROM UserLoginSession "
        "WHERE loginStatus=1;";
    var userCredentials = await DBProvider.db.dynamicRead(dbQuery, []);

    if (userCredentials != null && userCredentials.isNotEmpty) {
      var user = userCredentials[0];
      var userName = user['userName'];
      var userPassword = user['userPassword'];
      var str = '1';
      if (kDebugMode) {
        log('sending head fetch leave faculty request');
      }
      var response = await http.post(
        Uri.parse('$baseUriLocal$headUriStart$headUriFetchFacultyLeave'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userName': userName,
          'userPassword': userPassword,
          'dbname': 'college',
          'str': str
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          log(response.body);
        }
        var resp = jsonDecode(response.body);
        if (resp['message'].toString().toLowerCase() == 'success') {
          var data = resp['data'];
          var leaveRequestList = [];
          for (var leaveRequest in data) {
            var leaveId = leaveRequest['id'];
            var leaveTypeId = leaveRequest['name'][0];
            var leaveTypeName = leaveRequest['name'][1];
            var leaveSession = leaveRequest['leave_session'];
            var leaveFacultyUserId = leaveRequest['staff_id'][0];
            var leaveFacultyUserName = leaveRequest['staff_id'][1];
            var leaveReason = leaveRequest['reason'];
            var leaveRequestStatus = leaveRequest['state'];
            var leaveFacultyDeptId = leaveRequest['dept_id'][0];
            var leaveFacultyDeptName = leaveRequest['dept_id'][1];
            var leaveFacultyCollegeId = leaveRequest['college_id'][0];
            var leaveFacultyCollegeName = leaveRequest['college_id'][1];
            var leaveFromDate = leaveRequest['start_date'];
            var leaveToDate = leaveRequest['end_date'];
            var leaveDays = leaveRequest['days'].toString();
            var leaveAppliedDate = leaveRequest['app_date'];

            var isSynced = "no";
            if (leaveRequestStatus == "reject" ||
                leaveRequestStatus == 'approve' ||
                leaveRequestStatus == 'toapprovep') {
              isSynced = "yes";
            }

            Map<String, Object> facultyLeaveRequestEntry = {
              "leaveId": leaveId,
              "leaveFacultyUserId": leaveFacultyUserId,
              "leaveFacultyUserName": leaveFacultyUserName,
              "leaveFacultyDeptId": leaveFacultyDeptId,
              "leaveFacultyDeptName": leaveFacultyDeptName,
              "leaveFacultyCollegeId": leaveFacultyCollegeId,
              "leaveFacultyCollegeName": leaveFacultyCollegeName,
              "leaveTypeId": leaveTypeId,
              "leaveTypeName": leaveTypeName,
              "leaveFromDate": leaveFromDate,
              "leaveToDate": leaveToDate,
              'leaveSession': leaveSession,
              "leaveDays": leaveDays,
              "leaveAppliedDate": leaveAppliedDate,
              "leaveReason": leaveReason,
              "leaveStatus": leaveRequestStatus,
              "isSynced": isSynced,
            };

            await DBProvider.db
                .dynamicInsert("FacultyLeaveRequest", facultyLeaveRequestEntry);
            leaveRequestList.add(facultyLeaveRequestEntry);
          }
        }
      }
      var query = "SELECT * "
          "FROM FacultyLeaveRequest "
          "WHERE leaveStatus=? "
          "AND "
          "leaveFacultyDeptId=("
          "SELECT deptId FROM Head "
          "WHERE Head.userId=("
          "SELECT userId FROM UserLoginSession WHERE loginStatus=1"
          ")"
          ") "
          "AND "
          "leaveFacultyCollegeId=("
          "SELECT collegeId FROM Head "
          "WHERE Head.userId=("
          "SELECT userId FROM UserLoginSession WHERE loginStatus=1"
          ")"
          ")"
          ";";
      var params = ['toapprove'];
      var records = await DBProvider.db.dynamicRead(query, params);
      if (kDebugMode) {
        log('faculty leave request fetch approve leave screen');
        // log(records.toString());
      }

      if (records != null && records.isNotEmpty) {
        return records;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('error fetching faculty leave requests head mode');
      log(e.toString());
    }

    if (e is SocketException) {
      var query = "SELECT * "
          "FROM FacultyLeaveRequest "
          "WHERE leaveStatus=? "
          "AND "
          "leaveFacultyDeptId=("
          "SELECT deptId FROM Head "
          "WHERE Head.userId=("
          "SELECT userId FROM UserLoginSession WHERE loginStatus=1"
          ")"
          ") "
          "AND "
          "leaveFacultyCollegeId=("
          "SELECT collegeId FROM Head "
          "WHERE Head.userId=("
          "SELECT userId FROM UserLoginSession WHERE loginStatus=1"
          ")"
          ")"
          ";";
      var params = ['toapprove'];
      var records = await DBProvider.db.dynamicRead(query, params);
      if (kDebugMode) {
        log('faculty leave request fetch approve leave screen');
        log(records.toString());
      }
    }
  }
}

Future<dynamic> getStudentProfilesFromServerHeadMode() async {
  try {
    var dbQuery = "SELECT * FROM UserLoginSession WHERE loginStatus=1;";
    var params = [];
    var userCredentials = await DBProvider.db.dynamicRead(dbQuery, params);

    if (userCredentials != null && userCredentials.isNotEmpty) {
      if (kDebugMode) {
        log('sending head fetch leave faculty request');
      }
      var userName = userCredentials[0]['userName'];
      var userPassword = userCredentials[0]['userPassword'];
      var str = "1";
      var response = await http.post(
        Uri.parse('$baseUriLocal$headUriStart$headUriFetchStudentProfiles'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userName': userName,
          'userPassword': userPassword,
          'dbname': 'college',
          'str': str
        }),
      );
      if (response.statusCode == 200) {
        var resp = jsonDecode(response.body);
        if (resp['message'].toString().toLowerCase() == 'success') {
          var data = resp['data'];

          for (var student in data) {
            var studentId = student['id'];
            var fName = student['stu_name'];
            var mName = student['middle'];
            var lName = student['last'];
            var studentCode = student['student_code'];
            var course = student['course_id'];
            var noDept = student['no_dept'];
            var profilePic = student['photo'];
            var enrolNo = student['enrol_no'];
            var rollNo = student['roll_no'];
            var year = student['year'];
            var colYear = student['colyear'];
            var semester = student['semester'];
            var classVal = student['class_id'];
            var department = student['dept_id'];
            var college = student['college_id'];
            var pId = student['pid'];
            var userId = student['user_id'];
          }
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('fetch student profiles head mode error');
      log(e.toString());
    }
  }
}

Future<dynamic> getStudentLeaveRequestsFromServerHeadMode() async {
  try {
    var dbQuery = "SELECT * FROM UserLoginSession WHERE loginStatus=1;";
    var params = [];
    var userCredentials = await DBProvider.db.dynamicRead(dbQuery, params);

    if (userCredentials != null && userCredentials.isNotEmpty) {
      if (kDebugMode) {
        log('sending head fetch leave faculty request');
      }
      var userName = userCredentials[0]['userName'];
      var userPassword = userCredentials[0]['userPassword'];
      var str = "1";
      if (kDebugMode) {
        log('sending head fetch student leave requests');
      }
      var response = await http.post(
        Uri.parse('$baseUriLocal$headUriStart$headUriFetchStudentLeave'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userName': userName,
          'userPassword': userPassword,
          'dbname': 'college',
          "collegeId": "13",
          'str': str
        }),
      );
      if (kDebugMode) {
        log('student leave requests u=in head mode');
        log(response.statusCode.toString());
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          log('sending head fetch student leave requests');
          // log(response.body);
        }
        var resp = jsonDecode(response.body);
        if (resp['message'].toString().toLowerCase() == 'success') {
          var data = resp['data'];
          var leaveRequestList = [];
          if (kDebugMode) {
            log("sucesdagsrjbs,j");
            log(leaveRequestList.toString());
          }
          for (var leaveRequest in data) {
            var leaveId = leaveRequest['leaveId'];
            var leaveStudentProfileId = leaveRequest['leaveStudentProfileId'];
            var leaveStudentUserId = leaveRequest['leaveStudentUserId'];
            var leaveStudentClassId = leaveRequest['leaveStudentClassId'];
            var leaveStudentClassName = leaveRequest['leaveStudentClassName'];
            var leaveStudentDeptId = leaveRequest['leaveStudentDeptId'];
            var leaveStudentDeptName = leaveRequest['leaveStudentDeptName'];
            var leaveStudentCollegeId = leaveRequest['leaveStudentCollegeId'];
            var fName = leaveRequest['leaveStudentFirstName'];
            var mName = leaveRequest['leaveStudentMiddleName'];
            var lName = leaveRequest['leaveStudentLastName'];
            var leaveStudentName = fName + " " + mName + " " + lName;
            var leaveFromDate = leaveRequest['leaveFromDate'];
            var leaveToDate = leaveRequest['leaveToDate'];
            var leaveReason = leaveRequest['leaveReason'];
            var leaveDays = leaveRequest['leaveDays'];
            var leaveAttachment = leaveRequest['leaveAttachment'];
            var leaveStatus = leaveRequest['leaveStatus'];

            var dbEntry = <String, Object>{
              "leaveId": leaveId,
              "leaveStudentProfileId": leaveStudentProfileId,
              "leaveStudentUserId": leaveStudentUserId,
              "leaveStudentClassId": leaveStudentClassId,
              "leaveStudentClassName": leaveStudentClassName,
              "leaveStudentDeptId": leaveStudentDeptId,
              "leaveStudentDeptName": leaveStudentDeptName,
              "leaveStudentCollegeId": leaveStudentCollegeId,
              "leaveStudentName": leaveStudentName,
              "leaveFromDate": leaveFromDate,
              "leaveToDate": leaveToDate,
              "leaveReason": leaveReason,
              "leaveDays": leaveDays,
              "leaveAttachement": leaveAttachment,
              "leaveStatus": leaveStatus,
            };
            if (kDebugMode) {
              log("dbEntry");
              log(dbEntry.toString());
            }
            await DBProvider.db.dynamicInsert("StudentLeaveRequest", dbEntry);
          }
          // return leaveRequestList;
        }
      }
    }

    var params1 = ['toapprove'];
    var dbQuery1 = "SELECT * FROM StudentLeaveRequest "
        "WHERE "
        "leaveStudentDeptId=(SELECT deptId FROM Head "
        "WHERE userId = (SELECT userId FROM UserLoginSession WHERE loginStatus=1)) "
        "AND "
        "leaveStudentCollegeId=(SELECT collegeId FROM Head "
        "WHERE userId = (SELECT userId FROM UserLoginSession WHERE loginStatus=1)) "
        "AND "
        "leaveStatus=?;";

    var leaveOptions = await DBProvider.db.dynamicRead(dbQuery1, params1);

    if (leaveOptions != null && leaveOptions.isNotEmpty) {
      if (kDebugMode) {
        log("leave reqjdsfvgawefwrhkfjwer");
        log(leaveOptions.toString());
      }
      return leaveOptions;
    }
  } catch (e) {
    if (kDebugMode) {
      log('error fetching student leave requests head mode');
      log(e.toString());
    }
    if (e is SocketException) {
      var params = ['toapprove'];
      var dbQuery = "SELECT * FROM StudentLeaveRequest "
          "WHERE "
          "leaveStudentDeptId=(SELECT deptId FROM Head "
          "WHERE userId = (SELECT userId FROM UserLoginSession WHERE loginStatus=1)) "
          "AND "
          "leaveStudentCollegeId=(SELECT collegeId FROM Head "
          "WHERE userId = (SELECT userId FROM UserLoginSession WHERE loginStatus=1)) "
          "AND "
          "leaveStatus=?;";

      var leaveOptions = await DBProvider.db.dynamicRead(dbQuery, params);

      if (leaveOptions != null && leaveOptions.isNotEmpty) {
        if (kDebugMode) {
          log("leave reqjdsfvgawefwrhkfjwer");
          log(leaveOptions.toString());
        }
        return leaveOptions;
      }
    }
  }
}
