// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:higher/services/database/handler.dart';
import 'package:http/http.dart' as http;
import '../../models/uri_paths.dart';

Future<dynamic> getFacultyLeaveRequestsFromServerMasterMode() async {
  try {
    String userName = "pplgovt-dmn-dd@nic.in";
    String userPassword = 'collegeadmin@1234';
    String dbname = 'college';
    String collegeId = '13';
    String str = '1';
    if (kDebugMode) {
      log("leave request fetch");
    }

    var response = await http.post(
      Uri.parse('$baseUriLocal$masterUriStart$masterUriFetchLeave'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userName': userName,
        'userPassword': userPassword,
        'dbname': 'college',
        'collegeId': collegeId,
        'str': str
      }),
    );

    if (response.statusCode == 200) {
      // return [response.body];
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
          if (leaveType != false && leaveType != null && leaveType.isNotEmpty) {
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
              "leaveStatus": leaveRequestStatus
            };

            await DBProvider.db.dynamicInsert(
                "FacultytLeaveRequest", facultyLeaveRequestEntry);
            leaveRequestsList.add(facultyLeaveRequestEntry);
          }
        }
        if (leaveRequestsList.isNotEmpty) {
          return leaveRequestsList;
        } else {
          return [];
        }
      }
    }

    return [
      {
        "leaveRequestId": 1,
        "leaveRequestName": 2,
      }
    ];
  } catch (e) {
    if (kDebugMode) {
      log('error fetching faculty leave requests master mode');
      log(e.toString());
    }
  }
}

Future<dynamic> getFacultyLeaveRequestsFromServerHeadMode() async {
  try {
    return [
      {
        "leaveRequestId": 1,
        "leaveRequestName": 2,
      }
    ];
  } catch (e) {
    if (kDebugMode) {
      log('error fetching faculty leave requests head mode');
      log(e.toString());
    }
  }
}
