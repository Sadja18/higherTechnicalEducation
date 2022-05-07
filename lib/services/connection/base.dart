import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/uri_paths.dart';

Future<dynamic> isOnline() async {
  try {
    // String userName = "pplgovt-dmn-dd@nic.in";
    // String userPassword = 'collegeadmin@1234';
    // String dbname = 'college';

    var response =
        await http.get(Uri.parse('$baseUriLocal/checkIfOnline.php?get=1'));

    if (response.statusCode == 200) {
      var respBody = jsonDecode(response.body);
      String userName = "pplgovt-dmn-dd@nic.in";
      String userPassword = 'collegeadmin@1234';
      String dbname = 'college';
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
    String dbname = 'college';
    int collegeId = 13;
    String str = "1";
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
