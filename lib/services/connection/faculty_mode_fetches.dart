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

    // var response = await http.post(
    //     Uri.parse("$baseUriLocal$facultyUriStart$facultyUriFetchCourses"),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(requestBodyMap));
    // if (kDebugMode) {
    //   print('receiving fetch courses response');
    //   // log(response.statusCode.toString());
    // }

    // if (response.statusCode == 200) {
    //   var resp = jsonDecode(response.body);

    //   if (resp['message'].toString().toLowerCase() == 'success') {
    //     var courseArts = resp['data']['coursesArts'];
    //     // if (kDebugMode) {
    //     //   log(courseArts[0].toString());
    //     // }
    //     for (var i = 0; i < courseArts.length; i++) {
    //       var course = courseArts[i];
    //       if (kDebugMode) {
    //         log("course art ${i.toString()}");
    //         log(course.toString());
    //       }
    //       var courseId = course['id'];
    //       var courseName = course['name'].toString();
    //       var courseCode = (course['code'] != false && course['code'] != null)
    //           ? course['code'].toString()
    //           : course['name'].toString();

    //       var courseDuration = course['duration'];
    //       var collegeId = course['college_id'][0];
    //       var noDept = 'yes';

    //       Map<String, Object> dbEntry = {
    //         "courseId": courseId,
    //         "courseName": courseName,
    //         "courseCode": courseCode,
    //         "courseDuration": courseDuration,
    //         "collegeId": collegeId,
    //         "noDept": noDept,
    //       };
    //       // if (kDebugMode) {
    //       //   log(dbEntry.toString());
    //       // }

    //       await DBProvider.db.dynamicInsert("Course", dbEntry);
    //     }

    //     var courseAlt = resp['data']['coursesAlt'];
    //     // if (kDebugMode) {
    //     //   log(courseAlt[0].toString());
    //     // }
    //     for (var i = 0; i < courseAlt.length; i++) {
    //       var course = courseAlt[i];
    //       if (kDebugMode) {
    //         log("course alt ${i.toString()}");
    //         log(course.toString());
    //       }
    //       var courseId = course['id'];
    //       var courseName = course['name'].toString();
    //       var courseCode = (course['code'] != false && course['code'] != null)
    //           ? course['code'].toString()
    //           : course['name'].toString();
    //       var courseDuration = course['duration'];
    //       var collegeId = course['college_id'][0];
    //       var noDept = 'no';
    //       var dept = course['department_id'];

    //       Map<String, Object> dbEntry = {
    //         "courseId": courseId,
    //         "courseName": courseName,
    //         "courseCode": courseCode,
    //         "courseDuration": courseDuration,
    //         "collegeId": collegeId,
    //         "noDept": noDept,
    //       };
    //       if (dept != false && dept != null) {
    //         var deptId = course['department_id'][0];
    //         var deptName = course['department_id'][1];
    //         dbEntry["deptId"] = deptId;
    //         dbEntry["deptName"] = deptName;
    //       }
    //       // if (kDebugMode) {
    //       //   log(dbEntry.toString());
    //       // }
    //       await DBProvider.db.dynamicInsert("Course", dbEntry);
    //     }
    //   }
    // }

    String query = "SELECT courseCode FROM Course "
        "WHERE collegeId=(SELECT collegeId FROM Faculty WHERE userId = "
        "(SELECT userId FROM UserLoginSession WHERE loginStatus=1)) ORDER BY courseId;";
    var params = [];
    var courses = await DBProvider.db.dynamicRead(query, params);
    if (kDebugMode) {
      print(courses.runtimeType);
    }
    if (courses.isNotEmpty) {
      return courses;
    }
  } catch (e) {
    if (kDebugMode) {
      log("fetch course faculty mode error");
      log(e.toString());
    }
    // return [];
  }
}

Future<dynamic> getCourseDetails(String tableName, String courseCode) async {
  try {
    String dbQuery = "SELECT courseId, noDept, courseDuration FROM Course "
        "WHERE "
        "courseCode = ? AND "
        "collegeId = (SELECT collegeId FROM $tableName"
        " WHERE userId = "
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

Future<dynamic> getClassesForCourseId(int courseId) async {
  try {
    var userName = "dramitgcd@gmail.com";
    var userPassword = "faculty@1234";
    var dbname = "college";
    var collegeId = "13";
    var deptId = "9";
    var str = "1";

    Map<String, Object> requestBodyMap = {
      "userName": userName,
      "userPassword": userPassword,
      "dbname": dbname,
      "collegeId": collegeId,
      "deptId": deptId,
      "courseId": courseId,
      "str": str
    };

    // var response = await http.post(
    //   Uri.parse(
    //       "$baseUriLocal$facultyUriStart$facultyUriFetchClassesForCourseId"),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(requestBodyMap),
    // );

    // if (response.statusCode == 200) {
    //   if (kDebugMode) {
    //     log(response.body);
    //   }

    //   var resp = jsonDecode(response.body);

    //   if (resp['message'].toString().toLowerCase() == 'success') {
    //     var data = resp['data'];

    //     for (var i = 0; i < data.length; i++) {
    //       var classRecord = data[i];

    //       var college = classRecord['college_id'];
    //       var dept = classRecord['department_id'];
    //       var year = classRecord['year_id'];
    //       var sem = classRecord['sem_id'];

    //       if (college != null &&
    //           college != false &&
    //           college.isNotEmpty &&
    //           dept != null &&
    //           dept != false &&
    //           dept.isNotEmpty &&
    //           year != null &&
    //           year != false &&
    //           year.isNotEmpty &&
    //           sem != null &&
    //           sem != false &&
    //           sem.isNotEmpty) {
    //         await DBProvider.db.dynamicInsert("Year", <String, Object>{
    //           'yearId': year[0],
    //           'yearName': year[1],
    //         });
    //         await DBProvider.db.dynamicInsert("Semester", <String, Object>{
    //           'semId': sem[0],
    //           'semName': sem[1],
    //           'yearId': year[0],
    //         });
    //         String className = classRecord['display_name'] == false ||
    //                 classRecord['display_name'] == null
    //             ? classRecord['name']
    //             : classRecord['display_name'];
    //         Map<String, Object> dbEntry = {
    //           'classId': classRecord['id'],
    //           'className': className,
    //           'courseId': courseId,
    //           'yearId': year[0],
    //           'semId': sem[0],
    //         };
    //         await DBProvider.db.dynamicInsert("Classes", dbEntry);
    //       }
    //     }
    //   }
    // }
    String dbQuery = "SELECT className FROM Classes WHERE courseId = ?";
    var params = [courseId];
    var classes = await DBProvider.db.dynamicRead(dbQuery, params);

    if (classes.isNotEmpty) {
      return classes;
    }
  } catch (e) {
    if (kDebugMode) {
      log('fethc error course classes faculty mode');
      log(e.toString());
    }
    // return [];
  }
}

Future<dynamic> getClassDetails(int courseId, String className) async {
  try {
    var dbQuery =
        "SELECT classId, yearId, semId FROM Classes WHERE courseId=? AND className=?";
    var params = [courseId, className];
    var records = await DBProvider.db.dynamicRead(dbQuery, params);

    if (records.isNotEmpty) {
      if (kDebugMode) {
        print('class Dettails');
        print(records.toString());
      }
      return records[0];
    }
  } catch (e) {
    if (kDebugMode) {
      log('faculty error class details');
      log(e.toString());
    }
  }
}
