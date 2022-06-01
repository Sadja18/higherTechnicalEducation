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
