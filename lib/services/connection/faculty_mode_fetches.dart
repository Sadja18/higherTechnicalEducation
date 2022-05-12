// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:higher/services/database/handler.dart';
import 'package:http/http.dart' as http;
import '../../models/uri_paths.dart';

Future<dynamic> getCoursesFromServerFacultyMode() async {
  try {
    var userName = "dramitgcd@gmail.com";
    var userPassword = "faculty@1234";
    var dbname = "college";
    var collegeId = "13";
    var deptId = "9";
    var str = "1";

    Map<String, String> requestBodyMap = {
      "userName": userName,
      "userPassword": userPassword,
      "dbname": dbname,
      "collegeId": collegeId,
      "deptId": deptId,
      "str": str
    };
    if (kDebugMode) {
      print('sending fetch courses request');
    }

    var response = await http.post(
        Uri.parse("$baseUriLocal$facultyUriStart$facultyUriFetchCourses"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBodyMap));
    if (kDebugMode) {
      print('receiving fetch courses response');
      log(response.statusCode.toString());
    }

    if (response.statusCode == 200) {
      var resp = jsonDecode(response.body);

      if (resp['message'].toString().toLowerCase() == 'success') {
        var courseArts = resp['data']['coursesArts'];
        for (var course in courseArts) {
          var courseId = course['id'];
          var courseName = course['name'].toString();
          var courseCode = course['code'].toString();
          var courseDuration = course['duration'];
          var collegeId = course['collegeId'];
          var noDept = 'yes';

          await DBProvider.db.dynamicInsert("Course", <String, Object>{
            "courseId": courseId,
            "courseName": courseName,
            "courseCode": courseCode,
            "courseDuration": courseDuration,
            "collegeId": collegeId,
            "noDept": noDept,
          });
        }

        var courseAlt = resp['data']['coursesAlt'];
        for (var course in courseAlt) {
          var courseId = course['id'];
          var courseName = course['name'].toString();
          var courseCode = course['code'].toString();
          var courseDuration = course['duration'];
          var collegeId = course['collegeId'];
          var noDept = 'no';
          var deptId = course['department_id'][0];
          var deptName = course['department_id'][1];
          await DBProvider.db.dynamicInsert("Course", <String, Object>{
            "courseId": courseId,
            "courseName": courseName,
            "courseCode": courseCode,
            "courseDuration": courseDuration,
            "collegeId": collegeId,
            "noDept": noDept,
            "deptId": deptId,
            "deptName": deptName,
          });
        }
      }
    }

    String query = "SELECT courseCode FROM Course "
        "WHERE collegeId=(SELECT collegeId FROM Faculty WHERE userId = "
        "(SELECT userId FROM UserLoginSession WHERE loginStatus=1));";
    var params = [];
    var courses = await DBProvider.db.dynamicRead(query, params);
    if (courses.isNotEmpty) {
      var list = courses.list;
      return list;
    }
  } catch (e) {
    if (kDebugMode) {
      log("fetch course faculty mode error");
      log(e.toString());
    }
  }
}

Future<dynamic> getCourseDetails(String tableName, String courseCode) async {
  try {
    String dbQuery = "SELECT courseId, noDept, courseDuration FROM Course "
        "WHERE collegeId = (SELECT collegeId FROM $tableName"
        "(SELECT userId FROM UserLoginSession WHERE loginStatus=1));";
    List params = [courseCode];

    var res = await DBProvider.db.dynamicRead(dbQuery, params);

    if (res.isNotEmpty) {
      var data = res.toList()[0];
      return [data['courseId'], data['noDept'], data['courseDuration']];
    } else {
      return [];
    }
  } catch (e) {
    if (kDebugMode) {
      log("hgkhhk");
      log(e.toString());
      return [];
    }
  }
}
