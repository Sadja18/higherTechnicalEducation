import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../helpers/validators/login_field_validators.dart';
import '../../models/uri_paths.dart';
import '../../services/database/handler.dart';
import '../../helpers/controllers/name_foramtter.dart';

const dbname = 'college';
const String str = "1";
const Map<String, Object> userTypes = {
  "student": 6,
  "parent": 5,
  "ntStaff": 4,
  "faculty": 3,
  "head": 2,
  "master": 1
};
Future<dynamic> isOnline() async {
  try {
    var response =
        await http.get(Uri.parse('$baseUriLocal/checkIfOnline.php?get=1'));

    if (response.statusCode == 200) {
      var respBody = jsonDecode(response.body);

      // String collegeId = '13';

      if (kDebugMode) {
        log(response.body);
      }
    }
  } catch (e) {
    log(e.toString());
  }
}

Future<dynamic> getDepartmentDataFromServerMasterMode() async {
  try {
    var dbQuery = "SELECT * FROM UserLoginSession WHERE loginStatus=1;";
    var params = [];
    var userCredentials = await DBProvider.db.dynamicRead(dbQuery, params);
    if (userCredentials != null && userCredentials.isNotEmpty) {
      var user = userCredentials[0];
      var userName = user['userName'];
      var userPassword = user['userPassword'];

      String dbQuery1 = "SELECT collegeId FROM Master WHERE "
          "userId = ("
          "SELECT userId FROM userLoginSession WHERE loginStatus=1"
          ");";

      var college = await DBProvider.db.dynamicRead(dbQuery1, params);
      var collegeId = college[0]['collegeId'];
      var requestBodyMap = {
        "userName": userName,
        "userPassword": userPassword,
        "dbname": dbname,
        "collegeId": collegeId,
        "str": str,
      };

      var response = await http.post(
        Uri.parse('$baseUriLocal$masterUriStart$masterUriFetchFacultyProfile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBodyMap),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          log(response.body);
        }

        var resp = jsonDecode(response.body);
        if (resp['message'].toString().toLowerCase() == 'success') {
          var data = resp['data'];

          for (var faculty in data) {
            var teacherId = faculty['id'];
            var userId = faculty['user_id'][0];
            var teacherName = faculty['name'];
            var teacherCode = faculty['teacher_code'];
            var employeeId = faculty['employee_id'][0];
            var isHoD = faculty['is_hod'] == true ? 'yes' : 'no';
            var deptId = faculty['dept_id'][0];
            var deptName = faculty['dept_id'][1];
            var profilePic = faculty['image'];
            var collegeId = faculty['college_id'][0];
            var collegeName = faculty['college_id'][1];

            await DBProvider.db.dynamicInsert("College", <String, Object>{
              "collegeId": collegeId,
              "collegeName": collegeName,
            });
            await DBProvider.db.dynamicInsert("Dept", <String, Object>{
              "deptId": deptId,
              "deptName": deptName,
              "collegeId": collegeId,
            });
            await DBProvider.db.dynamicInsert("Faculty", <String, Object>{
              "teacherId": teacherId,
              "userId": userId,
              "teacherName": teacherName,
              "teacherCode": teacherCode,
              "employeeId": employeeId,
              "isHoD": isHoD,
              "deptId": deptId,
              "deptName": deptName,
              "profilePic": profilePic,
              "collegeId": collegeId,
              "collegeName": collegeName,
            });
          }
        }
      }
      var depts = await DBProvider.db.dynamicRead(
          "SELECT * FROM Dept"
          " WHERE collegeId = (SELECT collegeId FROM master WHERE userId = "
          "(SELECT userId FROM UserLoginSession WHERE loginStatus=1));",
          []);
      if (depts != null && depts.isNotEmpty) {
        var deptList = depts.toList();
        return deptList;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('dept fetch error');
      log(e.toString());
      log("scheck hgvkjs");
      log((e is SocketException).toString());
    }
    if (e is SocketException) {
      var depts = await DBProvider.db.dynamicRead(
          "SELECT * FROM Dept"
          " WHERE collegeId = (SELECT collegeId FROM master WHERE userId = "
          "(SELECT userId FROM UserLoginSession WHERE loginStatus=1));",
          []);
      if (depts != null && depts.isNotEmpty) {
        var deptList = depts.toList();
        return deptList;
      }
    }
  }
}

Future<dynamic> sendStudentLoginRequest(
    enteredUserName, enteredUserPassword) async {
  int saveFlag = 1;

  try {
    if (kDebugMode) {
      log('sending login request');
    }
    var requestBodyMap = {
      "userName": enteredUserName,
      "userPassword": enteredUserPassword,
      "dbname": dbname,
      "str": str,
    };

    var response = await http.post(
      Uri.parse('$baseUriLocal$studentUriStart$studentUriLogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBodyMap),
    );
    if (kDebugMode) {
      log('student login ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      var resp = response.body;
      var respBody = jsonDecode(resp);
      // return respBody;
      if (respBody['message'].toString().toLowerCase() == 'success') {
        if (kDebugMode) {
          log(respBody['data'].toString());
        }
        var loginData = respBody['data'];

        var userId = loginData['userId'];
        var userType = userTypes["student"];

        Map<String, Object> userTableEntry = {
          "userName": enteredUserName,
          "userPassword": enteredUserPassword,
          "userId": userId.toString(),
          "userType": userType!,
          "isOnline": 1,
          "loginStatus": 1
        };
        // saveFlag = 1;

        var studentId = loginData['studentId'];
        var fName = loginData['fName'];
        var mName = (loginData['mName'] == false ||
                loginData['mName'] == '' ||
                loginData['mName'] == null)
            ? ''
            : loginData['mName'];
        var lName = (loginData['lName'] == false ||
                loginData['lName'] == '' ||
                loginData['lName'] == null)
            ? ''
            : loginData['lName'];
        var studentName = nameFormatter(fName, mName, lName);
        String studentCode = loginData['studentCode'].toString();
        var collegeId = loginData['collegeId'];
        var collegeName = loginData['collegeName'];

        await DBProvider.db.dynamicInsert(
            "College", {"collegeId": collegeId, "collegeName": collegeName});
        // saveFlag = 1;

        Map<String, Object> studentProfileEntry = {"studentId": studentId};
        studentProfileEntry['studentName'] = studentName;
        studentProfileEntry['studentCode'] = studentCode;
        studentProfileEntry['userId'] = userId;
        studentProfileEntry['collegeId'] = collegeId;

        var year = loginData['year'];
        var semester = loginData['semester'];
        var course = loginData['course'];
        var courseId = 0;
        var courseName = "";

        var yearId = year[0];
        var yearName = year[1];
        studentProfileEntry['yearId'] = yearId;

        await DBProvider.db.dynamicInsert("Year", <String, Object>{
          "yearId": yearId,
          "yearName": yearName,
        });

        var semId = semester[0];
        var semName = semester[1];
        await DBProvider.db.dynamicInsert("Semester", <String, Object>{
          "yearId": yearId,
          "semName": semName,
          "semId": semId,
        });
        studentProfileEntry['semId'] = semId;

        var deptId = 0;
        var deptName = "";

        var profilePic = loginData['profilePic'];
        studentProfileEntry['profilePic'] = profilePic;

        if (kDebugMode) {
          log(course['no_dept'].toString());
          log(course['no_dept'].runtimeType.toString());
        }

        if (course['no_dept'].toString().toLowerCase() == 'false') {
          if (kDebugMode) {
            log("// course with dept and class");
          }
          // course with dept and class

          courseId = course['0'];
          studentProfileEntry['courseId'] = courseId;

          courseName = course['1'];
          var courseCode = course['code'];
          var courseDuration = course['duration'];
          var dept = course['dept'];
          if (dept != null && dept != false) {
            if (kDebugMode) {
              log("// course with dept");
            }
            var deptId = dept[0];
            var deptName = dept[1];

            // first insert dept
            await DBProvider.db.dynamicInsert("Dept", <String, Object>{
              "deptId": deptId,
              "deptName": deptName,
              "collegeId": collegeId,
            });

            // insert course
            await DBProvider.db.dynamicInsert("Course", <String, Object>{
              "courseId": courseId,
              "courseName": courseName,
              "courseCode": courseCode,
              "courseDuration": courseDuration,
              "noDept": course['no_dept'].toString(),
              "collegeId": collegeId,
              "deptId": deptId,
              "deptName": deptName,
            });
            if (kDebugMode) {
              log("// course with dept 2");
            }

            var classV = loginData['class'];

            // insert class
            await DBProvider.db.dynamicInsert("Classes", <String, Object>{
              "classId": classV[0],
              "className": classV[1],
              "courseId": courseId,
              "yearId": yearId,
              "semId": semId
            });
            if (kDebugMode) {
              log("// class");
            }
            // insert student with class
            studentProfileEntry['courseId'] = courseId;
            studentProfileEntry['yearId'] = year[0];
            studentProfileEntry['semId'] = semId;
            studentProfileEntry['deptId'] = deptId;
            studentProfileEntry['classId'] = classV[0];
            await DBProvider.db.dynamicInsert("Student", studentProfileEntry);

            await DBProvider.db
                .dynamicInsert("UserLoginSession", userTableEntry);

            return 1;
          } else {
            return 0;
          }
        } else {
          // course with dept

          // insert course
          courseId = course['0'];
          studentProfileEntry['courseId'] = courseId;

          courseName = course['1'];
          var courseCode = course['code'];
          var courseDuration = course['duration'];
          await DBProvider.db.dynamicInsert("Course", <String, Object>{
            "courseId": courseId,
            "courseName": courseName,
            "courseCode": courseCode,
            "courseDuration": courseDuration,
            "noDept": course['no_dept'].toString(),
          });

          // insert student without class
          await DBProvider.db.dynamicInsert("Student", studentProfileEntry);

          await DBProvider.db.dynamicInsert("UserLoginSession", userTableEntry);

          return 1;
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('student login error');
      log(e.toString());
    }
    if (e is SocketException) {
      var queryT = "SELECT * FROM UserLoginSession "
          "WHERE "
          "userName = ? AND userPassword   = ?;";
      var params = [enteredUserName, enteredUserPassword];
      var r = await DBProvider.db.dynamicRead(queryT, params);

      if (r != null && r.isNotEmpty && r.length == 1) {
        var queryR = 'UPDATE UserLoginSession SET loginStatus=1, isOnline=0 '
            'WHERE '
            'userName=? AND userPassword=?';
        var s = await DBProvider.db
            .dynamicRead(queryR, [enteredUserName, enteredUserPassword]);
        return 1;
      } else {
        return 0;
      }
    }
  }
  // return 0;
}

Future<dynamic> sendParentLoginRequest(
    enteredUserName, enteredUserPassword) async {
  int saveFlag = 1;
  try {
    var requestBodyMap = {
      "userName": enteredUserName,
      "userPassword": enteredUserPassword,
      "dbname": "college",
      "str": 1,
    };

    if (kDebugMode) {
      log('sending parent login request');
    }
    var response = await http.post(
      Uri.parse("$baseUriLocal$parentUriStart$parentUriLogin"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBodyMap),
    );

    if (response.statusCode == 200) {
      var resp = jsonDecode(response.body);

      if (kDebugMode) {
        log(resp.toString());
        saveFlag = 0;
      }

      if (resp['message'].toString().toLowerCase() == 'success') {
        var data = resp['data'];
        var userName = data['userName'];
        var userPassword = data['userPassword'];
        var userId = data['userId'];
        var userType = userTypes["parent"]!;
        var loginStatus = 1;
        var isOnline = 1;
        var parentId = data['parentId'];
        var parentName = data['displayName'];
        var children = jsonEncode(data['children']);

        Map<String, Object> userTableEntry = {
          'userName': userName,
          'userPassword': userPassword,
          "userType": userType,
          "userId": userId,
          "loginStatus": loginStatus,
          "isOnline": isOnline
        };
        await DBProvider.db.dynamicInsert("UserLoginSession", userTableEntry);

        Map<String, Object> parentProfileEntry = {
          "parentId": parentId,
          "parentName": parentName,
          "userId": userId,
          "childrenStudentIdList": children,
        };

        await DBProvider.db.dynamicInsert("Parent", parentProfileEntry);
        saveFlag = 1;
      } else {
        saveFlag = 0;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('parent login error');
      log(e.toString());
    }
    if (e is SocketException) {
      var queryT = "SELECT * FROM UserLoginSession "
          "WHERE "
          "userName = ? AND userPassword   = ?;";
      var params = [enteredUserName, enteredUserPassword];
      var r = await DBProvider.db.dynamicRead(queryT, params);

      if (r != null && r.isNotEmpty && r.length == 1) {
        var queryR = 'UPDATE UserLoginSession SET loginStatus=1, isOnline=0 '
            'WHERE '
            'userName=? AND userPassword=?';
        var s = await DBProvider.db
            .dynamicRead(queryR, [enteredUserName, enteredUserPassword]);
        return 1;
      } else {
        return 0;
      }
    }
  }
  return saveFlag;
}

Future<dynamic> sendFacultyLoginRequest(
    enteredUserName, enteredUserPassword) async {
  int saveFlag = 0;

  try {
    var requestBodyMap = {
      "userName": enteredUserName,
      "userPassword": enteredUserPassword,
      "dbname": "college",
      "str": 1,
    };
    if (kDebugMode) {
      log('sending faculty login request');
    }

    var response = await http.post(
      Uri.parse('$baseUriLocal$facultyUriStart$facultyUriLogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBodyMap),
    );
    if (kDebugMode) {
      log(response.statusCode.toString());
      log(response.persistentConnection.toString());
    }

    if (response.statusCode == 200) {
      var resp = jsonDecode(response.body);

      if (kDebugMode) {
        log(response.body);
      }

      if (resp['message'].toString().toLowerCase() == 'success') {
        var data = resp['data'];
        var userName = data['userName'];
        var userPassword = data['userPassword'];
        var userId = data['userId'];
        var userType = userTypes['faculty']!;
        var isOnline = 1;
        var loginStatus = 1;

        await DBProvider.db.dynamicInsert("UserLoginSession", <String, Object>{
          "userName": userName,
          "userPassword": userPassword,
          "userId": userId,
          "userType": userType,
          "loginStatus": 1,
          "isOnline": 1
        });
        var collegeId = data['collegeId'];
        var collegeName = data['collegeName'];
        var deptId = data['deptId'];
        var deptName = data['deptName'];
        await DBProvider.db.dynamicInsert("Dept", <String, Object>{
          "deptId": deptId,
          "deptName": deptName,
          'collegeId': collegeId
        });

        await DBProvider.db.dynamicInsert("College", <String, Object>{
          "collegeId": collegeId,
          "collegeName": collegeName,
        });

        var teacherId = data['teacherId'];
        var empId = data['empId'];
        var teacherName = data['facultyName'];
        var teacherCode = data['teacherCode'];
        var isHod = data['isHoD'];

        var deptHeadFacultyUserId = data['deptHeadFacultyUserId'];
        var deptHeadName = data['deptHeadName'];

        var profilePic = data['profilePic'];

        await DBProvider.db.dynamicInsert("Faculty", <String, Object>{
          "teacherId": teacherId,
          "userId": userId,
          "teacherName": teacherName,
          "employeeId": empId,
          "teacherCode": teacherCode,
          "isHoD": isHod,
          "deptId": deptId,
          "deptName": deptName,
          "deptHeadFacultyUserId": deptHeadFacultyUserId,
          "deptHeadName": deptHeadName,
          "collegeId": collegeId,
          "collegeName": collegeName,
          'profilePic': profilePic,
        });
        saveFlag = 1;
      } else {
        saveFlag = 0;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log("faculty login error");
      log(e.toString());
    }
    if (e is SocketException) {
      var queryT = "SELECT * FROM UserLoginSession "
          "WHERE "
          "userName = ? AND userPassword   = ?;";
      var params = [enteredUserName, enteredUserPassword];
      var r = await DBProvider.db.dynamicRead(queryT, params);

      if (r != null && r.isNotEmpty && r.length == 1) {
        var queryR = 'UPDATE UserLoginSession SET loginStatus=1, isOnline=0 '
            'WHERE '
            'userName=? AND userPassword=?';
        var s = await DBProvider.db
            .dynamicRead(queryR, [enteredUserName, enteredUserPassword]);
        return 1;
      } else {
        return 0;
      }
    }
  }

  return saveFlag;
}

Future<dynamic> sendNtStaffLoginRequest(
    enteredUserName, enteredUserPassword) async {}

// head login request
Future<dynamic> sendHeadLoginRequest(
    enteredUserName, enteredUserPassword) async {
  int saveFlag = 1;
  try {
    if (kDebugMode) {
      log('sending head login');
    }

    var requestBodyMap = {
      "userName": enteredUserName,
      "userPassword": enteredUserPassword,
      "dbname": dbname,
      "str": str,
    };
    var response = await http.post(
      Uri.parse('$baseUriLocal$headUriStart$headUriLogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBodyMap),
    );
    if (kDebugMode) {
      log('head login ${response.statusCode}');
    }
    if (response.statusCode != 200) {
      if (kDebugMode) {
        print('here');
      }
      saveFlag = 0;
    } else {
      if (kDebugMode) {
        log(response.body);
      }

      var resp = jsonDecode(response.body);
      if (resp['message'].toString().toLowerCase() == 'success') {
        var data = resp['data'];
        var userId = data['userId'];
        var userName = data['userName'];
        var userPassword = data['userPassword'];
        var loginStatus = 1;
        var isOnline = 1;

        var collegeId = data['collegeId'];
        var collegeName = data['collegeName'];
        var deptId = data['deptId'];
        var deptName = data['deptName'];
        var teacherId = data['facultyId'];
        var teacherName = data['facultyName'];
        var profilePic = data['profilePic'];

        Map<String, Object> userTableEntry = {
          "userId": userId,
          "userName": userName,
          "userPassword": userPassword,
          "loginStatus": loginStatus,
          "isOnline": isOnline,
          "userType": userTypes['head']!,
        };

        Map<String, Object> headTableEntry = {
          "teacherId": teacherId,
          "teacherName": teacherName,
          "userId": userId,
          "deptName": deptName,
          "deptId": deptId,
          "collegeId": collegeId,
          "collegeName": collegeName,
          "profilePic": profilePic,
        };
        await DBProvider.db.dynamicInsert("Head", headTableEntry);

        await DBProvider.db.dynamicInsert("College", <String, Object>{
          "collegeId": collegeId,
          "collegeName": collegeName,
        });
        await DBProvider.db.dynamicInsert("Dept", <String, Object>{
          "collegeId": collegeId,
          "deptName": deptName,
          "deptId": deptId,
        });

        await DBProvider.db.dynamicInsert("UserLoginSession", userTableEntry);
        saveFlag = 1;
      } else {
        saveFlag = 0;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log("head login error");
      log(e.toString());
    }
    if (e is SocketException) {
      var queryT = "SELECT * FROM UserLoginSession "
          "WHERE "
          "userName = ? AND userPassword   = ?;";
      var params = [enteredUserName, enteredUserPassword];
      var r = await DBProvider.db.dynamicRead(queryT, params);

      if (r != null && r.isNotEmpty && r.length == 1) {
        var queryR = 'UPDATE UserLoginSession SET loginStatus=1, isOnline=0 '
            'WHERE '
            'userName=? AND userPassword=?';
        var s = await DBProvider.db
            .dynamicRead(queryR, [enteredUserName, enteredUserPassword]);
        return 1;
      } else {
        return 0;
      }
    }
  }
  return saveFlag;
}

Future<dynamic> sendMasterLoginRequest(
    enteredUserName, enteredUserPassword) async {
  int saveFlag = 1;

  try {
    if (kDebugMode) {
      log('sending master login request');
    }
    var requestBodyMap = {
      "userName": enteredUserName,
      "userPassword": enteredUserPassword,
      "dbname": dbname,
      "str": str,
    };

    if (kDebugMode) {
      log(requestBodyMap.toString());
    }

    var response = await http.post(
      Uri.parse('$baseUriLocal$masterUriStart$masterUriLogin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBodyMap),
    );
    if (kDebugMode) {
      log('master login ${response.statusCode}');
    }
    if (response.statusCode != 200) {
      if (kDebugMode) {
        print('here');
      }
      saveFlag = 0;
    } else {
      saveFlag = 0;
      var resp = jsonDecode(response.body);
      if (kDebugMode) {
        // log(response.body);
        log(resp.toString());
      }

      if (resp['message'].toString().toLowerCase() == 'success') {
        if (kDebugMode) {
          log("here ${resp.toString()}");
        }
        var data = resp['data'][0];
        if (kDebugMode) {
          log('master login data');
          log(data.toString());
        }

        Map<String, Object> userTableEntry = {};
        Map<String, Object> masterTableEntry = {};

        var userName = enteredUserName;
        var userPassword = enteredUserPassword;

        var userId = data['userId'];
        var headName = data['head_name'];
        var collegeName = data['com_name'];
        var collegeId = data['id'];
        var collegeCode = data['code'];
        var profileImage = data['s_image'] != null && data['s_image'] != false
            ? data['s_image']
            : defaultMasterProfilePic;

        userTableEntry['userId'] = userId;
        userTableEntry['userName'] = userName;
        userTableEntry['userPassword'] = userPassword;
        userTableEntry['userType'] = userTypes['master']!;
        userTableEntry['isOnline'] = 1;
        userTableEntry['loginStatus'] = 1;

        masterTableEntry['profilePic'] = profileImage;

        masterTableEntry['headName'] = headName;
        masterTableEntry['collegeName'] = collegeName;
        masterTableEntry['collegeCode'] = collegeCode;
        masterTableEntry['collegeId'] = collegeId;
        masterTableEntry['userId'] = userId;
        if (kDebugMode) {
          log(userTableEntry.toString());
          log(masterTableEntry.toString());
        }

        await DBProvider.db.dynamicInsert("Master", masterTableEntry);
        await DBProvider.db.dynamicInsert("College", <String, Object>{
          "collegeId": collegeId,
          "collegeName": collegeName
        });
        await DBProvider.db.dynamicInsert("UserLoginSession", userTableEntry);

        saveFlag = 1;
      } else {
        saveFlag = 0;
      }
    }
  } catch (e) {
    log('master login error');
    log(e.toString());
    if (e is SocketException) {
      var queryT = "SELECT * FROM UserLoginSession "
          "WHERE "
          "userName = ? AND userPassword   = ?;";
      var params = [enteredUserName, enteredUserPassword];
      var r = await DBProvider.db.dynamicRead(queryT, params);

      if (r != null && r.isNotEmpty && r.length == 1) {
        var queryR = 'UPDATE UserLoginSession SET loginStatus=1, isOnline=0 '
            'WHERE '
            'userName=? AND userPassword=?';
        var s = await DBProvider.db
            .dynamicRead(queryR, [enteredUserName, enteredUserPassword]);
        return 1;
      } else {
        return 0;
      }
    }
  }
  return saveFlag;
}

Future<dynamic> fetchStudentProfilesHeadMode() async {
  try {
    var dbname = 'college';
    var str = "1";

    var dbQuery = "SELECT * FROM UserSessionLogin WHERE loginStatus=1;";
    var params = [];
    var userCredentials = await DBProvider.db.dynamicRead(dbQuery, params);
    if (userCredentials != null && userCredentials.isNotEmpty) {
      var user = userCredentials[0];
      var userName = user['userName'];
      var userPassword = user['userPassword'];
      var requestBodyMap = {
        "userName": userName,
        "userPassword": userPassword,
        "dbname": dbname,
        'str': str,
      };
      if (kDebugMode) {
        log('head mode student profile fetch');
      }
      var response = await http.post(
        Uri.parse('$baseUriLocal$headUriStart$headUriFetchStudentProfiles'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBodyMap),
      );
      if (kDebugMode) {
        log('head mode student profile fetch response');
        log(response.statusCode.toString());
        log(response.body);
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('head mode error, fetch students');
      log(e.toString());
    }
  }
}

Future<int> getDeptIdFromDeptName(String tableName, String deptName) async {
  try {
    var dbQuery = "SELECT deptId FROM Dept WHERE "
        "deptName = '$deptName' AND "
        "collegeId = (SELECT collegeId FROM $tableName WHERE userId = "
        "(SELECT userId FROM userLoginSession WHERE loginStatus=1));";
    var params = [];
    var data = await DBProvider.db.dynamicRead(dbQuery, params);

    if (kDebugMode) {
      log(data.toString());
    }
    var deptId = 0;
    if (data.isNotEmpty && data[0]['deptId'] != null) {
      return data[0]['deptId'];
    }

    return deptId;
  } catch (e) {
    log(e.toString());
    return 0;
  }
}
