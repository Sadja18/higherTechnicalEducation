import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/uri_paths.dart';
import '../../services/database/handler.dart';

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
  try {
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
          "dbname": dbname,
          "userId": userId.toString(),
          "userType": userType!,
          "isOnline": 1,
          "loginStatus": 1
        };
        // await DBProvider.db.dynamicInsert("UserLoginSession", userTableEntry);
      }
    }
  } catch (e) {
    if (kDebugMode) {
      log('student login error');
      log(e.toString());
    }
  }
}

Future<dynamic> sendParentLoginRequest(
    enteredUserName, enteredUserPassword) async {}
Future<dynamic> sendFacultyLoginRequest(
    enteredUserName, enteredUserPassword) async {}
Future<dynamic> sendNtStaffLoginRequest(
    enteredUserName, enteredUserPassword) async {}
Future<dynamic> sendHeadLoginRequest(
    enteredUserName, enteredUserPassword) async {}
Future<dynamic> sendMasterLoginRequest(
    enteredUserName, enteredUserPassword) async {}
