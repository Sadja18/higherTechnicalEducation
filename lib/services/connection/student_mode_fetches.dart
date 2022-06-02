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
    "leaveStudentUserId INTEGER NOT NULL,"
        "leaveStudentClassId INTEGER NOT NULL,"
        "leaveStudentDeptId INTEGER NOT NULL,"
        "leaveStudentDeptName TEXT,"
        "leaveStudentCollegeId INTEGER NOT NULL,"
        "leaveFromDate TEXT NOT NULL,"
        "leaveToDate TEXT NOT NULL,"
        "leaveDays TEXT NOT NULL,"
        "leaveReason TEXT NOT NULL,"
        "leaveAttachement TEXT,"
        "leaveStatus TEXT DEFAULT 'draft',";
    var leaveRequests = [
      {
        "leaveStudentUserId": 1915,
        "leaveStudentClassId": 108,
        "leaveStudentDeptId": 9,
        "leaveStudentDeptName": "Department of Chemistry",
        "leaveStudentCollegeId": 13,
        "leaveFromDate": "2022-05-20",
        "leaveToDate": "2022-05-21",
        "leaveDays": "2",
        "leaveReason": "Family Emergency",
        "leaveStatus": "reject",
      },
      {
        "leaveStudentUserId": 1915,
        "leaveStudentClassId": 108,
        "leaveStudentDeptId": 9,
        "leaveStudentDeptName": "Department of Chemistry",
        "leaveStudentCollegeId": 13,
        "leaveFromDate": "2022-06-01",
        "leaveToDate": "2022-06-01",
        "leaveDays": "1",
        "leaveReason": "Medical Leave",
        "leaveStatus": "toapprove",
      },
      {
        "leaveStudentUserId": 1915,
        "leaveStudentClassId": 108,
        "leaveStudentDeptId": 9,
        "leaveStudentDeptName": "Department of Chemistry",
        "leaveStudentCollegeId": 13,
        "leaveFromDate": "2022-05-22",
        "leaveToDate": "2022-05-23",
        "leaveDays": "2",
        "leaveReason": "Family Emergency",
        "leaveStatus": "reject",
      },
      {
        "leaveStudentUserId": 1915,
        "leaveStudentClassId": 108,
        "leaveStudentDeptId": 9,
        "leaveStudentDeptName": "Department of Chemistry",
        "leaveStudentCollegeId": 13,
        "leaveFromDate": "2022-05-28",
        "leaveToDate": "2022-05-28",
        "leaveDays": "1",
        "leaveReason": "Medical Leave",
        "leaveStatus": "approve",
      },
    ];

    return leaveRequests;
  } catch (e) {
    if (kDebugMode) {
      log(e.toString());
    }
  }
}
