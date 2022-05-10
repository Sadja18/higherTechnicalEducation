import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
    // String userName = "pplgovt-dmn-dd@nic.in";
    // String userPassword = 'collegeadmin@1234';
    //

    var response =
        await http.get(Uri.parse('$baseUriLocal/checkIfOnline.php?get=1'));

    if (response.statusCode == 200) {
      var respBody = jsonDecode(response.body);
      String userName = "pplgovt-dmn-dd@nic.in";
      String userPassword = 'collegeadmin@1234';

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
    String userName = "pplgovt-dmn-dd@nic.in";
    String userPassword = 'collegeadmin@1234';

    int collegeId = 13;

    var requestBodyMap = {
      "userName": userName,
      "userPassword": userPassword,
      "dbname": dbname,
      "collegeId": collegeId,
      "str": str,
    };

    var response = await http.post(
      Uri.parse('$baseUriLocal$masterUriStart$masterUriFetchDepartment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBodyMap),
    );

    if (response.statusCode == 200) {
      return response.body;
    }
  } catch (e) {
    if (kDebugMode) {
      log('dept fetch error');
      log(e.toString());
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
        await DBProvider.db.dynamicInsert("UserLoginSession", userTableEntry);
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

        var noDept = loginData['noDept'].toString();
        var year = loginData['year'];
        var semester = loginData['semester'];
        var course = loginData['course'];
        var department = loginData['department'];
        var courseId = 0;
        var courseName = "";

        var yearId = 0;
        var yearName = "";

        var semId = 0;
        var semName = "";

        var deptId = 0;
        var deptName = "";

        if (course != null && course != false) {
          courseId = course[0];
          courseName = course[1];
          studentProfileEntry['courseId'] = courseId;

          await DBProvider.db.dynamicInsert("Course", {
            "courseId": courseId,
            "courseName": courseName,
            "noDept": noDept
          });
          if (loginData['class'] != null && loginData['class'] != false) {
            var classId = loginData['class'][0];
            var className = loginData['class'][1];

            studentProfileEntry['classId'] = classId;
            await DBProvider.db.dynamicInsert("Classes", {
              "className": className,
              "classId": classId,
              'courseId': courseId
            });
            // saveFlag = 1;
          } else {
            if (noDept == 'true') {
              saveFlag = 0;
            }
          }
        }
        if (year != false && year != null) {
          yearId = year[0];
          yearName = year[1];
          studentProfileEntry['yearId'] = yearId;
          if (semester != false && semester != null) {
            semId = semester[0];
            semName = semester[1];
            studentProfileEntry['semId'] = semId;
            await DBProvider.db.dynamicInsert("Semester",
                {"semId": semId, "semName": semName, "yearId": yearId});
            // saveFlag = 1;
          } else {
            saveFlag = 0;
          }
          await DBProvider.db
              .dynamicInsert("Year", {"yearId": yearId, "yearName": yearName});
          // saveFlag = 1;
        } else {
          saveFlag = 0;
        }

        if (department != false && department != null) {
          deptId = department[0];
          deptName = department[1];
          studentProfileEntry['deptId'] = deptId;
          await DBProvider.db.dynamicInsert("Dept", {
            "deptId": deptId,
            "deptName": deptName,
            'collegeId': collegeId,
          });
          // saveFlag = 1;
        } else {
          saveFlag = 0;
        }

        if (studentProfileEntry['yearId'] != null &&
            studentProfileEntry['yearId'] != 0 &&
            studentProfileEntry['courseId'] != null &&
            studentProfileEntry['semId'] != 0 &&
            studentProfileEntry['semId'] != null) {
          await DBProvider.db.dynamicInsert("Student", studentProfileEntry);
        } else {
          saveFlag = 0;
        }

        if (kDebugMode) {
          log('userData');
          log(userTableEntry.toString());
          log('student');
          log(studentProfileEntry.toString());
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('student login error');
      log(e.toString());
    }
    saveFlag = 0;
  }
  return saveFlag;
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

    if (response.statusCode != 200) {
      saveFlag = 0;
    } else {
      var resp = jsonDecode(response.body);

      if (kDebugMode) {
        log(resp.toString());
        saveFlag = 0;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('parent login error');
      log(e.toString());
    }
  }
  return saveFlag;
}

Future<dynamic> sendFacultyLoginRequest(
    enteredUserName, enteredUserPassword) async {}
Future<dynamic> sendNtStaffLoginRequest(
    enteredUserName, enteredUserPassword) async {}
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
      log('master login ${response.statusCode}');
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
        };
        await DBProvider.db.dynamicInsert("UserLoginSession", userTableEntry);
        await DBProvider.db.dynamicInsert("Head", headTableEntry);
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

        userTableEntry['userId'] = userId;
        userTableEntry['userName'] = userName;
        userTableEntry['userPassword'] = userPassword;
        userTableEntry['userType'] = userTypes['master']!;
        userTableEntry['isOnline'] = 1;
        userTableEntry['loginStatus'] = 1;

        masterTableEntry['headName'] = headName;
        masterTableEntry['collegeName'] = collegeName;
        masterTableEntry['collegeCode'] = collegeCode;
        masterTableEntry['collegeId'] = collegeId;
        masterTableEntry['userId'] = userId;
        if (kDebugMode) {
          log(userTableEntry.toString());
          log(masterTableEntry.toString());
        }

        await DBProvider.db.dynamicInsert("UserLoginSession", userTableEntry);
        await DBProvider.db.dynamicInsert("Master", masterTableEntry);
        await DBProvider.db.dynamicInsert("College", <String, Object>{
          "collegeId": collegeId,
          "collegeName": collegeName
        });
        saveFlag = 1;
      } else {
        saveFlag = 0;
      }
    }
  } catch (e) {
    log('master login error');
    log(e.toString());
    saveFlag = 0;
  }
  return saveFlag;
}
